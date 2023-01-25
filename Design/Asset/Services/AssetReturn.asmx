<%@ WebService Language="C#" Class="AssetReturn" %>

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
public class AssetReturn : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(EnableSession = true)]
    public string SaveAssetReturnRequest(List<returnitems> returnItems)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string CentreID = HttpContext.Current.Session["CentreID"].ToString();
            string CurrentDeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
            string AssetDeptLedgerNo = "LSHHI4104";
            string UserID = HttpContext.Current.Session["ID"].ToString();
            string IndentNo = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select get_indent_no_Return('" + AssetDeptLedgerNo + "','25','" + CentreID + "')").ToString();
            if (string.IsNullOrEmpty(IndentNo))
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator" });
            }
            else
            {
                returnItems.ForEach(i =>
                {
                    var sql = " INSERT INTO f_indent_detail_Return(IndentNo,ItemId,ItemName,ReqQty,DeptFrom,DeptTo,StoreId,Narration,UserId,Type,CentreID,AssetID,StockID,IsAsset) values (@IndentNo,@ItemId,@ItemName,@ReqQty,@DeptFrom,@DeptTo,@StoreId,@Narration,@UserId,@ReqType,@CentreID,@AssetID,@StockID,@IsAsset) ";
                    excuteCMD.DML(tnx, sql, CommandType.Text, new
                    {
                        IndentNo = IndentNo,
                        ItemId = i.ItemID,
                        ItemName = i.ItemName,
                        ReqQty = 1,
                        DeptFrom = CurrentDeptLedgerNo,
                        DeptTo = AssetDeptLedgerNo,
                        StoreId = "STO00002",
                        Narration = i.Narration,
                        UserId = UserID,
                        ReqType = i.RequestType,
                        CentreID = CentreID,
                        AssetID = i.AssetID,
                        StockID = i.StockID,
                        IsAsset = 1,
                    });
                });
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" + "<br/> Indent No.: " + IndentNo, IndentNo = IndentNo });
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

    public class returnitems
    {
        public string StockID { get; set; }
        public string ItemID { get; set; }
        public string AssetID { get; set; }
        public string ItemName { get; set; }
        public string RequestType { get; set; }
        public string Narration { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public string chklAlreadyRequestSent(string ItemID, string AssetID, string StockID, string ItemName)
    {

        string str = "SELECT em.name RequestBy, DATE_FORMAT(dtEntry,'%d-%b-%Y %I:%i %p')RequestTime FROM f_indent_detail_return i INNER JOIN employee_master em ON em.EmployeeID = i.USerID WHERE AssetID='" + AssetID + "' AND stockID='" + StockID + "' AND DeptFrom='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' AND (ReqQty-ReceiveQty-RejectQty)>0";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Return Request Already Sent...!!! <br/>Request By : " + dt.Rows[0][0] + " <br/>Request at : " + dt.Rows[0][1] });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { response = "",status=false });
        
    }

    [WebMethod(EnableSession=true)]
    public string SearchReturnIndent(string fromdate, string todate, string deptledgerno, string requesttype, string indentno, string status)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT *,IF(StatusNew='1' OR StatusNew='4','true','false')VIEW FROM (  ");
        sb.Append("SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN '3' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN '2'     ");
        sb.Append("WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN '1' ELSE '4'  END)StatusNew   ");
        sb.Append("FROM ( ");
        sb.Append("SELECT id.indentno,id.Type,id.StoreId,DATE_FORMAT(id.dtentry,'%d-%b-%y %I:%i %p')dtEntry,id.Type as RequestType,id.dtEntry as dtEntry1, ");
        sb.Append("lm.ledgername AS DeptFrom,lm.LedgerNumber,  ");
        sb.Append("SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,  ");
        sb.Append("SUM(RejectQty)RejectQty   ");
        sb.Append("FROM f_indent_detail_Return id  ");
        sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = id.Deptfrom   ");
        sb.Append("WHERE id.dtEntry >= '" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND DATE(id.dtEntry) <='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'  AND id.deptto = '" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  ");
        if (deptledgerno != "0")
        {
            sb.Append(" and id.Deptfrom='" + deptledgerno + "'");
        }
        sb.Append("GROUP BY IndentNo     )t ");
        sb.Append(")t1    where 1=1  ");
        if (status != "0")
        {
            sb.Append(" and StatusNew='" + status + "' ");
        }
        if (requesttype != "Select")
        {
            sb.Append(" and RequestType = '" + requesttype + "' ");
        }
        sb.Append(" Order by dtEntry1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public string SearchReturnIndentDetails(string IndentNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT idp.ItemName,eam.BatchNumber,eam.ModelNo,eam.AssetNo,eam.SerialNo,idp.Narration,idp.ItemID,idp.AssetID,idp.StockID "); 
        sb.Append(" FROM f_indent_detail_Return idp  ");
        sb.Append(" INNER JOIN eq_asset_master eam ON eam.ID= idp.AssetID ");
        sb.Append(" WHERE idp.IndentNo='" + IndentNo + "' ORDER BY idp.ItemName");
        
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod(EnableSession = true)]
    public string SaveReturnIndent(List<returnIndentItems> SavereturnItems)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string CentreID = HttpContext.Current.Session["CentreID"].ToString();
            string CurrentDeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
            string AssetDeptLedgerNo = "LSHHI4104";
            string UserID = HttpContext.Current.Session["ID"].ToString();

            int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_Asset_SalesNo('2','STO00002','" + CentreID + "')"));
            int SubStoreSalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Get_Asset_SalesNo('15','STO00002','" + CentreID + "')"));

            SavereturnItems.ForEach(i =>
            {
                var CurStock = "Select * from eq_asset_stock where ID =@stockID";
                var dtStock = excuteCMD.GetDataTable(CurStock, CommandType.Text, new
                {
                    stockID = i.StockID,
                });

                // for transaction typeID =2 
                
                var sqlCMD = "INSERT INTO eq_f_salesdetails (LedgerNumber,DepartmentID,StockID,SoldUnits,PerUnitBuyPrice,PerUnitSellingPrice,DATE,TIME,TrasactionTypeID,ItemID,salesno,UserID,DeptLedgerNo,BatchNo,CentreID,IpAddress,f_StockID,AssetID,Naration,IndentNo,IsReturn)";
                sqlCMD += "VALUES(@LedgerNumber,@DepartmentID,@StockID,@SoldUnits,@PerUnitBuyPrice,@PerUnitSellingPrice,@Date,@Time,@TrasactionTypeID,@ItemID,@salesno,@UserID,@DeptLedgerNo,@BatchNo,@CentreID,@IpAddress,@f_StockID,@AssetID,@Naration,@IndentNo,@IsReturn);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    LedgerNumber = i.FromDepartment,
                    DepartmentID = "STO00002",
                    StockID = dtStock.Rows[0]["FromStockID"].ToString(),
                    SoldUnits = 1,
                    PerUnitBuyPrice = 0,
                    PerUnitSellingPrice = 0,
                    DATE = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd"),
                    TIME = Util.GetDateTime(DateTime.Now).ToString("HH:mm:ss"),
                    TrasactionTypeID = 2,
                    IsReturn = 1,
                    ItemID = i.ItemID,
                    salesno = SalesNo,
                    UserID = UserID,
                    DeptLedgerNo = CurrentDeptLedgerNo,
                    BatchNo = "",
                    CentreID = CentreID,
                    IpAddress = All_LoadData.IpAddress(),
                    f_StockID = dtStock.Rows[0]["StockID"], // main stock table StockID
                    AssetID = i.AssetID,
                    Naration = "",
                    IndentNo = i.IndentNo,
                });

                // for transaction typeID =2 
                
                sqlCMD = "INSERT INTO eq_f_salesdetails (LedgerNumber,DepartmentID,StockID,SoldUnits,PerUnitBuyPrice,PerUnitSellingPrice,DATE,TIME,TrasactionTypeID,ItemID,salesno,UserID,DeptLedgerNo,BatchNo,CentreID,IpAddress,f_StockID,AssetID,Naration,IndentNo,IsReturn)";
                sqlCMD += "VALUES(@LedgerNumber,@DepartmentID,@StockID,@SoldUnits,@PerUnitBuyPrice,@PerUnitSellingPrice,@Date,@Time,@TrasactionTypeID,@ItemID,@salesno,@UserID,@DeptLedgerNo,@BatchNo,@CentreID,@IpAddress,@f_StockID,@AssetID,@Naration,@IndentNo,@IsReturn);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    LedgerNumber = CurrentDeptLedgerNo,
                    DepartmentID = "STO00002",
                    StockID = i.StockID,
                    SoldUnits = 1,
                    PerUnitBuyPrice = 0,
                    PerUnitSellingPrice = 0,
                    DATE = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd"),
                    TIME = Util.GetDateTime(DateTime.Now).ToString("HH:mm:ss"),
                    TrasactionTypeID = 15,
                    IsReturn = 0,
                    ItemID = i.ItemID,
                    salesno = SalesNo,
                    UserID = UserID,
                    DeptLedgerNo = i.FromDepartment ,
                    BatchNo = "",
                    CentreID = CentreID,
                    IpAddress = All_LoadData.IpAddress(),
                    f_StockID = dtStock.Rows[0]["StockID"], // main stock table StockID
                    AssetID = i.AssetID,
                    Naration = "",
                    IndentNo = i.IndentNo,
                });


                string strStock = "update eq_asset_stock set ReleasedCount=ReleasedCount - 1 WHERE ID = @ID ";
                excuteCMD.DML(tnx, strStock, CommandType.Text, new
                {
                    ID = Util.GetString(dtStock.Rows[0]["fromStockID"]),
                });
                
                string strStock1 = "update eq_asset_stock set ReleasedCount=ReleasedCount + 1 WHERE ID = @ID  ";
                excuteCMD.DML(tnx, strStock1, CommandType.Text, new
                {
                    ID =Util.GetString(i.StockID)
                });
                
                var sqlcd = "Update f_stock set ReleasedCount=ReleasedCount-1 where StockID=@ID";
                excuteCMD.DML(tnx, sqlcd, CommandType.Text, new
                {
                    ID = Util.GetInt(dtStock.Rows[0]["StockID"]),
                });
                //--------Update Indent table
               
                var sql = "Update f_indent_detail_Return set ReceiveQty=ReceiveQty+1 where IndentNo=@IndentNo and AssetID=@AssetID";
                excuteCMD.DML(tnx, sql, CommandType.Text, new
                {
                    IndentNo = i.IndentNo,
                    AssetID = i.AssetID
                });

                sql = "Update eq_asset_location set IsActive=0,DeActiveRemarks='Department Return' where DeptLedgerNo=@deptledgerno and AssetID=@AssetID";
                excuteCMD.DML(tnx, sql, CommandType.Text, new
                {
                    deptledgerno = i.FromDepartment,
                    AssetID = i.AssetID
                });
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



    public class returnIndentItems
    {
        public string StockID { get; set; }
        public string ItemID { get; set; }
        public string AssetID { get; set; }
        public string ItemName { get; set; }
        public string FromDepartment { get; set; }
        public string IndentNo { get; set; } 
    }

    [WebMethod]
    public string SearchCurrentStocktoReturn(string deptledgerNo, string roomID, string cubicalID, string locationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT am.ItemName as AssetName,am.BatchNumber,am.ModelNo,am.SerialNo,am.AssetNo,ifnull(rm.RoomName,'')RoomName,ifnull(cm.CubicalName,'')CubicalName,ifnull(lm.LocationName,'')LocationName,em.Name AS createdby, ");
        sb.Append("DATE_FORMAT(al.CreatedDateTime,'%d-%b-%Y')CreatedDate,al.ID AS SetID,ast.ID as StockID,al.LocationID,al.RoomID,al.CubicalID,am.ItemID,ast.AssetID,if(ifnull(am.InstallationDate,'')='','0','1')isInstallationDone,Date_Format(InstallationDate,'%d-%b-%Y')InstallationDate,InstallationBy,InstallationRemarks ");
        sb.Append("FROM eq_asset_Stock ast LEft JOIN  eq_asset_location al on al.AssetID= ast.AssetID and al.IsActive=1 ");
        
        if (roomID != "0")
            sb.Append("AND al.RoomID='" + roomID + "' ");
        if (cubicalID != "0")
            sb.Append("AND al.CubicalID='" + cubicalID + "' ");
        if (locationID != "0")
            sb.Append("AND al.LocationID='" + locationID + "' ");
        
        sb.Append("LEft JOIN eq_roommaster rm ON rm.ID = al.RoomID ");
        sb.Append("LEFT JOIN eq_cubicalmaster cm ON cm.ID= al.CubicalID ");
        sb.Append("LEft JOIN eq_location_master lm ON lm.ID= al.LocationID ");
        sb.Append("INNER JOIN eq_asset_master am ON am.ID= ast.AssetID ");
        sb.Append("LEft JOIN employee_master em ON em.EmployeeID= al.CreatedBy ");
        sb.Append("WHERE ast.isPost=1 AND ast.initialcount>ast.releasedCount ");
        if (deptledgerNo != "0")
            sb.Append("AND ast.DeptLedgerNo='" + deptledgerNo + "' ");
        sb.Append(" Order by al.AssetName,al.ID ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession=true)]
    public string PrintAsseteturnRequisition(string IndentNo)
    {


        StringBuilder sb1 = new StringBuilder();
        sb1.Append("select '' StatusNew,id.IndentNo,(rd.DeptName)DeptFrom,(rd1.DeptName)DeptTo,id.ItemName,id.ReqQty,id.UnitType,id.Narration,id.isApproved, ");
        sb1.Append(" id.ApprovedBy,id.ApprovedReason,id.dtEntry,id.UserId,Concat(em.Title,' ',em.Name)EmpName,id.ReceiveQty,id.RejectQty,id.RejectBy, am.AssetNo,am.SerialNo,am.ModelNo from f_indent_detail_return id inner  ");
        sb1.Append(" join f_rolemaster rd on id.DeptFrom=rd.DeptLedgerNo inner join f_rolemaster rd1  ");
        sb1.Append(" on id.DeptTo=rd1.DeptLedgerNo inner join employee_master em on id.UserId=em.EmployeeID  INNER JOIN eq_asset_master am ON am.id=id.AssetID ");
        sb1.Append(" where indentno='" + IndentNo + "' ");


        DataTable dtImg = new DataTable();// All_LoadData.CrystalReportLogo();
        DataSet ds = new DataSet();
        ds.Tables.Add(StockReports.GetDataTable(sb1.ToString()).Copy());
        ds.Tables.Add(dtImg.Copy());
        //   ds.WriteXmlSchema(@"D:\AssetReturnIndentPrint.xml");

        Session["ReportName"] = "AssetReturnIndentPrint";
        HttpContext.Current.Session["ds"] = ds;
        HttpContext.Current.Session["ReportName"] = "AssetReturnIndentPrint";
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });

    }

    [WebMethod(EnableSession = true)]
    public string ReprintDepartmentReturnReciept(string salesno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(sd.Date,'%d-%b-%Y')IssueDate,TIME_FORMAT(sd.Time,'%I:%i %p')IssueTime,sd.salesno,sd.IndentNo ,lm.LedgerName, ");
        sb.Append("am.ItemName,am.BatchNumber,am.ModelNo,am.SerialNo,am.AssetNo,sd.SoldUnits,sd.Naration,CONCAT(em.title,'',em.Name )AS IssueBy ");
        sb.Append("FROM eq_f_salesdetails sd  ");
        sb.Append("INNER JOIN eq_asset_master am ON am.ID=sd.AssetID ");
        sb.Append("LEFT JOIN f_indent_detail idp ON idp.IndentNo=sd.IndentNo AND idp.ItemId= sd.ItemID ");
        sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber= sd.LedgerNumber ");
        sb.Append("INNER JOIN employee_master em ON sd.UserID= em.EmployeeID ");
        sb.Append("WHERE sd.salesno='" + salesno + "' and sd.TrasactionTypeID=2 ");
        sb.Append("GROUP BY sd.ID ORDER BY sd.Date,sd.Time ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //   ds.WriteXmlSchema(@"D:\ReprintAssetDepartmentIssue.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "ReprintAssetDepartmentReturn";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/Commonreport.aspx" });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record found" });
    }
    

    

}