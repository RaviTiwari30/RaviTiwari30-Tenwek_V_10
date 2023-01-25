using System;
using System.Data;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

public partial class Design_CSSD_AcceptIssueCSSDRequisition : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            BindDepartments();
            calFrom.EndDate = DateTime.Now;
            calTo.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");

    }
    private void BindDepartments()
    {

        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' AND LedgerNumber<>'" + ViewState["DeptLedgerNo"] + "' ORDER BY LedgerName";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlFromDept.DataSource = dt;
            ddlFromDept.DataTextField = "LedgerName";
            ddlFromDept.DataValueField = "LedgerNumber";
            ddlFromDept.DataBind();
            ddlFromDept.Items.Insert(0, new ListItem("All", "0"));

        }
        else
        {
            ddlFromDept.Items.Insert(0, new ListItem("--No Data Bound--", "0"));
        }


    }

    [WebMethod(EnableSession = true)]
    public static string searchReqisition(string requestId, string fromDept, string status, string fromDate, string toDate, string requestType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT req.requestType,req.`requestId`,DATE_FORMAT(req.`createdDateTime`,'%d-%b-%Y %h:%i %p') 'DateTime', ");
        sb.Append(" rm.`RoleName` 'FromDept',CONCAT(em.`Title`,' ',em.`Name`)'CreatedBy',req.`status`,COUNT(DISTINCT req.`setId`) 'TotalSets',COUNT(req.`itemId`)'Total Items' ");
        sb.Append(" ,IFNULL((SELECT batchProcess FROM cssd_recieve_Set_stock WHERE SetStockID=req.`returnedToSetStockId` LIMIT 1),0) 'IsProcessed' ");
        sb.Append(" FROM cssd_requisition req  ");
        sb.Append(" INNER JOIN `f_rolemaster` rm ON rm.`DeptLedgerNo`=req.`fromDept` ");
        sb.Append(" INNER JOIN `employee_master` em ON em.`EmployeeID`=req.`userId` ");
        if (!String.IsNullOrEmpty(requestId))
            sb.Append(" WHERE req.`requestId`='" + requestId + "'  ");
        else
        {
            sb.Append(" WHERE req.`createdDateTime`>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND req.`createdDateTime`<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (!String.IsNullOrEmpty(status))
                sb.Append(" AND  req.`status`=" + Util.GetInt(status) + " ");
            if (fromDept != "" && fromDept != "0")
                sb.Append(" AND  req.`fromDept`='" + fromDept + "' ");

        }
        sb.Append(" AND req.`toDept`='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' AND req.requestType='" + requestType + "' ");
        sb.Append(" GROUP BY req.`requestId` ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string updateStatus(List<requestStatusData> data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlCommand = "UPDATE cssd_requisition req SET req.`status`=@status,req.AcceptedRejectedBy=@userId,req.AcceptedRejectedDateTime=NOW() WHERE req.`requestId`=@requestId";
            ExcuteCMD cmd = new ExcuteCMD();
            int SalesNo = 0;
            foreach (var item in data)
            {
                cmd.DML(tnx, sqlCommand, CommandType.Text, new
                {
                    status = Util.GetInt(item.status),
                    userId = HttpContext.Current.Session["ID"].ToString(),
                    requestId = item.requestId

                });

                if (item.requestType.ToLower().Trim() == "returned" && item.status == "1")
                {
                    if (SalesNo == 0)
                        SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_SalesNo('1','" + AllGlobalFunction.GeneralStoreID + "'," + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + ")"));
                    int isReturned = SetItemStockDetail.returnToCSSD(tnx, SalesNo, item.requestId, con);
                    if (isReturned != 1)
                    {

                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error In Stock Return." });

                    }

                }




            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully." });

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
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
    public static string getRequestDetails(string requestId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT req.`requestId`,sm.`Name` 'SetName',im.`TypeName` 'ItemName',req.`masterQty`,IFNULL(t.StockQty,0)  AS 'StockQty', ");
        sb.Append(" req.`reqQty`,req.`status`,req.`setId`,req.`itemId`,req.`fromDept` 'FromDeptLedgerNo',req.`requestType`,req.id,req.consumedQty  ");
        sb.Append(" ,IFNULL((SELECT batchProcess FROM cssd_recieve_Set_stock WHERE SetStockID=req.`returnedToSetStockId` LIMIT 1),0) 'IsProcessed',IFNULL(req.`returnedToSetStockId`,'')toSetStockId,req.Comment ");
        sb.Append(" FROM cssd_requisition req  ");
        sb.Append(" INNER JOIN `f_itemmaster` im ON im.`ItemID`=req.`itemId` ");
        sb.Append(" INNER JOIN cssd_f_set_master sm ON sm.`Set_ID`=req.`setId` ");
        sb.Append(" LEFT JOIN (SELECT SUM(bt.`Quantity`-bt.ReleaseQuantity)'StockQty',bt.`SetID`,bt.`ItemID` FROM  ");
        sb.Append(" cssd_f_batch_tnxdetails bt    INNER JOIN cssd_recieve_Set_stock cst ON cst.`ID`=bt.`SetTnxID` AND cst.IsUpdateBatch=1    WHERE bt.`IsProcess`=2  AND bt.`validityDate`>=CURDATE()   ");
        sb.Append(" AND (bt.`Quantity`-bt.ReleaseQuantity)>0 ");// AND bt.`requestReturnId`='" + requestId + "' ");
        sb.Append(" GROUP BY bt.`SetID`,bt.`ItemID`  ");
        //sb.Append(" UNION ALL  ");
        //sb.Append(" SELECT SUM(bt.`Quantity`-bt.ReleaseQuantity)'StockQty',bt.`SetID`,bt.`ItemID` FROM  ");
        //sb.Append(" cssd_f_batch_tnxdetails bt WHERE bt.`IsProcess`=2  AND bt.`validityDate`>=CURDATE()   ");
        //sb.Append(" AND (bt.`Quantity`-bt.ReleaseQuantity)>0  AND bt.`processType`='Returned' ");
        //sb.Append(" GROUP BY bt.`SetID`,bt.`ItemID`  ");

        sb.Append(" )t  ON t.`SetID`=req.`setId` AND t.`ItemID`=req.`itemId` ");
        sb.Append(" WHERE req.`requestId`='" + requestId + "' ORDER BY sm.`Name`,im.`TypeName` ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public static string issueRequisition(List<issueRequestData> data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_SalesNo('1','" + AllGlobalFunction.GeneralStoreID + "','" + HttpContext.Current.Session["CentreID"].ToString() + "') "));
            foreach (var item in data)
            {
                if (item.issueQty > 0)
                {

                    // First of All Check Processed Stock Against the Current Request
                    string sqlCommad = "SELECT bt.`ID`,ROUND((bt.`Quantity`-bt.`ReleaseQuantity`))'AvailQty',bt.`StockID`,bt.`SetStockID`,bt.`SetTnxID` FROM cssd_f_batch_tnxdetails bt WHERE bt.`SetID`='" + item.setId + "' AND bt.`ItemID`='" + item.itemId + "' AND bt.`validityDate`>=CURDATE() AND bt.`processType`='' and  (bt.`Quantity`-bt.`ReleaseQuantity`)>0  ORDER BY (bt.`Quantity`-bt.`ReleaseQuantity`) DESC  ";
                    DataTable dtGetIssueQty = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sqlCommad).Tables[0];
                    int remainingQty = item.issueQty;
                    int issueQty = 0;
                    foreach (DataRow dr in dtGetIssueQty.Rows)
                    {
                        if (remainingQty > Util.GetInt(dr["AvailQty"]))
                        {

                            issueQty = Util.GetInt(dr["AvailQty"]);
                            int savedQty = SetItemStockDetail.IssueCSSDToDepartment(tnx, SalesNo, item.requestId, item.setId, item.itemId, dr["StockID"].ToString(), issueQty, dr["ID"].ToString(), item.toDeptLedgerNo, dr["SetStockID"].ToString(), dr["SetTnxID"].ToString());
                            //if (savedQty == 0)
                            //{
                            //    tnx.Rollback();
                            //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });
                            //}
                            remainingQty = remainingQty - savedQty;
                        }
                        else
                        {

                            issueQty = remainingQty;
                            int savedQty = SetItemStockDetail.IssueCSSDToDepartment(tnx, SalesNo, item.requestId, item.setId, item.itemId, dr["StockID"].ToString(), issueQty, dr["ID"].ToString(), item.toDeptLedgerNo, dr["SetStockID"].ToString(), dr["SetTnxID"].ToString());
                            //if (savedQty == 0)
                            //{
                            //    tnx.Rollback();
                            //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });
                            //}
                            remainingQty = remainingQty - savedQty;

                        }

                    }
                    if (remainingQty > 0)
                    {
                        // Second Check Processed Stock Against Return Requests
                        sqlCommad = "SELECT bt.`ID`,(bt.`Quantity`-bt.`ReleaseQuantity`)'AvailQty',bt.`StockID` FROM cssd_f_batch_tnxdetails bt WHERE bt.`SetID`='" + item.setId + "' AND bt.`ItemID`='" + item.itemId + "' AND bt.`validityDate`>=CURDATE()  and  (bt.`Quantity`-bt.`ReleaseQuantity`)>0  AND bt.`processType`='Returned'  ORDER BY (bt.`Quantity`-bt.`ReleaseQuantity`) DESC  ";
                        dtGetIssueQty = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sqlCommad).Tables[0];
                        foreach (DataRow dr in dtGetIssueQty.Rows)
                        {
                            if (remainingQty > Util.GetInt(dr["AvailQty"]))
                            {
                                issueQty = Util.GetInt(dr["AvailQty"]);


                                int savedQty = SetItemStockDetail.IssueCSSDToDepartment(tnx, SalesNo, item.requestId, item.setId, item.itemId, dr["StockID"].ToString(), issueQty, dr["ID"].ToString(), item.toDeptLedgerNo, dr["SetStockID"].ToString(), dr["SetTnxID"].ToString());
                                //if (isIssue == "0")
                                //{
                                //    tnx.Rollback();
                                //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });
                                //}
                                remainingQty = remainingQty - savedQty;
                            }
                            else
                            {
                                issueQty = remainingQty;
                                // remainingQty = remainingQty - issueQty;
                                int savedQty = SetItemStockDetail.IssueCSSDToDepartment(tnx, SalesNo, item.requestId, item.setId, item.itemId, dr["StockID"].ToString(), issueQty, dr["ID"].ToString(), item.toDeptLedgerNo, dr["SetStockID"].ToString(), dr["SetTnxID"].ToString());
                                //if (isIssue == "0")
                                //{
                                //    tnx.Rollback();
                                //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });
                                //}
                                remainingQty = remainingQty - savedQty;

                            }

                        }


                    }

                    //if (remainingQty > 0)
                    //{
                    //    // After All Check Processed Stock for Any Condition
                    //    sqlCommad = "SELECT bt.`ID`,(bt.`Quantity`-bt.`ReleaseQuantity`)'AvailQty',bt.`StockID` FROM cssd_f_batch_tnxdetails bt WHERE bt.`SetID`='" + item.setId + "' AND bt.`ItemID`='" + item.itemId + "' AND bt.`validityDate`>=CURDATE()  and  (bt.`Quantity`-bt.`ReleaseQuantity`)>0  ORDER BY (bt.`Quantity`-bt.`ReleaseQuantity`) DESC  ";
                    //    dtGetIssueQty = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sqlCommad).Tables[0];
                    //    foreach (DataRow dr in dtGetIssueQty.Rows)
                    //    {
                    //        if (remainingQty > Util.GetInt(dr["AvailQty"]))
                    //        {
                    //          issueQty = Util.GetInt(dr["AvailQty"]);
                    //          
                    //            remainingQty = 0;
                    //            int savedQty = SetItemStockDetail.IssueCSSDToDepartment(tnx, SalesNo, item.requestId, item.setId, item.itemId, dr["StockID"].ToString(), issueQty, dr["ID"].ToString(), item.toDeptLedgerNo);
                    //            //if (isIssue == "0")
                    //            //{
                    //            //    tnx.Rollback();
                    //            //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });
                    //            //}
                    //            remainingQty = remainingQty - savedQty;
                    //        }
                    //        else
                    //        {
                    //             issueQty = remainingQty;
                    //           
                    //            int savedQty = SetItemStockDetail.IssueCSSDToDepartment(tnx, SalesNo, item.requestId, item.setId, item.itemId, dr["StockID"].ToString(), issueQty, dr["ID"].ToString(), item.toDeptLedgerNo);
                    //            //if (isIssue == "0")
                    //            //{
                    //            //    tnx.Rollback();
                    //            //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });
                    //            //}
                    //            remainingQty = remainingQty - savedQty;
                    //        }

                    //    }



                    //}

                    ExcuteCMD cmds = new ExcuteCMD();
                    cmds.DML(tnx, "UPDATE cssd_requisition req  SET req.`CssdComment`=@CssdComment WHERE req.`requestId`=@requestId And ItemID=@ItemID And ID=@Id", CommandType.Text, new
                    {
                        requestId = item.requestId,
                        CssdComment = item.CssdComment,
                        ItemID = item.itemId,
                        Id = item.id,
                    });

                     
                    if (remainingQty > 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Stock Not Available for Item : " + item.itemName + "." });

                    }
                }

            }

            ExcuteCMD cmd = new ExcuteCMD();
            cmd.DML(tnx, "UPDATE cssd_requisition req  SET req.`status`=2 WHERE req.`requestId`=@requestId", CommandType.Text, new
            {
                requestId = data[0].requestId
            });

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Items Issued Successfully." });

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });


        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();

        }

    }
    [WebMethod(EnableSession = true)]
    public static string consumeStock(List<issueRequestData> data)
    {



        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_SalesNo('13','" + AllGlobalFunction.GeneralStoreID + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')"));

            //DataTable dtItem = (DataTable)ViewState["StockTransfer"];
            foreach (var item in data)
            {
                string sqlCommand = " SELECT  cst.ID,st.`StockID`,(st.`InitialCount`-st.`ReleasedCount`) 'AvailQty',st.`unitPrice`,st.`MRP`,st.`ItemID`,st.`MedExpiryDate`,st.`PurTaxPer`,st.`CGSTPercent`, ";
                sqlCommand += " st.`SGSTPercent`,st.`IGSTPercent`,st.`HSNCode`,st.`GSTType` FROM f_stock st   ";
                sqlCommand += " INNER JOIN `cssd_recieve_set_stock` cst ON cst.`StockID`=st.`StockID` ";
                sqlCommand += " WHERE cst.`ItemID`='" + item.itemId + "' AND cst.`SetID`='" + item.setId + "' AND cst.`SetStockID`='" + item.setStockId + "' ";

                ExcuteCMD cmd = new ExcuteCMD();
                DataTable dtStockDetails = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sqlCommand).Tables[0];
                decimal totalAvailableQty = Util.GetDecimal(dtStockDetails.Compute("sum(AvailQty)", ""));
                decimal requiredQty = Util.GetDecimal(item.issueQty);
                if (totalAvailableQty < requiredQty)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Returned Stock not Available to Consume for Item : <span class='patientInfo'>." + item.itemName + "</span>" });


                for (int i = 0; requiredQty > 0; i++)
                {
                    decimal issuedQty = 0;
                    if (Util.GetDecimal(dtStockDetails.Rows[i]["AvailQty"]) >= requiredQty)
                        issuedQty = requiredQty;

                    else
                        issuedQty = Util.GetDecimal(dtStockDetails.Rows[i]["AvailQty"]);
                    requiredQty = requiredQty - issuedQty;

                    Sales_Details ObjSales = new Sales_Details(tnx);
                    ObjSales.LedgerNumber = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    ObjSales.DepartmentID = "STO00002";
                    ObjSales.StockID = Util.GetString(dtStockDetails.Rows[i]["StockID"]);
                    ObjSales.SoldUnits = Util.GetDecimal(issuedQty);
                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(dtStockDetails.Rows[i]["unitPrice"]);
                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(dtStockDetails.Rows[i]["MRP"]);
                    ObjSales.Date = System.DateTime.Now;
                    ObjSales.Time = System.DateTime.Now;
                    ObjSales.IsReturn = 0;
                    ObjSales.TrasactionTypeID = 13;
                    ObjSales.ItemID = Util.GetString(dtStockDetails.Rows[i]["ItemID"]);
                    ObjSales.IsService = "NO";
                    ObjSales.IndentNo = "";
                    ObjSales.Naration = "Cosume Against the Return Requisition " + item.requestId;
                    ObjSales.SalesNo = SalesNo;
                    ObjSales.UserID = HttpContext.Current.Session["ID"].ToString();
                    ObjSales.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                    ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    ObjSales.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjSales.IpAddress = All_LoadData.IpAddress();
                    ObjSales.medExpiryDate = Util.GetDateTime(dtStockDetails.Rows[i]["MedExpiryDate"]);
                    ObjSales.TaxPercent = Util.GetDecimal(dtStockDetails.Rows[i]["PurTaxPer"]);
                    ObjSales.CGSTPercent = Util.GetDecimal(dtStockDetails.Rows[i]["CGSTPercent"]);
                    ObjSales.SGSTPercent = Util.GetDecimal(dtStockDetails.Rows[i]["SGSTPercent"]);
                    ObjSales.IGSTPercent = Util.GetDecimal(dtStockDetails.Rows[i]["IGSTPercent"]);
                    ObjSales.HSNCode = Util.GetString(dtStockDetails.Rows[i]["HSNCode"]);
                    string SalesID = ObjSales.Insert();
                    if (SalesID == "")
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });
                    }

                    string strStock = "update f_stock set ReleasedCount = ReleasedCount +" + ObjSales.SoldUnits + " where StockID = '" + ObjSales.StockID + "' and ReleasedCount + " + ObjSales.SoldUnits + "<=InitialCount";
                    if (MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strStock) == 0)
                    {
                        tnx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });
                    }


                    cmd.DML(tnx, " UPDATE cssd_recieve_Set_stock SET ReceivedQty=(ReceivedQty-@qty) WHERE ID=@id ", CommandType.Text, new
                    {
                        qty = issuedQty,
                        id = Util.GetInt(dtStockDetails.Rows[i]["ID"])

                    });

                }

                string sql = "UPDATE cssd_requisition SET consumedQty=(consumedQty+@qty),CssdComment=@CssdComment WHERE id=@rowId";
                cmd.DML(tnx, sql, CommandType.Text, new
                {
                    qty = Util.GetInt(item.issueQty),
                    rowId = Util.GetInt(item.id),
                    CssdComment=item.CssdComment
                });




            }


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Items Consumed Successfully." });

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured, Please Contact Administrator." });


        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();

        }
    }
}

public class requestStatusData
{

    public string requestId { get; set; }
    public string status { get; set; }
    public string requestType { get; set; }

}
public class issueRequestData
{
    public string requestId { get; set; }
    public string setId { get; set; }
    public string itemId { get; set; }
    public int issueQty { get; set; }
    public string itemName { get; set; }
    public string toDeptLedgerNo { get; set; }
    public int id { get; set; }
    public string setStockId { get; set; }
    public string CssdComment { get; set; }

}