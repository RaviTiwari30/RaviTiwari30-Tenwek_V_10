<%@ WebService Language="C#" Class="CreatePurchaseRequest" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Linq;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CreatePurchaseRequest : System.Web.Services.WebService
{

    //[WebMethod]
    //public string HelloWorld() {
    //    return "Hello World";
    //}

     [WebMethod(EnableSession = true)]
    public string GetItems(string storeID,string itemtype)
    {
        DataTable dtItem = new DataTable();
        int configID = 0;
        if (storeID == "STO00001")
            configID = 11;
        else
            configID = 28;
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append("SELECT IM.itemcode, IM.Typename ItemName, IM.Typename, IM.SubCategoryID, im.MajorUnit,im.ItemID,im.ConversionFactor,IFNULL(im.ReorderLevel,'0.0000')ReorderLevel,ifnull(im.ReorderLevel,'0.0000')ReorderLevel,IFNULL(IM.ReorderQty,'0.0000')ReorderQty FROM f_itemmaster IM  INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID WHERE CR.ConfigID = @configID AND im.IsActive = 1 AND itc.`IsActive`=1 AND itc.`CentreID`= '" + HttpContext.Current.Session["CentreID"].ToString() + "'  AND im.IsStockable=" + itemtype + " GROUP BY im.ItemID ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            configID = configID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public string GetItemsByCategory(string categoryID, string subcategoryID,string itemtype)
    {
        DataTable dtItem = new DataTable();
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append("SELECT IM.itemcode, IM.Typename ItemName, IM.Typename, IM.SubCategoryID, im.MajorUnit,im.ItemID,fc.Name,ifnull(im.ReorderLevel,'0.0000')ReorderLevel,IFNULL(IM.ReorderQty,'0.0000')ReorderQty FROM f_itemmaster IM INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_categorymaster fc ON fc.CategoryID=SM.CategoryID WHERE fc.categoryID='" + categoryID + "' AND im.IsActive = 1 AND im.IsStockable=" + itemtype + " GROUP BY im.ItemID");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new {
            categoryID = categoryID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public string getItemStockDetails(string itemID, int centreID, string departmentLedgerID)
    {

        StringBuilder sqlCMD = new StringBuilder();

        sqlCMD.Append(" SELECT IFNULL(im.MinLevel,0)MinLevel,IFNULL(im.MaxLevel,0) MaxLevel, ");
        sqlCMD.Append(" IFNULL((SELECT SUM(f.InitialCount-f.ReleasedCount)  FROM f_stock f  WHERE f.CentreID=@centreID AND f.DeptLedgerNo=@departmentLedgerID  AND f.ItemID=@itemID  AND  f.`IsPost`=1 AND f.`MedExpiryDate`>CURDATE()),0) StockQuantity,");
        sqlCMD.Append(" IFNULL((SELECT SUM(pod.ApprovedQty)ApprovedQty FROM f_purchaseorderdetails pod INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo=pod.PurchaseOrderNo WHERE pod.ItemID=@itemID AND pod.ApprovedQty>0 AND po.Status=2 AND pod.RecievedQty=0  AND po.CentreID=@centreID AND po.DeptLedgerNo=@departmentLedgerID  GROUP BY pod.ItemID),0)POQuantity ");
        sqlCMD.Append(" ,ifnull(im.ReorderLevel,'0.0000')ReorderLevel,IFNULL(IM.ReorderQty,'0.0000')ReorderQty,'0' as IndentQuantity ");
        sqlCMD.Append(" FROM f_itemmaster im LEFT JOIN  f_itemmaster_deptwise imd ON imd.ItemID=@itemID AND imd.CentreID=@centreID AND imd.DeptLedgerNo=@departmentLedgerID  ");
        


        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            centreID = centreID,
            departmentLedgerID = departmentLedgerID,
            itemID = itemID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public string ReducePendingPurchase()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT SUM(pod.ApprovedQty-pod.RecievedQty) PendingQty, pod.`ItemID` FROM f_purchaseorderdetails pod INNER JOIN f_purchaseorder po ON po.`PurchaseOrderNo`=pod.`PurchaseOrderNo` WHERE ");
        sb.Append("  (pod.ApprovedQty-pod.RecievedQty)>0 AND po.Approved=2 GROUP BY pod.`ItemID`");

        ExcuteCMD excuteCMD = new ExcuteCMD();

        DataTable dt = excuteCMD.GetDataTable(sb.ToString(), CommandType.Text);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod]
    public string GetAutoPurchaseRequestItems(string departmentLedgerNo, string centreID, string fromDate, string toDate, int minDays, int reorderInDays, bool includeStoreToStore, string CategoryID, string SubCategoryID, int groupID)
    {

        DateTime dFromDate = Util.GetDateTime(fromDate);
        DateTime dToDate = Util.GetDateTime(toDate);

        int differenceInDays = (dToDate - dFromDate).Days;
        if (differenceInDays < 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Invalid Date Combination." });



        //StringBuilder sqlCmd = new StringBuilder("SELECT 0  Quantity,0 IndentQuantity, s.*,ROUND((((s.AvgConsumption*@reorderInDays)-s.CurrentStock)/s.ConversionFactor),0)SalesQuantity,ROUND((((s.AvgConsumption*@reorderInDays)-s.CurrentStock)/s.ConversionFactor),0)NetQuantity,IFNULL((SELECT SUM(f.InitialCount)-SUM(f.ReleasedCount)  FROM f_stock f  WHERE f.CentreID=@forCenterID AND f.DeptLedgerNo=@forDepartmentLedgerNo  AND f.ItemID=s.ItemID AND f.IsPost=1 AND f.MedExpiryDate>CURDATE()),0) DepartmentStock, ");
        //sqlCmd.Append("IFNULL((SELECT SUM(pod.ApprovedQty)ApprovedQty FROM f_purchaseorderdetails pod INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo=pod.PurchaseOrderNo WHERE pod.ItemID=s.ItemID AND pod.ApprovedQty>0 AND po.Status=2 AND pod.RecievedQty=0  AND po.CentreID=@centreID AND po.DeptLedgerNo=@departmentLedgerNo  GROUP BY pod.ItemID),0)PoStock  ");
        //sqlCmd.Append("FROM (SELECT t.*,(t.AvgConsumption*@minDays)MinConsumption, ");
        //sqlCmd.Append("IFNULL((SELECT SUM(st.InitialCount-St.ReleasedCount) FROM f_stock st WHERE st.DeptLedgerNo=@departmentLedgerNo AND st.CentreID=@centreID AND  st.ItemID=t.ItemID AND St.IsPost=1 AND st.MedExpiryDate>CURDATE() ),0)CurrentStock ");
        //sqlCmd.Append("FROM ( ");
        //sqlCmd.Append("SELECT im.TypeName ItemName,s.ItemID,im.SubCategoryID,im.`ConversionFactor`,im.MajorUnit PurchaseUnit,ROUND(SUM(IF(s.TrasactionTypeID IN(" + (includeStoreToStore ? "1," : "") + "3,4,16),s.SoldUnits,-1*s.SoldUnits))/DATEDIFF(@toDate,@fromDate)) AvgConsumption, ");
        //sqlCmd.Append("IFNULL(imdpt.MaxLevel,0) Maxlevel,IFNULL(imdpt.MinLevel,0) Minlevel ");
        //sqlCmd.Append("FROM f_salesdetails s ");
        //sqlCmd.Append("INNER JOIN f_itemmaster im ON im.ItemID=s.ItemID INNER JOIN f_subcategorymaster fcm ON fcm.`SubCategoryID`=im.`SubCategoryID` ");

        //sqlCmd.Append("LEFT JOIN f_itemmaster_deptwise imdpt ON imdpt.ItemID=im.ItemID AND   imdpt.CentreID=@centreID AND imdpt.DeptLedgerNo=@departmentLedgerNo ");
        //sqlCmd.Append("WHERE s.DeptLedgerNo=@departmentLedgerNo AND s.CentreID=@centreID ");

        //if (includeStoreToStore)
        //   sqlCmd.Append(" AND s.TrasactionTypeID IN(1,2,5,6,17,3,4,16) ");
        //else
        //    sqlCmd.Append(" AND s.TrasactionTypeID IN(1,2,5,6,17,3,4,16) ");

        //sqlCmd.Append(" AND s.Date>=@fromDate AND s.Date<=@toDate  ");

        //if (SubCategoryID != "0")
        //{
        //    sqlCmd.Append("AND im.`SubCategoryID`=@SubCategoryID ");
        //}
        //sqlCmd.Append("AND fcm.`CategoryID`=@categoryID ");
        //if (groupID != 0)
        //{
        //    sqlCmd.Append("AND im.`ItemGroupMasterID`=@ItemGroupMasterID ");
        //}
        //sqlCmd.Append("GROUP BY s.ItemID");
        //sqlCmd.Append(")t HAVING MinConsumption>CurrentStock  ORDER BY ItemName)s");

        StringBuilder sqlCmd = new StringBuilder(" call get_Stockon_ROL_forPurchaseRequest(@departmentLedgerNo,@centreID,@categoryID,@subCategoryID) ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var obj = new
        {
            departmentLedgerNo = departmentLedgerNo,
            centreID = centreID,
            forCenterID = centreID,
            categoryID=CategoryID,
            forDepartmentLedgerNo = departmentLedgerNo,
            fromDate = dFromDate.ToString("yyyy-MM-dd"),
            toDate = dToDate.ToString("yyyy-MM-dd"),
            minDays = minDays,
            reorderInDays = reorderInDays,
            subCategoryID = SubCategoryID
        };
        string rowQ = excuteCMD.GetRowQuery(sqlCmd.ToString(),obj);
        DataTable dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, obj);

        string s = excuteCMD.GetRowQuery(sqlCmd.ToString(), obj);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }








    public class ItemDetail
    {
        public string ItemName { get; set; }
        public string SubCategoryID { get; set; }
        public string ItemID { get; set; }
        public decimal? Minlevel { get; set; }
        public decimal? Maxlevel { get; set; }
        public decimal Quantity { get; set; }
        public decimal IndentQuantity { get; set; }
        public decimal SalesQuantity { get; set; }
        public decimal NetQuantity { get; set; }
        public decimal CurrentStock { get; set; }
        public decimal PoStock { get; set; }
        public string Narration { get; set; }
        public string PurchaseUnit { get; set; }
        public string IndentNumber { get; set; }
        private int _ID;
        public int ID
        {
            get { return _ID; }
            set { _ID = value; }
        }


    }

    [WebMethod(EnableSession = true)]
    public string Save(List<ItemDetail> ItemDetails, string storeId, string narration, string requestType, string requisitionDate, string purchaseRequestNo, string issueToDepartment, int issueToCenterID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string typeOfTnx = string.Empty;
        string storeLedgerNo = string.Empty;
        string purchaseRequestNumber = string.Empty;

        try
        {

            if (storeId == "STO00001")
            {
                typeOfTnx = "Purchase";
                storeLedgerNo = "STO00001";
            }
            else
            {
                typeOfTnx = "NMPURCHASE";
                storeLedgerNo = "STO00002";
            }

            purchaseRequestNumber = purchaseRequestNo;
            PurchaseRequestMaster purchaseRequestMaster = new PurchaseRequestMaster(tnx);

            purchaseRequestMaster.RaisedByID = Convert.ToString(HttpContext.Current.Session["ID"]);
            purchaseRequestMaster.RaisedByName = Convert.ToString(HttpContext.Current.Session["UserName"]);
            purchaseRequestMaster.RaisedDate = DateTime.Now;
            purchaseRequestMaster.Status = 0;
            purchaseRequestMaster.Approved = 0;
            purchaseRequestMaster.Remarks = string.Empty;
            purchaseRequestMaster.StoreID = storeId;
            purchaseRequestMaster.Subject = narration;
            purchaseRequestMaster.Type = requestType;
            purchaseRequestMaster.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
            purchaseRequestMaster.IssuedTo = issueToDepartment;
            purchaseRequestMaster.CenterTo = issueToCenterID;//HttpContext.Current.Session["DeptLedgerNo"].ToString();
            purchaseRequestMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
            purchaseRequestMaster.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            purchaseRequestMaster.IpAddress = All_LoadData.IpAddress();
            purchaseRequestMaster.bydate = Util.GetDateTime(requisitionDate);

            if (string.IsNullOrEmpty(purchaseRequestNumber))
            {
                purchaseRequestNumber = purchaseRequestMaster.Insert();
            }
            else
            {
                string sqlCMD = "UPDATE f_purchaserequestmaster s SET s.LastUpdatedDate=@lastUpdatedDate , s.LastUpdatedID =@lastUpdatedID, s.LastUpdatedUserName=@lastUpdatedUserName,s.Subject=@subject WHERE s.PurchaseRequestNo=@purchaseRequestNo";
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
                {
                    lastUpdatedDate = Util.GetDateTime(requisitionDate).ToString("yyyy-MM-dd"),
                    lastUpdatedID = Convert.ToString(HttpContext.Current.Session["ID"]),
                    lastUpdatedUserName = Convert.ToString(HttpContext.Current.Session["UserName"]),
                    subject = narration,
                    purchaseRequestNo = purchaseRequestNumber
                });

                excuteCMD.DML(tnx, "UPDATE f_purchaserequestdetails s SET s.IsActive=0 WHERE s.PurchaseRequisitionNo=@purchaseRequestNo", CommandType.Text, new
                {
                    purchaseRequestNo = purchaseRequestNumber
                });
            }

            if (!string.IsNullOrEmpty(purchaseRequestNumber))
            {
                string sqlCmd = "Call Insert_PurchaseRequestDetail(@purchaseRequestNumber,@itemID,@itemName,@subCategoryID,@quantity,@quantity,0,@specification,@purpose,0,@unit,@departmentLedgerNo,@typeOfTnx,@storeLedgerNo,@hospitalID,@centreID,@salesQty,@indentQty,@indentNumber)";
                for (int i = 0; i < ItemDetails.Count; i++)
                {
                    var item = ItemDetails[i];

                    var _params = new
                    {
                        purchaseRequestNumber = purchaseRequestNumber,
                        itemID = item.ItemID,
                        itemName = item.ItemName,
                        subCategoryID = item.SubCategoryID,
                        quantity = item.NetQuantity,
                        specification = item.Narration,
                        purpose = string.Empty,
                        unit = item.PurchaseUnit,
                        departmentLedgerNo = purchaseRequestMaster.DeptLedgerNo,
                        typeOfTnx = typeOfTnx,
                        storeLedgerNo = storeLedgerNo,
                        hospitalID = purchaseRequestMaster.Hospital_ID,
                        centreID = purchaseRequestMaster.CentreID,
                        salesQty = item.SalesQuantity,
                        indentQty = item.IndentQuantity,
                        indentNumber = item.IndentNumber,
                        id = item.ID
                    };

                    if (item.ID < 1)
                    {
                        var s = excuteCMD.GetRowQuery(sqlCmd, _params);
                        excuteCMD.DML(tnx, sqlCmd, CommandType.Text, _params);
                    }
                    else
                    {
                        string sqlUpdateCMD = "UPDATE f_purchaserequestdetails SET  ItemID = @itemID, ItemName = @itemName, SubCategoryID = @subCategoryID, RequestedQty = @quantity, ApprovedQty = @quantity,unit=@unit,salesQty=@salesQty,indentQty=@indentQty,IsActive=1 WHERE PuschaseRequistionDetailID =@id ";
                        var s = excuteCMD.GetRowQuery(sqlUpdateCMD.ToString(), _params);
                        excuteCMD.DML(tnx, sqlUpdateCMD, CommandType.Text, _params);
                    }

                    if (!string.IsNullOrEmpty(item.IndentNumber))
                    {
                        var indents = item.IndentNumber.Split(',');
                        for (int j = 0; j < indents.Length; j++)
                        {
                            excuteCMD.DML(tnx, "UPDATE f_indent_detail f SET f.IsIncludeInPR=1,f.PRNO=@purchaseRequestNumber  WHERE f.ItemId=@ItemID AND f.IndentNo=@IndentNo", CommandType.Text, new
                            {
                                purchaseRequestNumber = purchaseRequestNumber,
                                ItemID = item.ItemID,
                                IndentNo = indents[j]
                            });
                        }
                    }
                }
            }


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage, PurchaseRequestNumber = purchaseRequestNumber });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession=true)]
    public string GetAllPendingIndentItemsDetails(List<string> selectedRequisitions)
    {
        StringBuilder sqlCmd = new StringBuilder();
        sqlCmd.Append("  SELECT * ,(t.ReqQty-(t.ReceiveQty+t.RejectQty))RemainQty FROM ( SELECT ");
        sqlCmd.Append("  f.id, ");
        sqlCmd.Append("  f.IndentNo, ");
        sqlCmd.Append("  f.ItemId , ");
        sqlCmd.Append("  f.ItemName, ");
        sqlCmd.Append("  f.ReceiveQty, ");
        sqlCmd.Append("  f.RejectQty, ");
        sqlCmd.Append("  f.ReqQty ");
        sqlCmd.Append("  FROM f_indent_detail  f ");
        sqlCmd.Append("  WHERE f.CentreID = "+ Session["CentreID"].ToString() +" AND f.IndentNo in ('" + string.Join("','", selectedRequisitions) + "') ) t HAVING RemainQty>0");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCmd.ToString()));
    }

    [WebMethod]
    public string SearchIndents(string requisitionNo, string fromDate, string toDate, string departmentLedgerNo, string centreID)
    {

        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append("  SELECT * FROM  ( SELECT f.IndentNo, ");
        sqlCMD.Append("  CentreName, ");
        sqlCMD.Append("  RoleName, ");
        sqlCMD.Append("  COUNT(f.ItemId)TotalItem ,SUM(IF((f.ReceiveQty+f.RejectQty)=f.ReqQty,0,1))RemainItem, ");
        sqlCMD.Append("  DATE_FORMAT(f.dtEntry,'%d-%b-%Y') IndentDate, ");
        sqlCMD.Append("  SUM(f.ReceiveQty)ReceiveQty, ");
        sqlCMD.Append("  SUM(f.RejectQty)RejectQty, ");
        sqlCMD.Append("  SUM(f.ReqQty)ReqQty, ");
        sqlCMD.Append("  CONCAT(em.Title,' ',em.Name)IndentBy, ");
        sqlCMD.Append("  (CASE WHEN SUM(f.ReceiveQty+f.RejectQty)=SUM(f.ReqQty) THEN 'Closed' WHEN SUM(f.RejectQty)=SUM(f.ReqQty) THEN 'Reject' WHEN SUM(f.ReceiveQty+f.RejectQty)>0 THEN 'Partial' ELSE 'UnOpened ' END) STATUS ");
        sqlCMD.Append("  FROM f_indent_detail  f ");
        sqlCMD.Append("  INNER JOIN center_master cm ON cm.centreID=f.CentreID ");
        sqlCMD.Append("  INNER JOIN f_rolemaster r ON  r.deptledgerNO=f.DeptFrom ");
        sqlCMD.Append("  INNER JOIN employee_master em ON em.EmployeeID=f.UserId ");

        sqlCMD.Append("  WHERE (f.isCancel IS NULL  OR  f.isCancel=0)   and f.IsIncludeInPR=0 "); // f.isCancel=0 // AND f.isApproved=1

        if (string.IsNullOrEmpty(requisitionNo))
            sqlCMD.Append("  AND DATE(f.dtEntry) >=@fromDate  AND DATE(f.dtEntry)<=@toDate");
        else
            sqlCMD.Append("AND f.IndentNo=@requisitionNo ");



// sqlCMD.Append("  AND f.CentreTo =@centreID AND f.DeptTo=@departmentLedgerNo ");
        sqlCMD.Append("  GROUP BY f.IndentNo ) t WHERE t.STATUS='Partial' OR t.STATUS='UnOpened'");


        ExcuteCMD excuteCMD = new ExcuteCMD();


        string s = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            requisitionNo = requisitionNo,
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd").ToString() + " 00:00:00",
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd").ToString() + " 23:59:59",
            departmentLedgerNo = departmentLedgerNo,
            centreID = centreID
        });



        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            requisitionNo = requisitionNo,
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd").ToString() + " 00:00:00",
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd").ToString() + " 23:59:59",
            departmentLedgerNo = departmentLedgerNo,
            centreID = centreID
        });



        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string GetRequisitionPendingItemsDetails(string departmentLedgerNo, string centreID, List<string> pendingIndentItems)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sqlCmd = new StringBuilder(" SELECT 0 Quantity,ROUND(SUM((fnd.ReqQty-(fnd.ReceiveQty+fnd.RejectQty))/im.conversionfactor),1) IndentQuantity,0 SalesQuantity,ROUND(SUM((fnd.ReqQty-(fnd.ReceiveQty+fnd.RejectQty))/im.conversionfactor),1) NetQuantity,im.TypeName ItemName,im.ItemID, im.MajorUnit PurchaseUnit,im.SubCategoryID , ");
        sqlCmd.Append(" IFNULL(imdpt.MaxLevel,0)MaxLevel,IFNULL(imdpt.MinLevel,0)MinLevel, ");
        sqlCmd.Append(" IFNULL((SELECT SUM(pod.ApprovedQty)ApprovedQty FROM f_purchaseorderdetails pod INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo=pod.PurchaseOrderNo WHERE pod.ItemID=im.ItemID AND pod.ApprovedQty>0 AND po.Status=2 AND pod.RecievedQty=0  AND po.CentreID=2 AND po.DeptLedgerNo=216  GROUP BY pod.ItemID),0)PoStock, ");
        sqlCmd.Append(" IFNULL((SELECT SUM(st.InitialCount-St.ReleasedCount) FROM f_stock st WHERE st.DeptLedgerNo=216 AND st.CentreID=1 AND  st.ItemID=im.ItemID AND St.IsPost=1 AND st.MedExpiryDate>CURDATE() ),0)CurrentStock , ");
        sqlCmd.Append(" GROUP_CONCAT(fnd.IndentNo) IndentNumber,0 isMerged ");
        sqlCmd.Append(" FROM f_indent_detail fnd  ");
        sqlCmd.Append(" INNER JOIN f_itemmaster  im ON im.ItemID=fnd.ItemId ");
        sqlCmd.Append(" LEFT JOIN f_itemmaster_deptwise  imdpt ON imdpt.ItemID=im.ItemID AND imdpt.CentreID=2 AND imdpt.DeptLedgerNo=216 ");
        sqlCmd.Append(" WHERE fnd.id IN(" + string.Join(",", pendingIndentItems) + ") AND fnd.CentreID="+ centreID +" GROUP BY im.ItemID ");
        DataTable dt = StockReports.GetDataTable(sqlCmd.ToString());
        //string s = excuteCMD.GetRowQuery(sqlCmd.ToString(), obj);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod(EnableSession=true)]
    public string GetPurchaseRequest(string purchaseRequestNo, string fromDate, string toDate, bool isFirstLoad)
    {

        StringBuilder sqlCmd = new StringBuilder("SELECT DISTINCT (PRM.PurchaseRequestNo), PRM.Type, ( CASE WHEN PRM.Status = 0 THEN 'Pending' WHEN PRM.Status = 1 THEN 'Reject' WHEN PRM.Status = 2 THEN 'Open' WHEN PRM.Status = 3 THEN 'Close' END ) STATUS, '' PartialSTATUS, PRM.Subject, DATE_FORMAT(PRM.RaisedDate, '%d-%b-%Y') RaisedDate, EM.Name, LM.LedgerName, PRM.CentreID,prm.Approved FROM f_purchaserequestmaster PRM INNER JOIN f_purchaserequestdetails PRD ON PRM.PurchaseRequestNo = PRD.PurchaseRequisitionNo INNER JOIN employee_master EM ON PRM.RaisedByID = EM.EmployeeID INNER JOIN f_ledgermaster LM ON LM.LedgerNumber = PRM.StoreID  ");
        sqlCmd.Append(" WHERE prm.CentreID=@CentreID ");
        //if (!isFirstLoad)
        //{
            if (!string.IsNullOrEmpty(purchaseRequestNo))
                sqlCmd.Append(" AND prm.PurchaseRequestNo=@purchaseRequestNo");
            else
                sqlCmd.Append(" AND DATE(prm.RaisedDate) >= @fromDate and DATE(prm.RaisedDate) <=@toDate");
     //   }
     //   else
     //   {
            sqlCmd.Append(" ORDER BY PRM.RaisedDate DESC");
    //    }

        ExcuteCMD excuteCMD = new ExcuteCMD();

        var s = excuteCMD.GetRowQuery(sqlCmd.ToString(), new
        {
            purchaseRequestNo = purchaseRequestNo,
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
            CentreID = Session["CentreID"].ToString()
        });
        var dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            purchaseRequestNo = purchaseRequestNo,
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
            toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
            CentreID = Session["CentreID"].ToString()
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public string OnEditPurchaseRequest(string departmentLedgerNo, string centreID, string requestNo)
    {

        StringBuilder sqlCmd = new StringBuilder(" SELECT prd.PuschaseRequistionDetailID ID,prd.RequestedQty-(prd.IndentQty+prd.SalesQty) Quantity,  ");
        sqlCmd.Append(" prd.IndentQty IndentQuantity, ");
        sqlCmd.Append(" prd.SalesQty SalesQuantity , ");
        sqlCmd.Append(" prd.RequestedQty NetQuantity, ");
        sqlCmd.Append(" im.TypeName ItemName,im.ItemID, ");
        sqlCmd.Append(" im.MajorUnit PurchaseUnit,im.ConversionFactor, ");
        sqlCmd.Append(" im.SubCategoryID, ");
        sqlCmd.Append(" IFNULL(imdpt.MaxLevel,0)MaxLevel, ");
        sqlCmd.Append(" IFNULL(imdpt.MinLevel,0)MinLevel, ");
        sqlCmd.Append(" IFNULL((SELECT SUM(pod.ApprovedQty)ApprovedQty FROM f_purchaseorderdetails pod INNER JOIN f_purchaseorder po ON po.PurchaseOrderNo=pod.PurchaseOrderNo WHERE pod.ItemID=im.ItemID AND pod.ApprovedQty>0 AND po.Status=2 AND pod.RecievedQty=0  AND po.CentreID=2 AND po.DeptLedgerNo=216  GROUP BY pod.ItemID),0)PoStock,  ");
        sqlCmd.Append(" IFNULL((SELECT SUM(st.InitialCount-St.ReleasedCount) FROM f_stock st WHERE st.DeptLedgerNo=@departmentLedgerNo AND st.CentreID=@centreID AND  st.ItemID=im.ItemID AND St.IsPost=1 AND st.MedExpiryDate>CURDATE() ),0)CurrentStock  ");
        sqlCmd.Append(" FROM  f_purchaserequestdetails prd ");
        sqlCmd.Append(" INNER JOIN f_purchaserequestmaster prm ON prm.PurchaseRequestNo=prd.PurchaseRequisitionNo ");
        sqlCmd.Append(" INNER JOIN f_itemmaster im ON im.ItemID=PRD.ItemID   ");
        sqlCmd.Append(" LEFT  JOIN f_itemmaster_deptwise  imdpt ON imdpt.ItemID=im.ItemID AND imdpt.CentreID=@centreID AND imdpt.DeptLedgerNo=@departmentLedgerNo  ");
        sqlCmd.Append(" WHERE prd.IsActive=1 and prm.PurchaseRequestNo=@purchaseRequestNo ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        string query = excuteCMD.GetRowQuery(sqlCmd.ToString(), new
        {
            purchaseRequestNo = requestNo,
            centreID = centreID,
            departmentLedgerNo = departmentLedgerNo
        });
        DataTable dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, new
        {
            purchaseRequestNo = requestNo,
            centreID = centreID,
            departmentLedgerNo = departmentLedgerNo
        });
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}