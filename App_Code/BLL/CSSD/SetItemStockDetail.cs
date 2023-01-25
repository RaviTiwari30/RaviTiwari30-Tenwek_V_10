

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web;

/// <summary>
/// Summary description for SetItemStock
/// </summary>
public class SetItemStockDetail
{
    public SetItemStockDetail()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataTable LoadSetItemStock()
    {
        AllSelectQuery aq = new AllSelectQuery();
        string LedgerNumber = HttpContext.Current.Session["DeptLedgerNo"].ToString();
        return aq.LoadSetItemStock(LedgerNumber);
    }

    public DataTable LoadSetItemStockNEW(string SetID, string SetStockID)
    {
        AllSelectQuery aq = new AllSelectQuery();
        return aq.LoadSetItemsWithOutStockSet(SetID, SetStockID);
    }

    public DataTable LoadSetItemStock(string ItemData)
    {
        string ItemID = Util.GetString(ItemData.Split('#')[0]);
        string IsSet = Util.GetString(ItemData.Split('#')[1]);
        AllSelectQuery aq = new AllSelectQuery();
        string LedgerNumber = HttpContext.Current.Session["DeptLedgerNo"].ToString();
        return aq.LoadSetItemStock(LedgerNumber, ItemID, IsSet);
    }

    public string SaveStockData(string ItemData)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string Id;
            ItemData = ItemData.TrimEnd('#');

            string str = "";
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');

            MySqlParameter CDNo = new MySqlParameter();
            CDNo.ParameterName = "@BatchID";

            CDNo.MySqlDbType = MySqlDbType.String;
            CDNo.Size = 11;
            CDNo.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand("CSSD_GenerateBatchID", con, Tnx);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(CDNo);
            string BatchNo = Util.GetString(cmd.ExecuteScalar());

