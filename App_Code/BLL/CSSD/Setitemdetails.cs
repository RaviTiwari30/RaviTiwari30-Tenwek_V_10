using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;

/// <summary>
/// Summary description for Setitemdetails
/// </summary>
public class Setitemdetails
{
    #region Overloaded Constructor

    public Setitemdetails()
    {
    }

    #endregion Overloaded Constructor

    public string SaveDetails(string ItemData)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string Id;
            ItemData = ItemData.TrimEnd('^');

            string str = "";
            int len = Util.GetInt(ItemData.Split('^').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('^');
            str = "update cssd_set_itemdetail set Isactive=0 WHERE SetID ='" + Item[0].Split('|')[1].ToString() + "' ";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            for (int i = 0; i < len; i++)
            {
                Set_Item_Detail obj = new Set_Item_Detail(Tnx);
                obj.SetID = Util.GetString(Item[i].Split('|')[1].Trim());
                obj.SetName = Util.GetString(Item[i].Split('|')[2].Trim());
                obj.ItemID = Util.GetString(Item[i].Split('|')[4].Split('#')[0].Trim());
                obj.ItemName = Util.GetString(Item[i].Split('|')[3].Trim().Split('#')[0]);
                obj.Quantity = Util.GetInt(Item[i].Split('|')[5].Trim());
                obj.UserID = HttpContext.Current.Session["ID"].ToString();
                obj.IsActive = 1;

                Id = obj.Insert();
            }

            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string EditSetItemsDetails(string ItemData)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string Id;
            ItemData = ItemData.TrimEnd('^');

            string str = "";
            int len = Util.GetInt(ItemData.Split('^').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('^');
            str = "update cssd_set_itemdetail set Isactive=0 WHERE  SetID ='" + Item[0].Split('|')[1].ToString() + "' ";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            for (int i = 0; i < len; i++)
            {
                Set_Item_Detail obj = new Set_Item_Detail(Tnx);
                obj.SetID = Util.GetString(Item[i].Split('|')[1].Trim());
                obj.SetName = Util.GetString(Item[i].Split('|')[2].Trim());
                obj.ItemID = Util.GetString(Item[i].Split('|')[3].Split('#')[0].Trim());
                obj.ItemName = Util.GetString(Item[i].Split('|')[4].Trim().Split('#')[0]);
                obj.Quantity = Util.GetInt(Item[i].Split('|')[6].Trim());
                obj.UserID = HttpContext.Current.Session["ID"].ToString();
                obj.IsActive = 1;

                Id = obj.Insert();
            }

            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable LoadSetItemsWithStock(string SetID, string SetStockID)
    {
        AllSelectQuery aq = new AllSelectQuery();
        string LedgerNumber = HttpContext.Current.Session["DeptLedgerNo"].ToString();
        return aq.LoadSetItemsWithStock(SetID, LedgerNumber, SetStockID);
    }

    public DataTable LoadSetItemsWithOutStock(string SetID)
    {
        AllSelectQuery aq = new AllSelectQuery();

        return aq.LoadSetItemsWithOutStock(SetID);
    }

    public string RecieveSet(object ItemData, string SetStockID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string Id;
            List<CssdReciveSet> dataItem = new JavaScriptSerializer().ConvertToType<List<CssdReciveSet>>(ItemData);
            string str = "";
            if (SetStockID == "")
            {
                MySqlParameter CDNo = new MySqlParameter();
                CDNo.ParameterName = "@SetTnxID";
                CDNo.MySqlDbType = MySqlDbType.String;
                CDNo.Size = 50;
                CDNo.Direction = ParameterDirection.Output;
                MySqlCommand cmd = new MySqlCommand("CSSD_GenerateSetTnxID", con, Tnx);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(CDNo);
                string SetTnxID = Util.GetString(cmd.ExecuteScalar());
                for (int i = 0; i < dataItem.Count; i++)
                {
                    CssdReciveSet obj = new CssdReciveSet(Tnx);

                    obj.SetID = Util.GetString(dataItem[i].SetID).Trim();
                    obj.SetName = HttpContext.Current.Server.UrlDecode(Util.GetString(dataItem[i].SetName).Trim());
                    obj.ItemID = Util.GetString(dataItem[i].ItemID).Trim();
                    obj.ItemName = HttpContext.Current.Server.UrlDecode(Util.GetString(dataItem[i].ItemName).Trim());
                    obj.SetQuantity = Util.GetInt(dataItem[i].SetQuantity);
                    obj.UserID = HttpContext.Current.Session["ID"].ToString();
                    obj.StockID = Util.GetString(dataItem[i].StockID).Trim();
                    obj.ReceivedQty = Util.GetFloat(dataItem[i].ReceivedQty);

                    obj.SetStockID = SetTnxID;
                    obj.IsSetMaster = 1;
                    obj.IsProcessBatch = 0;
                    obj.IsUpdateBatch = 0;
                    obj.IsActive = 1;

                    Id = obj.Insert();
                    Cssd_setstock cst = new Cssd_setstock();

                    cst.SetID = Util.GetString(dataItem[i].SetID).Trim();
                    cst.StockID = Util.GetString(dataItem[i].StockID).Trim();

                    cst.SetStockID = SetTnxID;
                    cst.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                    cst.Insert();
                    str = "update cssd_f_set_master set IsReceived=1  where  Set_ID='" + Util.GetString(dataItem[i].SetID).Trim() + "' ";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                }
            }
            else
            {
                string StockID = "";
                for (int i = 0; i < dataItem.Count; i++)
                {
                    StockID = StockReports.ExecuteScalar("SELECT StockID FROM cssd_recieve_Set_stock WHERE BatchProcess=0 AND SetID='" + Util.GetString(dataItem[i].SetID).Trim() + "' AND SetStockID='" + SetStockID + "' AND ItemID='" + Util.GetString(dataItem[i].ItemID).Trim() + "' and StockID ='" + Util.GetString(dataItem[i].StockID).Trim() + "' ");

                    if (StockID == "")
                    {
                        CssdReciveSet obj = new CssdReciveSet(Tnx);
                        obj.SetID = Util.GetString(dataItem[i].SetID).Trim();
                        obj.SetName = HttpContext.Current.Server.UrlDecode(Util.GetString(dataItem[i].SetName).Trim());
                        obj.ItemID = Util.GetString(dataItem[i].ItemID).Trim();
                        obj.ItemName = HttpContext.Current.Server.UrlDecode(Util.GetString(dataItem[i].ItemName).Trim());
                        obj.SetQuantity = Util.GetInt(dataItem[i].SetQuantity);
                        obj.UserID = HttpContext.Current.Session["ID"].ToString();
                        obj.StockID = Util.GetString(dataItem[i].StockID).Trim();
                        obj.ReceivedQty = Util.GetFloat(dataItem[i].ReceivedQty);
                        obj.SetStockID = SetStockID;
                        obj.IsSetMaster = 1;
                        obj.IsProcessBatch = 0;
                        obj.IsUpdateBatch = 0;
                        obj.IsActive = 1;

                        Id = obj.Insert();
                        Cssd_setstock cst = new Cssd_setstock();
                        cst.SetID = Util.GetString(dataItem[i].SetID).Trim();
                        cst.StockID = Util.GetString(dataItem[i].StockID).Trim();
                        cst.SetStockID = SetStockID;
                        cst.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                        cst.Insert();
                    }
                    else
                    {
                        str = "update cssd_recieve_Set_stock set ReceivedQty =ReceivedQty+" + Util.GetFloat(dataItem[i].ReceivedQty) + " Where  StockID ='" + Util.GetString(dataItem[i].StockID).Trim() + "' And SetStockID='" + SetStockID + "' AND setid='" + Util.GetString(dataItem[i].SetID).Trim() + "' AND ItemID='" + Util.GetString(dataItem[i].ItemID).Trim() + "'";
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                    }
                }
            }

            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable LoadSetHavingItem()
    {
        AllSelectQuery Aq = new AllSelectQuery();
        DataTable dt = Aq.LoadSetHavingItem();
        return dt;
    }
}