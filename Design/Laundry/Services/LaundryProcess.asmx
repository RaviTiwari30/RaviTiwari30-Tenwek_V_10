<%@ WebService Language="C#" Class="LaundryProcess" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
[WebService(Namespace = "http:www.itdoseinfo.com/2012/11/20")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]

public class LaundryProcess : System.Web.Services.WebService
{
    [WebMethod(EnableSession = true)]
    public string LoadDirtyItem(string fromDept, int type)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(Laundry.LoadDirtyItem(fromDept, type));

    }

    [WebMethod(EnableSession = true)]
    public string addDirtyItem(int ID, int type)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(Laundry.addDirtyItem(ID, type));

    }
    [WebMethod(EnableSession = true)]
    public string loadMachine(int type)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(Laundry.loadMachine(type));
    }
    [WebMethod(EnableSession = true, Description = "Update Laundry Processing")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string UpdateProcessing(object laundry, string startDate, string endDate, int machineID, string machineName, string Remark, string post)
    {
        List<laundry_stock_Detail> dataItem = new JavaScriptSerializer().ConvertToType<List<laundry_stock_Detail>>(laundry);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            for (int i = 0; i < dataItem.Count; i++)
            {
                

               StringBuilder sb = new StringBuilder();
               if (Util.GetInt(dataItem[i].type) == 1)
                   sb.Append(" UPDATE laundry_recieve_stock SET WashingQty =WashingQty+" + Util.GetDecimal(dataItem[i].ReturnQty) + " WHERE  ID=" + Util.GetInt(dataItem[i].ID) + "");
               else if (Util.GetInt(dataItem[i].type) == 2)
                   sb.Append(" UPDATE laundry_recieve_stock SET DryerQty =DryerQty+" + Util.GetDecimal(dataItem[i].ReturnQty) + " WHERE  ID=" + Util.GetInt(dataItem[i].ID) + "");
               else if (Util.GetInt(dataItem[i].type) == 3)
                   sb.Append(" UPDATE laundry_recieve_stock SET IroningQty =IroningQty+" + Util.GetDecimal(dataItem[i].ReturnQty) + " WHERE  ID=" + Util.GetInt(dataItem[i].ID) + "");

               MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

               string stockID = "";
                if (((Util.GetInt(dataItem[i].type) == 2) || (Util.GetInt(dataItem[i].type) == 3)) && (post == "True"))
                {
                    string stt = "SELECT StockID,ItemID,itemName,BatchNumber,Rate,DiscPer,DiscAmt,PurTaxPer , " +
                        " PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,UnitPrice,MRP,MedExpiryDate, " +
                        " SubCategoryID,UnitType from f_stock  where DeptLedgerNo = '" + dataItem[i].DeptLedgerNo + "' " +
                        " and IsPost=1 and StockID='" + Util.GetInt(dataItem[i].StockID) + "' AND CentreID='" + Session["CentreID"].ToString() + "'";
                    DataTable dtResult = MySqlHelper.ExecuteDataset(tranX, CommandType.Text, stt).Tables[0];

                    Stock objStock = new Stock(tranX);
                    objStock.Hospital_ID = Session["HOSPID"].ToString();
                    objStock.InitialCount = Util.GetDecimal(dataItem[i].ReturnQty);
                    objStock.BatchNumber = Util.GetString(dtResult.Rows[0]["BatchNumber"]);
                    objStock.ItemID = Util.GetString(dtResult.Rows[0]["ItemID"]);
                    objStock.ItemName = Util.GetString(dtResult.Rows[0]["ItemName"]);
                    objStock.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    objStock.IsFree = 0;
                    objStock.IsPost = 1;
                    objStock.PostDate = DateTime.Now;
                    objStock.MRP = Util.GetDecimal(dtResult.Rows[0]["MRP"]);
                    objStock.StockDate = DateTime.Now;
                    objStock.Unit = Util.GetString(dtResult.Rows[0]["UnitType"]);
                    objStock.SubCategoryID = Util.GetString(dtResult.Rows[0]["SubCategoryID"]);
                    objStock.UnitPrice = Util.GetDecimal(dtResult.Rows[0]["UnitPrice"]);
                    objStock.IsCountable = 1;
                    objStock.IsReturn = 0;
                    objStock.FromDept = dataItem[i].DeptLedgerNo;
                    objStock.FromStockID = Util.GetString(dataItem[i].StockID);
                    objStock.MedExpiryDate = Util.GetDateTime(dtResult.Rows[0]["MedExpiryDate"]);
                    objStock.RejectQty = 0;
                    objStock.StoreLedgerNo = "STO00002";
                    objStock.UserID = HttpContext.Current.Session["ID"].ToString();
                    objStock.PostUserID = HttpContext.Current.Session["ID"].ToString();
                    objStock.Rate = Util.GetDecimal(dtResult.Rows[0]["Rate"]);
                    objStock.TYPE = Util.GetString(dtResult.Rows[0]["TYPE"]);
                    objStock.IsBilled = Util.GetInt(dtResult.Rows[0]["IsBilled"]);
                    objStock.Reusable = Util.GetInt(dtResult.Rows[0]["Reusable"]);
                    objStock.SaleTaxPer = Util.GetDecimal(dtResult.Rows[0]["SaleTaxPer"]);
                    objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[0]["SaleTaxAmt"]);
                    objStock.PurTaxPer = Util.GetDecimal(dtResult.Rows[0]["PurTaxPer"]);
                    objStock.PurTaxAmt = Util.GetDecimal(dtResult.Rows[0]["PurTaxAmt"]);
                    objStock.DiscPer = Util.GetDecimal(dtResult.Rows[0]["DiscPer"]);
                    objStock.DiscAmt = Util.GetDecimal(dtResult.Rows[0]["DiscAmt"]);
                    objStock.SaleTaxAmt = Util.GetDecimal(dtResult.Rows[0]["SaleTaxAmt"]);
                    objStock.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    //objStock.HospCentreID = Util.GetInt(Session["HospCentreID"].ToString());
                    objStock.LaundryDirty = 1;
                    stockID = objStock.Insert();

                    if (stockID == string.Empty)
                    {
                        tranX.Rollback();
                        tranX.Dispose();
                        con.Close();
                        con.Dispose();
                        return "";
                    }
                    decimal returnQty = Util.GetDecimal(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT (lrs.returnQty-SUM(IFNULL(lrsd.returnQty,0)+" + Util.GetDecimal(dataItem[i].ReturnQty) + "))ActualQty  " +
                        " FROM laundry_recieve_stock lrs   LEFT JOIN laundry_recieve_stock_detail lrsd ON lrs.ID=lrsd.ProcessID AND lrsd.isprocess=" + Util.GetInt((dataItem[i].type)+1) + " WHERE lrs.ID=" + Util.GetInt(dataItem[i].ID) + "  GROUP BY lrs.ID"));

                    if (Util.GetDecimal(returnQty) == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE laundry_recieve_stock SET IsComplete=1 WHERE ID = "+Util.GetInt(dataItem[i].ID)+" ");
                    }
                }

                    laundry_stock_Detail lsd = new laundry_stock_Detail(tranX);
                    lsd.ProcessID = Util.GetInt(dataItem[i].ID);
                    lsd.StockID = Util.GetInt(dataItem[i].StockID);
                    lsd.ReturnQty = Util.GetDecimal(dataItem[i].ReturnQty);
                    lsd.MachineName = Util.GetString(machineName);
                
                    lsd.MachineID = Util.GetInt(machineID);
                    lsd.StartDate = Util.GetDateTime(startDate);
                    lsd.EndDate = Util.GetDateTime(endDate);
                    lsd.Remark = Util.GetString(Remark);
                    lsd.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                    lsd.ItemID = Util.GetString(dataItem[i].ItemID);
                    lsd.ItemName = Util.GetString(dataItem[i].ItemName);
                    if (Util.GetInt(dataItem[i].type) == 1)
                    {
                        lsd.IsProcess = 2;
                        if (Util.GetString(dataItem[i].MethodType) != "Select")
                            lsd.MethodType = Util.GetString(dataItem[i].MethodType);
                        else
                            lsd.MethodType = "";
                        lsd.batchType = Util.GetString(dataItem[i].batchType);
                    }
                    else if (Util.GetInt(dataItem[i].type) == 2)
                    {
                        lsd.IsProcess = 3;
                        lsd.MethodType = "";
                        lsd.batchType = Util.GetString(dataItem[i].batchType);
                    }
                    else if (Util.GetInt(dataItem[i].type) == 3)
                    {
                        lsd.IsProcess = 4;
                        lsd.MethodType = "";
                        lsd.batchType = Util.GetString(dataItem[i].batchType);
                    }
                    lsd.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    lsd.PostStockID = Util.GetInt(stockID);
                    if (stockID != "")
                        lsd.IsComplete = 1;
                    else
                        lsd.IsComplete = 0;
                    lsd.CentreID = Util.GetInt( Session["CentreID"].ToString());
                    //lsd.HospCentreID = Util.GetInt(Session["HospCentreID"].ToString());
                    lsd.Hospital_ID = Session["HOSPID"].ToString();
                    string returnID = lsd.Insert();


                    
                    // MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE f_nmstock SET IsPost=1,PostDate=NOW(),StockDate=CURDATE(),PostUserID='" + HttpContext.Current.Session["ID"].ToString() + "',laundryDirty=2 WHERE StockID='" + Util.GetInt(dataItem[i].StockID) + "'");
                    // MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE laundry_recieve_stock SET IsComplete=1,CompletedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE ID=" + Util.GetInt(dataItem[i].ID) + " ");

                

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
    public class laundryProcess
    {
        public int ID { get; set; }
        public string batchType { get; set; }
        public string methodType { get; set; }
        public string type { get; set; }
        public int StockID { get; set; }
        public decimal ReturnQty { get; set; }
        public string DeptLedgerNo { get; set; }
        public string ItemName { get; set; }
        public string ItemID { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public string getDateTime()
    {
        return System.DateTime.Now.ToString("dd-MMM-yyyy") + "#" + System.DateTime.Now.ToString("hh:mm tt");
    }

}