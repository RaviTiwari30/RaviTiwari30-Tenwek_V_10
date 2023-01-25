<%@ WebService Language="C#" Class="AssetIssue" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.None)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class AssetIssue : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(EnableSession = true)]
    public string BindDepartment()
    {
        DataView dv = LoadCacheQuery.bindStoreDepartment().DefaultView;
        dv.RowFilter = " LedgerNumber <> '" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' ";
        DataTable dt = dv.ToTable();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string BindAllDepartment()
    {
        DataView dv = LoadCacheQuery.bindStoreDepartment().DefaultView;
        DataTable dt = dv.ToTable();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public void LoadItems(string cmd, string q, string SearchBy, string DeptLedgerNo, string page, string rows,string isAssetLocation)
    {
        var dt = new System.Data.DataTable();
        try
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append("SELECT im.ItemID,im.TypeName ItemName,am.ID AS AssetID,am.AssetNo,am.SerialNo,am.BatchNumber,am.ModelNo,st.ID AS StockID,st.stockID as f_StockID FROM f_itemmaster im  ");
            sb.Append("INNER JOIN eq_asset_master am ON im.ItemID= am.ItemID ");
            sb.Append("INNER JOIN eq_asset_stock st ON st.AssetID=am.ID ");
            sb.Append("WHERE im.IsActive=1 AND st.IsPost=1 and st.Initialcount-st.ReleasedCount>0 ");
            sb.Append("and st.DeptLedgerNo='" + DeptLedgerNo + "' ");
            if (q.Trim() != "")
            {
                if (SearchBy == "1")
                    sb.Append(" and im.TypeName like '" + q.Trim() + "%'");
                else if (SearchBy == "2")
                    sb.Append(" and am.BatchNumber like '" + q.Trim() + "%'");
                else if (SearchBy == "3")
                    sb.Append(" and am.ModelNo like '" + q.Trim() + "%'");
                else if (SearchBy == "4")
                    sb.Append(" and am.SerialNo like '" + q.Trim() + "%'");
                else if (SearchBy == "5")
                    sb.Append(" and am.AssetNo like '" + q.Trim() + "%'");
            }
            if (isAssetLocation == "1") {
                sb.Append(" AND st.AssetID NOT IN (SELECT AssetID FROM eq_asset_location WHERE IsActive=1 and DeptLedgerNo='" + DeptLedgerNo + "' ) ");
            }
            sb.Append(" GROUP BY st.id; ");
            dt = StockReports.GetDataTable(sb.ToString());
            HttpContext.Current.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(dt));
        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveIssueAsset(List<assetdetails> assetDetails, List<acessoriesdetails> accessoriesDetails, string isDirectIssue, string IssueToDeptLedgerNo, string takenBy, string Narration, string IndentNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string CentreID = HttpContext.Current.Session["CentreID"].ToString();
            string CurrentDeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
            string UserID = HttpContext.Current.Session["ID"].ToString();
            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_Asset_SalesNo('1','STO00002','" + CentreID + "')"));

            assetDetails.ForEach(i =>
            {
                // insert into eq_f_salesdetails------
                var sqlCMD = "INSERT INTO eq_f_salesdetails (LedgerNumber,DepartmentID,StockID,SoldUnits,PerUnitBuyPrice,PerUnitSellingPrice,DATE,TIME,TrasactionTypeID,ItemID,salesno,UserID,DeptLedgerNo,BatchNo,CentreID,IpAddress,f_StockID,AssetID,Naration,IndentNo)";
                sqlCMD += "VALUES(@LedgerNumber,@DepartmentID,@StockID,@SoldUnits,@PerUnitBuyPrice,@PerUnitSellingPrice,@Date,@Time,@TrasactionTypeID,@ItemID,@salesno,@UserID,@DeptLedgerNo,@BatchNo,@CentreID,@IpAddress,@f_StockID,@AssetID,@Naration,@IndentNo);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    LedgerNumber = IssueToDeptLedgerNo,
                    DepartmentID = "STO00002",
                    StockID = i.StockID,
                    SoldUnits = 1,
                    PerUnitBuyPrice = 0,
                    PerUnitSellingPrice = 0,
                    DATE = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd"),
                    TIME = Util.GetDateTime(DateTime.Now).ToString("HH:mm:ss"),
                    TrasactionTypeID = 1,
                    ItemID = i.ItemID,
                    salesno = SalesNo,
                    UserID = UserID,
                    DeptLedgerNo = CurrentDeptLedgerNo,
                    BatchNo = i.BatchNo,
                    CentreID = CentreID,
                    IpAddress = All_LoadData.IpAddress(),
                    f_StockID = i.f_StockID,
                    AssetID = i.AssetID,
                    Naration = Narration,
                    IndentNo = IndentNo,
                });

                var CurStock = "Select * from eq_asset_stock where ID =@stockID";
                var dtStock = excuteCMD.GetDataTable(CurStock, CommandType.Text, new
                {
                    stockID = i.StockID,
                });

                //------------Insert new row in eq_asset_stock table
                var sqlStk = "INSERT INTO eq_asset_stock (AssetID,StockID,ItemID,ItemName,LedgerTransactionNo,BatchNumber,unitPrice,MRP,InitialCount,ReleasedCount,PendingQty,MedExpiryDate,PurchaseDate,IsPost,IsFree,SubCategoryID,DeptLedgerNo,CreatedBy,CreatedDateTime,IpAddress,InvoiceNo,InvoiceDate,VenLedgerNo,InvoiceAmount,IssueDate,IssueToDept,IssueBy,IssueToEmp,FromDept,FromAssetID,FromStockID,SalesNo)";
                sqlStk += "VALUES(@AssetID,@StockID,@ItemID,@ItemName,@LedgerTransactionNo,@BatchNumber,@unitPrice,@MRP,@InitialCount,@ReleasedCount,@PendingQty,@MedExpiryDate,@PurchaseDate,@IsPost,@IsFree,@SubCategoryID,@DeptLedgerNo,@CreatedBy,@CreatedDateTime,@IpAddress,@InvoiceNo,@InvoiceDate,@VenLedgerNo,@InvoiceAmount,@IssueDate,@IssueToDept,@IssueBy,@IssueToEmp,@FromDept,@FromAssetID,@FromStockID,@SalesNo);SELECT @@identity;";
                var stockID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlStk, CommandType.Text, new
                    {
                        AssetID = Util.GetInt(dtStock.Rows[0]["AssetID"]),
                        StockID = Util.GetInt(dtStock.Rows[0]["StockID"]),
                        ItemID = dtStock.Rows[0]["ItemID"].ToString(),
                        ItemName = dtStock.Rows[0]["ItemName"].ToString(),
                        LedgerTransactionNo = dtStock.Rows[0]["LedgerTransactionNo"].ToString(),
                        BatchNumber = dtStock.Rows[0]["BatchNumber"].ToString(),
                        unitPrice = Util.GetDecimal(dtStock.Rows[0]["unitPrice"]),
                        MRP = Util.GetDecimal(dtStock.Rows[0]["MRP"]),
                        InitialCount = 1,
                        ReleasedCount = 0,
                        PendingQty = 1,
                        MedExpiryDate = Util.GetDateTime(dtStock.Rows[0]["MedExpiryDate"].ToString()),
                        PurchaseDate = Util.GetDateTime(dtStock.Rows[0]["PurchaseDate"].ToString()),
                        IsPost = 4,
                        IsFree = Util.GetInt(dtStock.Rows[0]["IsFree"]),
                        SubCategoryID = dtStock.Rows[0]["SubCategoryID"].ToString(),
                        DeptLedgerNo = IssueToDeptLedgerNo,
                        CreatedBy = UserID,
                        CreatedDateTime = DateTime.Now,
                        IpAddress = All_LoadData.IpAddress(),
                        InvoiceNo = dtStock.Rows[0]["InvoiceNo"].ToString(),
                        InvoiceDate = Util.GetDateTime(dtStock.Rows[0]["InvoiceDate"].ToString()),
                    //    PONumber = dtStock.Rows[0]["PONumber"].ToString(),
                   //     PODate = dtStock.Rows[0]["PODate"].ToString(),
                        VenLedgerNo = dtStock.Rows[0]["VenLedgerNo"].ToString(),
                        InvoiceAmount = dtStock.Rows[0]["InvoiceAmount"].ToString(),
                        IssueDate = DateTime.Now,
                        IssueToDept = IssueToDeptLedgerNo,
                        IssueBy = UserID,
                        IssueToEmp = takenBy,
                        FromDept = CurrentDeptLedgerNo,
                        FromAssetID = Util.GetInt(dtStock.Rows[0]["AssetID"]),
                        FromStockID = Util.GetInt(dtStock.Rows[0]["ID"]),
                        SalesNo = Util.GetInt(SalesNo),
                    }));
                //---------Update Releasecount of in eq_asset_stock table

                var sqlc = "Update eq_asset_stock set ReleasedCount=1 where ID=@ID";
                excuteCMD.DML(tnx, sqlc, CommandType.Text, new
                {
                    ID = Util.GetInt(dtStock.Rows[0]["ID"]),
                });

                //-------Update Release Count in Main f_Stock table

                var sqlcd = "Update f_stock set ReleasedCount=ReleasedCount+1 where StockID=@ID";
                excuteCMD.DML(tnx, sqlcd, CommandType.Text, new
                {
                    ID = Util.GetInt(dtStock.Rows[0]["StockID"]),
                });

                // --------insert Accessories Details-------
                accessoriesDetails.ForEach(j =>
                {
                    if (i.StockID == j.stockID)
                    {
                        var sqle = "INSERT INTO eq_accessories_salesdetails (AccessoriesID,AssetID,TaggedID,StockID,SalesNo,CreatedBy) VALUES(@AccessoriesID, @AssetID, @TaggedID, @StockID, @SalesNo, @CreatedBy);";
                        excuteCMD.DML(tnx, sqle, CommandType.Text, new
                        {
                            AccessoriesID = j.accessoriesID,
                            AssetID = 0,
                            TaggedID = j.taggedID,
                            StockID = stockID,
                            SalesNo = SalesNo,
                            CreatedBy = UserID
                        });
                    }
                });

                //--------Update Indent table
                if (isDirectIssue == "0")
                {
                    var sql = "Update f_indent_detail set ReceiveQty=ReceiveQty+1 where IndentNo=@IndentNo and ItemID=@ItemID";
                    excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        IndentNo = IndentNo,
                        ItemID = i.ItemID
                    });
                   var ss = excuteCMD.GetRowQuery(sql, new
                    {
                        IndentNo = IndentNo,
                        ItemID = i.ItemID
                    });
                }
            });


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" + "<br/> Sales No.: " + SalesNo, SalesNo = SalesNo });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class assetdetails
    {
        public string AssetID { get; set; }
        public string ItemName { get; set; }
        public string BatchNo { get; set; }
        public string ModelNo { get; set; }
        public string SerialNo { get; set; }
        public string AssetNo { get; set; }
        public string StockID { get; set; }
        public string ItemID { get; set; }
        public string f_StockID { get; set; }
    }
    public class acessoriesdetails
    {
        public string stockID { get; set; }
        public string accessoriesID { get; set; }
        public string taggedID { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public string printAssetIssueReciept(string SaleNo)
    {
        try
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
    }

    [WebMethod(EnableSession = true)]
    public string SearchIndent(string fromdate, string todate, string reqdepartment, string indentno, string status)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT *,IF(StatusNew='1' OR StatusNew='4','true','false')VIEW FROM (  ");
        sb.Append("SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN '3' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN '2'     ");
        sb.Append("WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN '1' ELSE '4'  END)StatusNew   ");
        sb.Append("FROM ( ");
        sb.Append("SELECT id.indentno,id.Type,id.StoreId,DATE_FORMAT(id.dtentry,'%d-%b-%y %I:%i %p')dtEntry, ");
        sb.Append("lm.ledgername AS DeptFrom,lm.LedgerNumber,  ");
        sb.Append("SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,  ");
        sb.Append("SUM(RejectQty)RejectQty   ");
        sb.Append("FROM f_indent_detail id  ");
        sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = id.Deptfrom   ");
        sb.Append("WHERE id.dtEntry >= '" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND DATE(id.dtEntry) <='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'  AND id.deptto = '" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  ");
        if (reqdepartment != "0")
        {
            sb.Append(" and id.Deptfrom='" + reqdepartment + "'");
        }
        sb.Append("GROUP BY IndentNo     )t ");
        sb.Append(")t1     ");
        if (status != "0")
        {
            sb.Append(" where StatusNew='" + status + "' ");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string SearchIndentDetails(string IndentNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT idp.ItemID,idp.ItemName,ReqQty,ReceiveQty,RejectQty,(ReqQty-ReceiveQty-RejectQty)totalQty ,ifnull(SUM(st.InitialCount),0)AvailableQty ");
        sb.Append("FROM f_indent_detail idp ");
        sb.Append("LEFT JOIN eq_asset_stock st ON st.ItemID= idp.ItemId AND st.IsPost=1 AND st.DeptLedgerNo='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' AND (st.InitialCount-st.ReleasedCount)>0 ");
        sb.Append("WHERE IndentNo='" + IndentNo + "' ");
        sb.Append("GROUP BY idp.ItemId ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public string SearchAssetStockbyItemID(string ItemID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT am.BatchNumber FROM eq_Asset_stock st INNER JOIN eq_asset_master am ON st.AssetID=am.ID WHERE st.ItemID='" + ItemID + "' AND st.IsPost=1 AND st.InitialCount-st.ReleasedCount>0 AND st.DeptLedgerNo='LSHHI4104' GROUP BY st.BatchNumber; ");
        DataTable dtbatch = StockReports.GetDataTable(sb.ToString());
        sb.Clear();
        sb.Append("SELECT am.AssetNo,st.ID as StockID,st.BatchNumber,am.SerialNo,am.ModelNo,st.StockID as f_StockID,st.AssetID,st.ItemID FROM eq_Asset_stock st INNER JOIN eq_asset_master am ON st.AssetID=am.ID WHERE st.ItemID='" + ItemID + "' AND st.IsPost=1 AND st.InitialCount-st.ReleasedCount>0 AND st.DeptLedgerNo='LSHHI4104'; ");
        DataTable dtAsset = StockReports.GetDataTable(sb.ToString());

        sb.Clear();
        sb.Append("SELECT StockID,AccessoriesID,AssetID,etm.ID AS taggingID,SerialNo,ModelNo,BatchNo,Quantity,eam.AccessoriesName,LicenceNo,etm.ItemID FROM eq_item_accessories_tagdetails etm INNER JOIN eq_accessories_master eam ON eam.ID=etm.AccessoriesID WHERE ItemID='" + ItemID + "' AND etm.isactive=1;");
        DataTable dtAccessories = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(new { dtbatch = dtbatch, dtAsset = dtAsset, dtAccessories = dtAccessories });
    }

    //[WebMethod]
    //public string searchOtherdetailsbyStockID(string stockID)
    //{ 

    //}

    [WebMethod]
    public string SearchDepartmentRecieve(string deptLedgerNo, string fromDate, string toDate, string isRecieve, string salesNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT lm.LedgerName,DATE_FORMAT(st.CreatedDateTime,'%d-%b-%Y')IssueDate,st.ItemName, am.BatchNumber,am.ModelNo, ");
        sb.Append("am.SerialNo,am.AssetNo,st.InitialCount,st.salesno,st.IsPost, ");
        sb.Append("(SELECT IndentNo FROM eq_f_salesdetails WHERE stockID=st.FromStockID limit 1)IndentNo, ");
        sb.Append("st.FromStockID,st.ID as StockID,st.AssetID,st.ItemID,st.IsPost isRecieve ");
        sb.Append("FROM eq_asset_Stock st  ");
        sb.Append("INNER JOIN eq_asset_master am ON st.AssetID=am.ID ");
        sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber= st.DeptLedgerNo ");
        sb.Append("WHERE if('" + isRecieve + "'='0',st.IsPost=4,st.IsPost=1 )");
        sb.Append("and st.CreatedDateTime>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' and st.CreatedDateTime<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (deptLedgerNo != "0")
            sb.Append("AND st.DeptLedgerNo='" + deptLedgerNo + "' ");
        if (salesNo != "")
            sb.Append(" AND st.SalesNo='" + salesNo + "'");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public string ReciveAssetinDepartment(List<recievedItems> rcvItems)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            rcvItems.ForEach(i =>
            {
                var sql = "Update eq_asset_stock set isPost=1 ,PostDate=Now() where ID=@ID";
                excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        ID = i.StockID,
                    });
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class recievedItems
    {
        public string StockID { get; set; }
    }

    [WebMethod]
    public string SearchAccessorieswithStock(string stockID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT serialNo,ModelNo,BatchNo,Quantity,eam.AccessoriesName,LicenceNo,etm.ItemID ,ast.StockID,etm.Quantity ");
        sb.Append("FROM eq_accessories_salesdetails ast  ");
        sb.Append("INNER JOIN eq_item_accessories_tagdetails etm ON etm.id= ast.TaggedID ");
        sb.Append("INNER JOIN eq_accessories_master eam ON eam.ID=etm.AccessoriesID ");
        sb.Append("WHERE ast.StockID=" + stockID + " ");
        sb.Append("ORDER BY eam.AccessoriesName ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public string SearchDepartmentIssueReturn(string deptLedgerNo, string fromDate, string toDate, string indentNo, string salesNo, string typeoftnx)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  if(sd.TrasactionTypeID=1,'Issue','Return')TypeOfTnx, DATE_FORMAT(sd.Date,'%d-%b-%Y')IssueDate,TIME_FORMAT(sd.Time,'%I:%i %p')IssueTime,sd.salesno,sd.IndentNo ,lm.LedgerName ");
        sb.Append("FROM eq_f_salesdetails sd  ");
        sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber= sd.LedgerNumber ");
        sb.Append("WHERE sd.Date>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' and sd.Date<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
        if (deptLedgerNo != "0")
        {
            sb.Append(" and  sd.LedgerNumber ='" + deptLedgerNo + "'");
        }
        if (!string.IsNullOrEmpty(indentNo))
        {
            sb.Append(" and  sd.IndentNo ='" + indentNo + "'");
        }
        if (!string.IsNullOrEmpty(salesNo))
        {
            sb.Append(" and  sd.salesNo ='" + salesNo + "'");
        }
        if (typeoftnx != "0") {
            sb.Append(" if('" + typeoftnx + "'='1', sd.TrasactionTypeID=1, sd.TrasactionTypeID=2)");
        }
        sb.Append(" and sd.TrasactionTypeID in (1,2)  GROUP BY sd.TrasactionTypeID,sd.salesno ORDER BY sd.Date,sd.Time ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public string ReprintDepartmentIssue(string salesno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(sd.Date,'%d-%b-%Y')IssueDate,TIME_FORMAT(sd.Time,'%I:%i %p')IssueTime,sd.salesno,sd.IndentNo ,lm.LedgerName, ");
        sb.Append("am.ItemName,am.BatchNumber,am.ModelNo,am.SerialNo,am.AssetNo,sd.SoldUnits,sd.Naration,CONCAT(em.title,'',em.Name )AS IssueBy ");
        sb.Append("FROM eq_f_salesdetails sd  ");
        sb.Append("INNER JOIN eq_asset_master am ON am.ID=sd.AssetID ");
        sb.Append("LEFT JOIN f_indent_detail idp ON idp.IndentNo=sd.IndentNo AND idp.ItemId= sd.ItemID ");
        sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber= sd.LedgerNumber ");
        sb.Append("INNER JOIN employee_master em ON sd.UserID= em.EmployeeID ");
        sb.Append("WHERE sd.salesno='" + salesno + "' and sd.TrasactionTypeID=1 ");
        sb.Append("GROUP BY sd.ID ORDER BY sd.Date,sd.Time ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
         //   ds.WriteXmlSchema(@"D:\ReprintAssetDepartmentIssue.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "ReprintAssetDepartmentIssue";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record found" });
    }
}