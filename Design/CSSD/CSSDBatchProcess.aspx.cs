using System;
using System.Web.Services;
using System.Web.UI;
using System.Text;
using System.Data;
using System.Web;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

public partial class Design_CSSD_CSSDBatchProcess : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");


            txtFromTime.Text = System.DateTime.Now.ToString("hh:mm tt");
            txtToTime.Text = System.DateTime.Now.ToString("hh:mm tt");
            calFrmDate.StartDate = DateTime.Now;
            calToDate.StartDate = DateTime.Now;
        }
        FrmDate.Attributes.Add("readonly", "readonly");
        ToDate.Attributes.Add("readonly", "readonly");
    }

    [WebMethod]
    public static string getBoilerList()
    {
        string sqlCommand = "SELECT BoilerId,NAME,isActive FROM `cssd_boilertypemaster`";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCommand));

    }
    [WebMethod(EnableSession = true)]
    public static string getSetList(string searchType)
    {
        StringBuilder sb = new StringBuilder();


        if (searchType == "1")
        {


            //sb.Append(" SELECT ItemName name,ItemID id FROM (  ");
            //sb.Append(" SELECT ItemName,SetTnxID ItemID,COUNT(*)Qty FROM (  ");
            //sb.Append(" SELECT cst.SetName ItemName,cst.SetID ItemID,(SUM(cst.ReceivedQty)-SUM(IFNULL(ctnx.Quantity,0))) Qty,1 IsSet,cst.SetStockID SetTnxID,  ");
            //sb.Append(" '' StockID,SUM(cst.`SetQuantity`-cst.`ReceivedQty`) 'PendingQTY' FROM    cssd_recieve_Set_stock cst   ");
            //sb.Append(" LEFT JOIN cssd_f_batch_tnxdetails ctnx ON cst.ID=ctnx.SetTnxID AND ctnx.IsProcess IN (1,2,4) AND ctnx.isset=1 and IFNULL(ctnx.`validityDate`,CURDATE())>=CURDATE()  ");
            //sb.Append(" WHERE cst.isactive=1  AND cst.IsReturned=0 GROUP BY  cst.SetStockID HAVING PendingQTY=0  ");
            //sb.Append(" )t WHERE Qty>0 GROUP BY ItemID  ");
            //sb.Append(" )t1 WHERE Qty>0   ");

            sb.Append("  SELECT ItemName name,ItemID id FROM ( ");
	        sb.Append("  SELECT ItemName,SetTnxID ItemID,COUNT(*)Qty FROM ( ");
		    sb.Append("  SELECT t.SetName ItemName,t.SetID ItemID,(SUM(t.RecQty)-SUM(IFNULL(t.setTnxQty,0))) Qty,1 IsSet,t.SetStockID SetTnxID,'' StockID,		 ");
		    sb.Append("  ((SELECT SUM(quantity) FROM `cssd_set_itemdetail` WHERE setId=t.setId)-SUM(t.RecQty))'SetPending',t.RecQty  ");
		    sb.Append("  FROM (		 ");
		    sb.Append("  SELECT (cstin.`SetQuantity`-SUM(cstin.`ReceivedQty`))'PendingQty',cstin.`SetStockID`,cstin.`SetID`,cstin.`ItemID`,  ");
		    sb.Append("  SUM(cstin.`ReceivedQty`)'RecQty',cstin.SetName,SUM(IFNULL(ctnx.Quantity,0)) 'setTnxQty' ");
		    sb.Append("  FROM cssd_recieve_Set_stock cstin  ");
		    sb.Append("  LEFT JOIN cssd_f_batch_tnxdetails ctnx ON cstin.ID=ctnx.SetTnxID AND ctnx.IsProcess IN (1,2,4) AND ctnx.isset=1  ");
		    sb.Append("  AND IFNULL(ctnx.`validityDate`,CURDATE())>=CURDATE()  	WHERE cstin.`IsReturned`=0 AND cstin.`IsActive`=1 ");
		    sb.Append("  GROUP BY cstin.`SetStockID`,cstin.`SetID`,cstin.`ItemID` HAVING PendingQty=0	)t  ");
		    sb.Append("  GROUP BY t.`SetStockID`,t.`SetID` HAVING SetPending=0 ");
	        sb.Append("  )t WHERE Qty>0 GROUP BY ItemID ");
            sb.Append("  )t1 WHERE Qty>0  ");



        }
        else
        {


            sb.Append(" SELECT CONCAT(req.`requestId`,' : ',lm.`LedgerName`)'name',req.`requestId` 'id'  FROM cssd_requisition req ");
            sb.Append(" INNER JOIN `f_ledgermaster` lm ON lm.`LedgerNumber`=req.`fromDept` ");
            sb.Append(" WHERE req.`status`=1 AND req.`IsBatchProcessed`=0  AND req.`toDept`='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' ");
            //if (searchType == "1")//For Against the Request Search
            //    sb.Append(" AND  req.`requestType`='Requested' ");
            //else
            sb.Append(" AND  req.`requestType`='Returned' ");
            sb.Append(" GROUP BY req.`requestId` ORDER BY req.`requestId`,lm.`LedgerName` ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string GetRequestDetails(string searchType, string id)
    {
        StringBuilder sb = new StringBuilder();
        if (searchType == "1") //For Against the Request Search
        {
            sb.Append(" SELECT '' AS 'RequestId',sm.`Name` 'SetName',im.`TypeName` 'ItemName',sm.`Set_ID` 'setId',im.`itemId`,smi.`Quantity` 'masterQty',smi.`Quantity` `reqQty` ");
            sb.Append(" ,SUM(IFNULL(st.`InitialCount`,0)-IFNULL(st.`ReleasedCount`,0)-IFNULL(bt.`Quantity`,0))StockQty ");
            sb.Append(" FROM cssd_f_set_master sm  ");
            sb.Append(" INNER JOIN cssd_set_itemdetail smi ON smi.`SetID`=sm.`Set_ID`  AND sm.`Set_ID`='" + id + "' ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=smi.`ItemID` ");
            sb.Append(" LEFT JOIN f_stock st ON im.`itemId`=st.ItemID  AND  st.DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  ");
            sb.Append(" AND st.`IsPost`=1 AND IF(st.`IsExpirable`=0,1=1,st.`MedExpiryDate`>NOW()) ");
            sb.Append(" LEFT JOIN cssd_f_batch_tnxdetails bt ON st.`StockID`=bt.`StockID` AND bt.`IsIssued`=0 AND IFNULL(bt.validityDate,CURDATE())>=CURDATE()  ");
            sb.Append(" GROUP BY im.`itemId` ");

        }
        else //For Return Search
        {
            sb.Append(" SELECT req.`requestId` 'RequestId',sm.`Name` 'SetName',im.`TypeName` 'ItemName',req.`setId`,req.`itemId`,req.`masterQty`,req.`reqQty`   ");
            //sb.Append(" ,SUM(IFNULL(st.InitialCount,0) - IFNULL(st.ReleasedCount,0) - IFNULL(cst.ReceivedQty, 0)-IFNULL(oths.Qty,0)-IFNULL(ctnx.Quantity, 0))'StockQty' ");

            sb.Append(",SUM(IFNULL(st.`InitialCount`,0)-IFNULL(st.`ReleasedCount`,0)-IFNULL(bt.`Quantity`,0))StockQty");
            sb.Append(" FROM cssd_requisition req  ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=req.`itemId` AND req.`status`=1 AND req.`IsBatchProcessed`=0 AND req.`requestId`='" + id + "' ");
            sb.Append(" INNER JOIN cssd_f_set_master sm ON sm.`Set_ID`=req.`setId`  ");
            sb.Append(" LEFT JOIN f_stock st ON req.`itemId`=st.ItemID  AND  st.DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' AND st.`IsPost`=1 AND IF(st.`IsExpirable`=0,1=1,st.`MedExpiryDate`>NOW()) ");
            //sb.Append(" LEFT JOIN cssd_stock_setstock css ON css.StockID=st.StockID AND css.SetStockID=''     ");
            //sb.Append(" LEFT JOIN ( ");
            //sb.Append(" SELECT setid,itemid,stockid,SetQuantity,SUM(ReceivedQty)ReceivedQty,SUM(ReturnedQty)ReturnedQty,setstockid  ");
            //sb.Append(" FROM cssd_recieve_Set_stock 	WHERE IsReturned=0  AND Setstockid='' AND BatchProcess=0  GROUP BY stockid ");
            //sb.Append(" )cst  ON css.StockID=cst.StockID    AND css.SetStockID=cst.SetStockID  ");
            //sb.Append(" LEFT JOIN  ( ");
            //sb.Append(" SELECT IFNULL(SUM(rec.ReceivedQty),0)Qty,css1.StockID FROM cssd_stock_setstock css1   ");
            //sb.Append(" INNER JOIN cssd_recieve_Set_stock rec ON css1.StockID=rec.StockID AND css1.SetStockID=rec.SetStockID  WHERE IsReturned = 0    ");
            //sb.Append(" AND BatchProcess = 0  AND rec.SetStockID<>'' GROUP BY stockid ");
            //sb.Append(" )oths ON oths.StockID=st.StockID  ");
            //sb.Append(" LEFT OUTER JOIN ( ");
            //sb.Append(" SELECT StockID,SUM(Quantity-ReleaseQuantity)Quantity FROM cssd_f_batch_tnxdetails WHERE IsProcess IN (1,2) GROUP BY stockID ");
            //sb.Append(" )ctnx ON st.StockID=ctnx.StockID GROUP BY req.`requestId`,req.`setId`,req.`itemId` ");
            sb.Append(" LEFT JOIN cssd_f_batch_tnxdetails bt ON st.`StockID`=bt.`StockID` AND bt.`IsIssued`=0 AND IFNULL(bt.validityDate,CURDATE())>=CURDATE()  GROUP BY req.`requestId`,req.`setId`,req.`itemId` ");


        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));



    }
    [WebMethod(EnableSession = true)]
    public static string saveData(List<batchItemsDetails> data, string boilerId, string boilerName, string aStartDate, string aEndTime, string remarks)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ExcuteCMD cmd = new ExcuteCMD();
            string sqlCommand = " SELECT get_cssd_batch_no(@boilerId); ";
            string batchNo = Util.GetString(cmd.ExecuteScalar(tnx, sqlCommand, CommandType.Text, new
            {
                boilerId = boilerId
            }));




            foreach (var item in data)
            {


                sqlCommand = " SELECT  cst.`ID`,cst.`SetName`,cst.`ItemName`,round(cst.`ReceivedQty`)ReceivedQty,cst.`SetID`,cst.`StockID`,(st.`InitialCount`-st.`ReleasedCount`)'AvailableQty',cst.`ItemID`,cst.`SetStockID`,cst.SetQuantity 'SetQuantity'  ";
                sqlCommand += "  FROM cssd_recieve_Set_stock cst INNER JOIN f_stock st ON st.`StockID`=cst.`StockID` WHERE cst.`SetStockID`='" + item.setStockId + "' ";
                DataTable dtAvailStock = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sqlCommand).Tables[0];
                if (dtAvailStock.Rows.Count == 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error in Stock. " });
                }
                foreach (DataRow dr in dtAvailStock.Rows)
                {

                    if (Util.GetDecimal(dr["ReceivedQty"].ToString()) > Util.GetDecimal(dr["AvailableQty"].ToString()))
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error in Stock of Item : <span class='patientInfo'>" + dr["ItemName"] + "</span>" });

                    }

                    cssd_f_batch_tnxdetails obj = new cssd_f_batch_tnxdetails(tnx);
                    obj.SetID = Util.GetString(dr["SetID"]);
                    obj.SetName = Util.GetString(dr["SetName"]);
                    obj.ItemID = Util.GetString(dr["ItemID"]);
                    obj.ItemName = Util.GetString(dr["ItemName"]); ;
                    obj.StockID = Util.GetString(dr["StockID"]);
                    obj.Quantity = Util.GetInt(dr["ReceivedQty"]);
                    obj.BatchName = batchNo;
                    obj.BatchNo = batchNo;
                    obj.BoilerType = boilerId;
                    obj.BoilerName = boilerName;
                    obj.startDate = Util.GetDateTime(Util.GetDateTime(aStartDate).ToString("yyyy-MM-dd HH:mm:ss"));
                    obj.EndDate = Util.GetDateTime(Util.GetDateTime(aEndTime).ToString("yyyy-MM-dd HH:mm:ss"));
                    obj.UserID = HttpContext.Current.Session["ID"].ToString();
                    obj.Remark = remarks;
                    obj.IsSet = 1;
                    obj.SetStockID = Util.GetString(dr["SetStockID"]);
                    obj.SetTnxID = Util.GetInt(dr["ID"].ToString());
                    obj.IsProcess = 1;
                    //if (item.processType == "1")
                    obj.processType = "";
                    //else
                    //    obj.processType = "Returned";
                    //obj.requestReturnId = item.requestId;
                    string Id = obj.Insert();
                }
                //sqlCommand = " UPDATE cssd_requisition req SET req.`IsBatchProcessed`=1 WHERE req.`requestId`=@requestId AND req.`setId`=@setId AND req.`itemId`=@itemId ";
                //cmd.DML(tnx, sqlCommand, CommandType.Text, new
                //{
                //    requestId = item.requestId,
                //    setId = item.setId,
                //    itemId = item.itemId
                //});

                sqlCommand = "update cssd_recieve_Set_stock set BatchProcess=1,IsProcessBatch=1  WHERE SetStockID=@setStockId  and IsSetMaster=1 and IsUpdateBatch=0";
                cmd.DML(tnx, sqlCommand, CommandType.Text, new
                {
                    setStockId = item.setStockId
                });


            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Batch No. :<span class='patientInfo'>" + batchNo + "</span> Processed." });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();


        }

    }
    [WebMethod]
    public static string getEditBoiler(string boilerId)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT NAME,SerialNo,IsActive,BatchPreFix FROM cssd_boilertypemaster WHERE BoilerId='" + boilerId + "' "));

    }
    [WebMethod(EnableSession = true)]
    public static string saveBoiler(string boilerName, string serialNo, string isActive, string boilerId, string batchPrefix)
    {
        string sql = " SELECT COUNT(*) FROM  `cssd_boilertypemaster` WHERE NAME='" + boilerName + "' AND BoilerId<>'" + boilerId + "'";
        int isExist = Util.GetInt(StockReports.ExecuteScalar(sql));
        if (isExist > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Boiler Already Exist." });


        if (boilerId != "" && boilerId != "0")
        {

            sql = "UPDATE cssd_boilertypemaster SET NAME=@NAME,SerialNo=@SerialNo,IsActive=@IsActive,updatedBy=@userId,BatchPreFix=@BatchPreFix,updatedDateTime=NOW() WHERE BoilerId=@boilerid";
        }
        else
        {

            sql = "INSERT INTO cssd_boilertypemaster(NAME,SerialNo,IsActive,createdBy,ipAddress,BatchPreFix)VALUES(@NAME,@SerialNo,@IsActive,@userId,@ipAddress,@BatchPreFix)";
        }
        ExcuteCMD cmd = new ExcuteCMD();
        cmd.DML(sql, CommandType.Text, new
        {
            NAME = boilerName,
            SerialNo = serialNo,
            IsActive = Util.GetInt(isActive),
            userId = HttpContext.Current.Session["ID"].ToString(),
            BatchPreFix = batchPrefix,
            ipAddress = All_LoadData.IpAddress(),
            boilerid = boilerId
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully." });
    }
    [WebMethod]
    public static string getSetDetails(string setStockId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sm.`Set_ID` 'id',sm.`Name` 'name',sm.`setDepartment`,(SELECT SUM(sd.`Quantity`)  FROM `cssd_set_itemdetail` sd WHERE sd.`SetID`=sm.`Set_ID` AND sd.`IsActive`=1)'ItemCount' ,cst.`SetStockID`  ");
        sb.Append(" ,sm.`Set_ID` 'setId' FROM `cssd_f_set_master` sm ");
        sb.Append(" INNER JOIN cssd_recieve_Set_stock cst  ON cst.`SetID`=sm.`Set_ID` AND cst.isactive=1  ");
        sb.Append(" WHERE  cst.`SetStockID`='" + setStockId + "' GROUP BY cst.`SetStockID` ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public static string getSetItemDetails(string setStockId)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(" SELECT cst.`SetName`,cst.`ItemName` 'ItemName',st.`BatchNumber` 'ItemBatch',SUM(cst.`ReceivedQty`) 'QTY' FROM cssd_recieve_Set_stock cst INNER JOIN f_stock st ON st.`StockID`=cst.`StockID` WHERE cst.`SetStockID`='" + setStockId + "' GROUP BY st.`ItemID`,st.`BatchNumber` "));


    }
}
public class batchItemsDetails
{

    public string setId { get; set; }
    public string setStockId { get; set; }



}