            for (int i = 0; i < len; i++)
            {
                string IsSet = Util.GetString(Item[i].Split('|')[3].Trim());
                if (IsSet == "0")
                {
                    cssd_f_batch_tnxdetails obj = new cssd_f_batch_tnxdetails(Tnx);
                    obj.SetID = "";
                    obj.SetName = "";
                    obj.ItemID = Util.GetString(Item[i].Split('|')[0].Trim());
                    obj.ItemName = Util.GetString(Item[i].Split('|')[1].Trim());
                    obj.StockID = Util.GetString(Item[i].Split('|')[5].Trim());
                    obj.Quantity = Util.GetInt(Item[i].Split('|')[2].Trim());
                    obj.BatchName = Util.GetString(Item[i].Split('|')[6].Trim());
                    obj.BatchNo = BatchNo;

                    obj.BoilerType = Util.GetString(Item[i].Split('|')[7].Trim());
                    obj.BoilerName = Util.GetString(Item[i].Split('|')[8].Trim());
                    obj.startDate = Util.GetDateTime(Util.GetDateTime(Item[i].Split('|')[9].ToString()).ToString("yyyy-MM-dd HH:mm:ss"));
                    obj.EndDate = Util.GetDateTime(Util.GetDateTime(Item[i].Split('|')[10].ToString()).ToString("yyyy-MM-dd HH:mm:ss"));

                    obj.UserID = HttpContext.Current.Session["ID"].ToString();
                    obj.Remark = Util.GetString(Item[i].Split('|')[11].Trim());
                    obj.IsSet = 0;
                    obj.SetStockID = "";
                    obj.SetTnxID = 0;
                    obj.IsProcess = 1;
                    Id = obj.Insert();
                }
                else
                {
                    string setstock = "SELECT ID,SetID,SetName,ItemID,ItemName,StockID,(ReceivedQty-ReturnedQty)Quantity,SetStockID FROM cssd_recieve_set_stock WHERE SetStockID='" + Util.GetString(Item[i].Split('|')[4].Trim()) + "' and (ReceivedQty-ReturnedQty)>0 ";
                    DataTable dt = StockReports.GetDataTable(setstock);

                    if (dt.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dt.Rows)
                        {
                            cssd_f_batch_tnxdetails obj = new cssd_f_batch_tnxdetails(Tnx);
                            obj.SetID = Util.GetString(dr["SetID"].ToString());
                            obj.SetName = Util.GetString(dr["SetName"].ToString());
                            obj.ItemID = Util.GetString(dr["ItemID"].ToString());
                            obj.ItemName = Util.GetString(dr["ItemName"].ToString());
                            obj.StockID = Util.GetString(dr["StockID"].ToString());
                            obj.Quantity = Util.GetInt(dr["Quantity"].ToString());
                            obj.BatchName = Util.GetString(Item[i].Split('|')[6].Trim());
                            obj.BatchNo = BatchNo;

                            obj.BoilerType = Util.GetString(Item[i].Split('|')[7].Trim());
                            obj.BoilerName = Util.GetString(Item[i].Split('|')[8].Trim());
                            obj.startDate = Util.GetDateTime(Util.GetDateTime(Item[i].Split('|')[9].ToString()).ToString("yyyy-MM-dd HH:mm:ss"));
                            obj.EndDate = Util.GetDateTime(Util.GetDateTime(Item[i].Split('|')[10].ToString()).ToString("yyyy-MM-dd HH:mm:ss"));

                            obj.UserID = HttpContext.Current.Session["ID"].ToString();
                            obj.Remark = Util.GetString(Item[i].Split('|')[11].Trim());
                            obj.IsSet = 1;
                            obj.SetTnxID = Util.GetInt(dr["ID"].ToString());
                            obj.SetStockID = Util.GetString(dr["SetStockID"].ToString());
                            obj.IsProcess = 1;
                            Id = obj.Insert();
                        }
                    }
                    str = "update cssd_recieve_Set_stock set BatchProcess=1,IsProcessBatch=1  WHERE SetStockID='" + Util.GetString(Item[i].Split('|')[4].Trim()) + "'  and IsSetMaster=1 and IsUpdateBatch=0";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                }
            }

            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            throw (ex);
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    public static int IssueCSSDToDepartment(MySqlTransaction tnx, int salesNo, string CSSDRequisitionId, string setId, string itemId, string StockId, int issueQty, string batchTnxId, string toDeptLedgerNo, string setStockId, string setTnxId)
    {
        try
        {
            string sqlCommand = " SELECT im.`TypeName` 'ItemName',im.`SubCategoryID`,st.`MRP`,st.`unitPrice`,st.`UnitType`,st.`MedExpiryDate`,st.`StoreLedgerNo`,round((st.`InitialCount`-st.`ReleasedCount`))'AvailQty',st.`BatchNumber` ";
            sqlCommand += " ,st.`CGSTPercent`,st.`CGSTAmtPerUnit`,st.`SGSTPercent`,st.`SGSTAmtPerUnit`,st.`IGSTPercent`,st.`IGSTAmtPerUnit`,st.`GSTType`,st.`HSNCode` ";
            sqlCommand += " FROM f_stock st INNER JOIN f_itemmaster im ON im.`ItemID`=st.`ItemID` WHERE st.`StockID`='" + StockId + "' ";
            DataTable dtStockDetils = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sqlCommand).Tables[0];
            if (issueQty > Util.GetInt(dtStockDetils.Rows[0]["AvailQty"].ToString()))
                issueQty = Util.GetInt(dtStockDetils.Rows[0]["AvailQty"].ToString());


            Sales_Details ObjSales = new Sales_Details(tnx);
            ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            ObjSales.LedgerNumber = toDeptLedgerNo;
            ObjSales.DepartmentID = Util.GetString(dtStockDetils.Rows[0]["StoreLedgerNo"]);
            ObjSales.ItemID = itemId;
            ObjSales.StockID = StockId;
            ObjSales.SoldUnits = Util.GetDecimal(issueQty);
            ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtStockDetils.Rows[0]["unitPrice"]);
            ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtStockDetils.Rows[0]["MRP"]);
            ObjSales.Date = DateTime.Now;
            ObjSales.Time = DateTime.Now;
            ObjSales.IsReturn = 0;
            ObjSales.LedgerTransactionNo = "";
            ObjSales.TrasactionTypeID = 1;
            ObjSales.IsService = "NO";
            ObjSales.IndentNo = CSSDRequisitionId;
            ObjSales.SalesNo = salesNo;
            ObjSales.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
            ObjSales.UserID = HttpContext.Current.Session["ID"].ToString();
            ObjSales.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            decimal igstPercent = Util.GetDecimal(dtStockDetils.Rows[0]["IGSTPercent"]);
            decimal csgtPercent = Util.GetDecimal(dtStockDetils.Rows[0]["CGSTPercent"]);
            decimal sgstPercent = Util.GetDecimal(dtStockDetils.Rows[0]["SGSTPercent"]);

            decimal taxableAmt = (Util.GetDecimal(dtStockDetils.Rows[0]["MRP"]) * 100 * Util.GetDecimal(issueQty)) / (100 + igstPercent + csgtPercent + sgstPercent);
            decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
            decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
            decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);

            ObjSales.IGSTPercent = igstPercent;
            ObjSales.IGSTAmt = IGSTTaxAmount;
            ObjSales.CGSTPercent = csgtPercent;
            ObjSales.CGSTAmt = CGSTTaxAmount;
            ObjSales.SGSTPercent = sgstPercent;
            ObjSales.SGSTAmt = SGSTTaxAmount;
            ObjSales.HSNCode = Util.GetString(dtStockDetils.Rows[0]["HSNCode"]);
            ObjSales.GSTType = Util.GetString(dtStockDetils.Rows[0]["GSTType"]);
            string SalesID = ObjSales.Insert();
            if (SalesID == string.Empty)
            {
                Exception ex = new Exception("Error Occured In Sales Details.");
                throw (ex);
            }

            Stock objStock = new Stock(tnx);
            objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            objStock.InitialCount = issueQty;
            objStock.BatchNumber = Util.GetString(dtStockDetils.Rows[0]["BatchNumber"]);
            objStock.ItemID = itemId;
            objStock.ItemName = Util.GetString(dtStockDetils.Rows[0]["ItemName"]);
            objStock.DeptLedgerNo = toDeptLedgerNo;
            objStock.IsFree = 0;
            objStock.IsPost = 1;
            objStock.MRP = Util.GetDecimal(dtStockDetils.Rows[0]["MRP"]);
            objStock.StockDate = DateTime.Now;
            objStock.Unit = Util.GetString(dtStockDetils.Rows[0]["UnitType"]);
            objStock.SubCategoryID = Util.GetString(dtStockDetils.Rows[0]["SubCategoryID"]);
            objStock.UnitPrice = Util.GetDecimal(dtStockDetils.Rows[0]["unitPrice"]);
            objStock.IsCountable = 1;
            objStock.IsReturn = 0;
            objStock.FromDept = HttpContext.Current.Session["DeptLedgerNo"].ToString();
            objStock.FromStockID = StockId;
            objStock.IndentNo = CSSDRequisitionId;
            objStock.MedExpiryDate = Util.GetDateTime(dtStockDetils.Rows[0]["MedExpiryDate"]);
            objStock.RejectQty = 0;
            objStock.StoreLedgerNo = Util.GetString(dtStockDetils.Rows[0]["StoreLedgerNo"]);
            objStock.UserID = HttpContext.Current.Session["ID"].ToString();
            objStock.SetStockID = Util.GetString(setStockId);
            objStock.IsSet = 1;
            objStock.SetID = Util.GetInt(setId);
            objStock.SetStockQty = issueQty;
            objStock.IsSterlize = 1;
            objStock.PostDate = DateTime.Now;
            objStock.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());

            objStock.IGSTPercent = Util.GetDecimal(dtStockDetils.Rows[0]["IGSTPercent"]);
            objStock.IGSTAmtPerUnit = Util.GetDecimal(dtStockDetils.Rows[0]["IGSTAmtPerUnit"]);
            objStock.SGSTPercent = Util.GetDecimal(dtStockDetils.Rows[0]["SGSTPercent"]);
            objStock.SGSTAmtPerUnit = Util.GetDecimal(dtStockDetils.Rows[0]["SGSTAmtPerUnit"]);
            objStock.CGSTPercent = Util.GetDecimal(dtStockDetils.Rows[0]["CGSTPercent"]);
            objStock.CGSTAmtPerUnit = Util.GetDecimal(dtStockDetils.Rows[0]["CGSTAmtPerUnit"]);
            objStock.HSNCode = Util.GetString(dtStockDetils.Rows[0]["HSNCode"]);
            objStock.GSTType = Util.GetString(dtStockDetils.Rows[0]["GSTType"]);
            string stokID = objStock.Insert();

            if (stokID == string.Empty)
            {
                Exception ex = new Exception("Error Occured In Stock.");
                throw (ex);
            }



            //---- Update Release Count in Stock Table---------------------
            string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetFloat(issueQty) + " where StockID = " + StockId + "";

            int flag = Util.GetInt(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strStock));

            if (flag == 0)
            {
                Exception ex = new Exception("Error Occured In Stock Release Update.");
                throw (ex);
            }
            string sql = "UPDATE cssd_requisition req  SET req.`IssuedQty`=(req.`IssuedQty`+" + Util.GetFloat(issueQty) + ")  WHERE req.`requestId`='" + CSSDRequisitionId + "'  AND req.`setId`='" + setId + "' AND req.`itemId`='" + itemId + "' ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

            sql = "UPDATE cssd_f_batch_tnxdetails bt SET bt.`ReleaseQuantity`=(bt.`ReleaseQuantity`+" + Util.GetFloat(issueQty) + "),bt.IsIssued=1 WHERE bt.`ID`='" + batchTnxId + "'  ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

            sql = "INSERT INTO cssd_batchtnx_requisition(batchTnxId,requisitionid,IssuedQty,toStockId,setStockId,SetTnxID)VALUES(" + Util.GetInt(batchTnxId) + ",'" + CSSDRequisitionId + "'," + Util.GetInt(issueQty) + ",'" + stokID + "','" + setStockId + "','" + setTnxId + "')";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

            sql = " UPDATE cssd_recieve_set_stock SET ReturnedQty=(ReturnedQty+'" + Util.GetFloat(issueQty) + "'),IsReturned=1 WHERE ID='" + setTnxId + "' ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);




            return issueQty;
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw (ex);

        }




    }

    public static int returnToCSSD(MySqlTransaction tnx, int salesNo, string CSSDRequisitionId, MySqlConnection con)
    {

        try
        {
            string sql = " SELECT req.`toDept` 'ToDeptLedgerNo',st.`ItemID`,st.`StockID`,req.`reqQty`,ROUND((st.`InitialCount`-st.`ReleasedCount`))'AvailQty',st.`unitPrice`,st.`MRP`, ";
            sql += " req.`fromDept` 'FromDeptLedgerNo',st.`BatchNumber`,st.`ItemName`,st.`SubCategoryID`,st.`MedExpiryDate`,req.`setId`,st.`StoreLedgerNo`  ";
            sql += " ,st.`CGSTPercent`,st.`CGSTAmtPerUnit`,st.`SGSTPercent`,st.`SGSTAmtPerUnit`,st.`IGSTPercent`,st.`IGSTAmtPerUnit`,st.`GSTType`,st.`HSNCode`, st.`SetStockID`,sm.`Name` 'SetName' ";
            sql += "  FROM  cssd_requisition req  ";
            sql += " INNER JOIN cssd_batchtnx_requisition tr ON tr.`requisitionid`=req.`retrunAgainstRequestId` ";
            sql += "  INNER JOIN f_stock st ON st.`StockID`=tr.`toStockId` AND req.`itemId`=st.`ItemID` AND req.`setId`=st.`SetID` ";
            sql += " INNER JOIN `cssd_f_set_master` sm ON sm.`Set_ID`=req.`setId`  ";
            sql += "  WHERE req.`requestId`='" + CSSDRequisitionId + "' ORDER BY req.`setId`,st.`SetStockID` ";
            DataTable dtRequestItems = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sql).Tables[0];
            string previouseSetStockId = string.Empty;
            string SetTnxID = string.Empty;
            foreach (DataRow dr in dtRequestItems.Rows)
            {


                int ReturnedQty = 0;
                if (Util.GetInt(dr["reqQty"]) > Util.GetInt(dr["AvailQty"]))
                    ReturnedQty = Util.GetInt(dr["AvailQty"]);
                else
                    ReturnedQty = Util.GetInt(dr["reqQty"]);
                if (ReturnedQty > 0)
                {
                    Sales_Details ObjSales = new Sales_Details(tnx);
                    ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjSales.LedgerNumber = Util.GetString(dr["ToDeptLedgerNo"]);//to dept 
                    ObjSales.DepartmentID = Util.GetString(dr["StoreLedgerNo"]);
                    ObjSales.ItemID = Util.GetString(dr["ItemID"]);
                    ObjSales.StockID = Util.GetString(dr["StockID"]);
                    ObjSales.SoldUnits = Util.GetDecimal(ReturnedQty);
                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(dr["unitPrice"]);
                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(dr["MRP"]);
                    ObjSales.Date = DateTime.Now;
                    ObjSales.Time = DateTime.Now;
                    ObjSales.IsReturn = 0;
                    ObjSales.LedgerTransactionNo = "";
                    ObjSales.TrasactionTypeID = 1;
                    ObjSales.SalesNo = salesNo;
                    ObjSales.DeptLedgerNo = Util.GetString(dr["FromDeptLedgerNo"]);//from Dept
                    ObjSales.UserID = HttpContext.Current.Session["ID"].ToString();
                    ObjSales.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjSales.IpAddress = All_LoadData.IpAddress();
                    decimal igstPercent = Util.GetDecimal(dr["IGSTPercent"]);
                    decimal csgtPercent = Util.GetDecimal(dr["CGSTPercent"]);
                    decimal sgstPercent = Util.GetDecimal(dr["SGSTPercent"]);

                    decimal taxableAmt = (Util.GetDecimal(dr["MRP"]) * 100 * Util.GetDecimal(ReturnedQty)) / (100 + igstPercent + csgtPercent + sgstPercent);
                    decimal IGSTTaxAmount = Math.Round(taxableAmt * igstPercent / 100, 4, MidpointRounding.AwayFromZero);
                    decimal CGSTTaxAmount = Math.Round(taxableAmt * csgtPercent / 100, 4, MidpointRounding.AwayFromZero);
                    decimal SGSTTaxAmount = Math.Round(taxableAmt * sgstPercent / 100, 4, MidpointRounding.AwayFromZero);

                    ObjSales.IGSTPercent = igstPercent;
                    ObjSales.IGSTAmt = IGSTTaxAmount;
                    ObjSales.CGSTPercent = csgtPercent;
                    ObjSales.CGSTAmt = CGSTTaxAmount;
                    ObjSales.SGSTPercent = sgstPercent;
                    ObjSales.SGSTAmt = SGSTTaxAmount;
                    ObjSales.HSNCode = Util.GetString(dr["HSNCode"]);
                    ObjSales.GSTType = Util.GetString(dr["GSTType"]);
                    string SalesID = ObjSales.Insert();
                    if (SalesID == string.Empty)
                        return 0;

                    Stock objStock = new Stock(tnx);
                    objStock.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objStock.InitialCount = Util.GetDecimal(ReturnedQty);
                    objStock.BatchNumber = Util.GetString(dr["BatchNumber"]);
                    objStock.ItemID = Util.GetString(dr["ItemID"]);
                    objStock.ItemName = Util.GetString(dr["ItemName"]);
                    objStock.DeptLedgerNo = Util.GetString(dr["ToDeptLedgerNo"]);//to dept
                    objStock.IsFree = 0;
                    objStock.IsPost = 1;
                    objStock.MRP = Util.GetDecimal(dr["MRP"]);
                    objStock.StockDate = DateTime.Now;
                    objStock.SubCategoryID = Util.GetString(dr["SubCategoryID"]);

                    objStock.UnitPrice = Util.GetDecimal(dr["unitPrice"]);
                    objStock.IsCountable = 1;
                    objStock.IsReturn = 0;
                    objStock.FromDept = Util.GetString(dr["FromDeptLedgerNo"]); // from dept
                    objStock.FromStockID = Util.GetString(dr["StockID"]);

                    objStock.MedExpiryDate = Util.GetDateTime(dr["MedExpiryDate"]);
                    objStock.RejectQty = 0;
                    objStock.StoreLedgerNo = Util.GetString(dr["StoreLedgerNo"]);
                    objStock.UserID = HttpContext.Current.Session["ID"].ToString();
                    objStock.SetStockID = Util.GetString(dr["SetStockID"]);
                    objStock.IsSet = 1;
                    objStock.SetID = Util.GetInt(dr["setId"]);
                    objStock.IsSterlize = 0;
                    objStock.PostDate = DateTime.Now;
                    objStock.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    objStock.IpAddress = All_LoadData.IpAddress();
                    objStock.IGSTPercent = Util.GetDecimal(dr["IGSTPercent"]);
                    objStock.IGSTAmtPerUnit = Util.GetDecimal(dr["IGSTAmtPerUnit"]);
                    objStock.SGSTPercent = Util.GetDecimal(dr["SGSTPercent"]);
                    objStock.SGSTAmtPerUnit = Util.GetDecimal(dr["SGSTAmtPerUnit"]);
                    objStock.CGSTPercent = Util.GetDecimal(dr["CGSTPercent"]);
                    objStock.CGSTAmtPerUnit = Util.GetDecimal(dr["CGSTAmtPerUnit"]);
                    objStock.HSNCode = Util.GetString(dr["HSNCode"]);
                    objStock.GSTType = Util.GetString(dr["GSTType"]);
                    objStock.salesno = salesNo;
                    string stokID = objStock.Insert();

                    if (stokID == string.Empty)
                        return 0;

                    //---- Update Release Count in Stock Table---------------------
                    string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + Util.GetFloat(ReturnedQty) + " where StockID = " + Util.GetString(dr["StockID"]) + "";

                    int flag = Util.GetInt(MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, strStock));

                    if (flag == 0)
                        return 0;


                    //-----To Push Stock In Set -------

                    if (previouseSetStockId != dr["SetStockID"].ToString())
                    {

                        MySqlParameter CDNo = new MySqlParameter();
                        CDNo.ParameterName = "@SetTnxID";
                        CDNo.MySqlDbType = MySqlDbType.String;
                        CDNo.Size = 50;
                        CDNo.Direction = ParameterDirection.Output;
                        MySqlCommand cmd = new MySqlCommand("CSSD_GenerateSetTnxID", con, tnx);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(CDNo);
                        SetTnxID = Util.GetString(cmd.ExecuteScalar());
                    }

                    CssdReciveSet obj = new CssdReciveSet(tnx);

                    obj.SetID = Util.GetString(dr["setId"]).Trim();
                    obj.SetName = Util.GetString(dr["SetName"]);
                    obj.ItemID = Util.GetString(dr["ItemID"]).Trim();
                    obj.ItemName = Util.GetString(dr["ItemName"]);
                    obj.SetQuantity = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Quantity FROM `cssd_set_itemdetail` WHERE setId='" + Util.GetString(dr["setId"]).Trim() + "' AND ItemId='" + Util.GetString(dr["ItemID"]).Trim() + "'"));
                    obj.UserID = HttpContext.Current.Session["ID"].ToString();
                    obj.StockID = Util.GetString(stokID).Trim();
                    obj.ReceivedQty = Util.GetFloat(ReturnedQty);

                    obj.SetStockID = SetTnxID;
                    obj.IsSetMaster = 1;
                    obj.IsProcessBatch = 0;
                    obj.IsUpdateBatch = 0;
                    obj.IsActive = 1;

                    string Id = obj.Insert();
                    Cssd_setstock cst = new Cssd_setstock();

                    cst.SetID = Util.GetString(dr["setId"]).Trim();
                    cst.StockID = Util.GetString(stokID).Trim();

                    cst.SetStockID = SetTnxID;
                    cst.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                    cst.Insert();

                    //------------------------------


                    string sqlCommand = "UPDATE cssd_requisition req SET req.`returnedToSetStockId`=@setStockId WHERE req.`itemId`=@itemId AND req.`setId`=@setId AND req.`requestId`=@requestId";
                    ExcuteCMD comnd = new ExcuteCMD();
                    comnd.DML(tnx, sqlCommand, CommandType.Text, new
                    {
                        setStockId = SetTnxID,
                        itemId = Util.GetString(dr["ItemID"]).Trim(),
                        setId = Util.GetString(dr["setId"]).Trim(),
                        requestId = CSSDRequisitionId
                    
                    
                    });




                    previouseSetStockId = Util.GetString(dr["SetStockID"]);

                }
            }
            return 1;
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw (ex);

        }




    }
}