using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Store_CreateIndent : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Util.GetString(Session["DeptLedgerNo"]) == "")
            {
                string msg = "This department is not having the store right.";
                Response.Redirect("MsgPage.aspx?msg=" + msg + "");
            }
            AllLoadData_Store.bindStore(ddlStoreType, "STO");
            //DataTable dt = StockReports.GetRights(Session["RoleID"].ToString());
            //if (dt.Rows.Count > 0)
            //{
            //    if (Util.GetBoolean(dt.Rows[0]["IsGeneral"]) == true && Util.GetBoolean(dt.Rows[0]["IsMedical"]) == true)
            //        ddlStoreType.SelectedIndex = ddlStoreType.Items.IndexOf(ddlStoreType.Items.FindByValue("STO00001"));
            //    else if (Util.GetBoolean(dt.Rows[0]["IsMedical"]) == true)
            //    {
            //        ddlStoreType.SelectedIndex = ddlStoreType.Items.IndexOf(ddlStoreType.Items.FindByValue("STO00001"));
            //        ddlStoreType.Attributes.Add("disabled", "disabled");
            //    }
            //    else if (Util.GetBoolean(dt.Rows[0]["IsGeneral"]) == true)
            //    {
            //        ddlStoreType.SelectedIndex = ddlStoreType.Items.IndexOf(ddlStoreType.Items.FindByValue("STO00002"));
            //        ddlStoreType.Attributes.Add("disabled", "disabled");
            //    }
            //}
            ViewState["centerID"] = Session["CentreID"].ToString();
            ViewState["deptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["userID"] = Session["ID"].ToString();
            ViewState["PurchaseRequestNo"] = Util.GetString(Request.QueryString["PurchaseRequestNo"]);

            calExtenderFromDate.EndDate = System.DateTime.Now;
            calExtenderToDate.EndDate = System.DateTime.Now;
            CalExtenTxtSearchPurchaseFromDate.EndDate = System.DateTime.Now;
            CalExtenTxtSearchPurchaseToDate.EndDate = System.DateTime.Now;
            calExtRequisitionOn.EndDate = System.DateTime.Now;
            txtSearchPurchaseFromDate.Text = txtSearchPurchaseToDate.Text = txtSearchFromDate.Text = txtSearchToDate.Text = txtRequisitionOn.Text = txtFromDate.Text = txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtSearchFromDate.Attributes.Add("readonly", "true");
        txtSearchToDate.Attributes.Add("readonly", "true");
        txtRequisitionOn.Attributes.Add("readonly", "true");
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
        txtSearchPurchaseFromDate.Attributes.Add("readonly", "true");
        txtSearchPurchaseToDate.Attributes.Add("readonly", "true");
    }
    [WebMethod]
    public static string BindDepartment(string CentreID, string storetype)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT lm.`LedgerName`,lm.`LedgerNumber`FROM f_rolemaster rm INNER JOIN f_ledgermaster lm ON lm.`LedgerNumber`=rm.`DeptLedgerNo`INNER JOIN f_centre_role cr ON cr.RoleID=rm.id AND cr.CentreID IN (" + CentreID + ")  AND cr.isActive=1  WHERE rm.Active=1 AND cr.IsDepartmentIndent=1 ");
        if (storetype == "STO00001")
            sb.Append(" and rm.IsMedical=1 ");
        else
            sb.Append(" and rm.IsGeneral=1 ");

        sb.Append(" order by LedgerName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { Status = true, response = dt, message = "" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { Status = false, response = "", message = "" });
        }
    }
    [WebMethod(EnableSession = true)]
    public static string getItemStockDetails(string itemID, int centreID, string departmentLedgerID, string centreto, string departmentto, string fromdate, string todate, string SubCategoryID)
    {
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append("SELECT (Select IFNULL(SUM(in_.ReqQty-in_.ReceiveQty-in_.RejectQty),0) FROM f_indent_detail in_ WHERE in_.itemid=@itemID AND  in_.DeptFrom=@departmentLedgerID AND in_.CentreID=@centreID GROUP BY in_.ItemId) PendingQty ,     ");
        sqlCMD.Append("IFNULL((SELECT SUM(IF(TrasactionTypeID IN(3,13),SoldUnits,0)) FROM f_salesdetails    ");
        sqlCMD.Append("WHERE DATE<=@fromdate AND DATE>=@todate AND  ItemID=ind.ItemId AND  TrasactionTypeID IN(3,13) AND DeptLedgerNo=@departmentLedgerID   ");
        sqlCMD.Append("AND CentreID=@centreID GROUP BY itemid),0) SalesQuantity,     ");
        sqlCMD.Append("IFNULL((SELECT SUM(st.InitialCount-st.ReleasedCount) FROM f_stock st WHERE st.ispost=1 AND (st.InitialCount-st.ReleasedCount)>=0         ");
        sqlCMD.Append("AND st.DeptLedgerNo=@departmentto AND   st.itemid=ind.ItemId  ");
        sqlCMD.Append("AND st.CentreID=@centreto GROUP BY st.ITemID),0)DeptStock,  ");
        sqlCMD.Append("IFNULL((SELECT SUM(st.InitialCount-st.ReleasedCount)DeptQty FROM f_stock st WHERE st.ispost=1 AND (st.InitialCount-st.ReleasedCount)>=0         ");
        sqlCMD.Append(" and st.DeptLedgerNo=@departmentLedgerID AND st.itemid=ind.ItemId AND st.CentreID=@centreID GROUP BY st.ITemID),0)CurrentStock  ");
        sqlCMD.Append("FROM f_stock ind WHERE ind.itemid=@itemID  ");
        sqlCMD.Append("GROUP BY ind.ItemId  ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var obj = new
        {
            itemID = itemID,
            centreID = centreID,
            departmentLedgerID = departmentLedgerID,
            centreto = centreto,
            departmentto = departmentto,
            fromdate = Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"),
            todate = Util.GetDateTime(todate).ToString("yyyy-MM-dd")
        };
        string rowQ = excuteCMD.GetRowQuery(sqlCMD.ToString(), obj);
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, obj);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public static string GetAutoPurchaseRequestItems(string departmentLedgerNo, string centreID, string fromDate, string toDate, int minDays, int reorderInDays, bool includeStoreToStore, string CategoryID, string SubCategoryID, int groupID, string centreto, string departmentto)
    {
        DateTime dFromDate = Util.GetDateTime(fromDate);
        DateTime dToDate = Util.GetDateTime(toDate);

        int differenceInDays = (dToDate - dFromDate).Days;
        if (differenceInDays < 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Invalid Date Combination." });

        StringBuilder sqlCmd = new StringBuilder("SELECT 0  Quantity,0 IndentQuantity, s.*,ROUND((((s.AvgConsumption*@reorderInDays)-(s.CurrentStock+PendingQty))/1),0)SalesQuantity, ");
        sqlCmd.Append("ROUND((((s.AvgConsumption*@reorderInDays)-(s.CurrentStock+PendingQty))/1),0)NetQuantity,IFNULL((SELECT SUM(f.InitialCount-f.ReleasedCount)   ");
        sqlCmd.Append("FROM f_stock f  WHERE f.CentreID=@centreto AND f.DeptLedgerNo=@departmentto   ");
        sqlCmd.Append("AND f.ItemID=s.ItemID AND f.IsPost=1 AND (f.InitialCount-f.ReleasedCount)>0 ),0) DeptStock ");
        sqlCmd.Append("FROM (SELECT t.*,(t.AvgConsumption*@minDays)MinConsumption,  ");
        sqlCmd.Append("IFNULL((SELECT SUM(st.InitialCount-St.ReleasedCount) FROM f_stock st WHERE st.DeptLedgerNo=@departmentLedgerNo AND st.CentreID=@centreID  ");
        sqlCmd.Append("AND  st.ItemID=t.ItemID AND St.IsPost=1  AND (st.InitialCount-st.ReleasedCount)>0 ),0)CurrentStock,  ");
        sqlCmd.Append("IFNULL((SELECT IFNULL(SUM(ind.ReqQty-ind.ReceiveQty-ind.RejectQty),0) ");
        sqlCmd.Append("FROM f_indent_detail ind WHERE  ind.itemid=t.ItemID AND  ind.DeptFrom=@departmentLedgerNo ");
        sqlCmd.Append("AND ind.CentreID=@centreID AND ind.ReqQty!=ind.ReceiveQty GROUP BY ind.ItemId),0)PendingQty ");
        sqlCmd.Append("FROM (  ");
        sqlCmd.Append("SELECT im.TypeName ItemName,s.ItemID,im.SubCategoryID,im.`ConversionFactor`,im.MinorUnit PurchaseUnit, ");
        sqlCmd.Append("ROUND(SUM(IF(s.TrasactionTypeID IN(3,4,16),s.SoldUnits,-1*s.SoldUnits))/DATEDIFF(@toDate,@fromDate)) AvgConsumption ");
        sqlCmd.Append("FROM f_salesdetails s  ");
        sqlCmd.Append("INNER JOIN f_itemmaster im ON im.ItemID=s.ItemID  ");
        sqlCmd.Append("INNER JOIN f_subcategorymaster fcm ON fcm.SubCategoryID=im.SubCategoryID ");
        sqlCmd.Append("WHERE s.DeptLedgerNo=@departmentLedgerNo AND s.CentreID=@centreID   ");
        sqlCmd.Append("AND s.TrasactionTypeID IN(1,2,5,6,17,3,4,16)  AND s.Date>=@fromDate  ");
        sqlCmd.Append("AND s.Date<=@toDate  AND fcm.CategoryID=@categoryID GROUP BY s.ItemID  ");
        sqlCmd.Append(")t  ");
        sqlCmd.Append("HAVING MinConsumption>(CurrentStock+PendingQty)  ORDER BY ItemName)s ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var obj = new
        {
            departmentLedgerNo = departmentLedgerNo,
            centreID = centreID,
            centreto = centreto,
            categoryID = CategoryID,
            departmentto = departmentto,
            fromDate = dFromDate.ToString("yyyy-MM-dd"),
            toDate = dToDate.ToString("yyyy-MM-dd"),
            minDays = minDays,
            reorderInDays = reorderInDays,
        };
        //string s = excuteCMD.GetRowQuery(sqlCmd.ToString(), obj);
        DataTable dt = excuteCMD.GetDataTable(sqlCmd.ToString(), CommandType.Text, obj);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public static string Save(List<ItemDetail> ItemDetails, string storeId, string narration, string requestType, string requisitionDate, string purchaseRequestNo, string issueToDepartment, int issueToCenterID, string departmeledgerno, int centreid)
    {
        string IndentNo = "";
        int storeLedgerNo = 28;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (storeId == "STO00001")
            {
                storeLedgerNo = 11;
            }
            else
            {
                storeLedgerNo = 28;
            }
            if (string.IsNullOrEmpty(purchaseRequestNo))
            {
                IndentNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select get_indent_no('" + departmeledgerno + "','" + storeLedgerNo + "','" + centreid + "')").ToString();
            }
            else
            {
                IndentNo = purchaseRequestNo;
            }
            if (IndentNo != "")
            {
                for (int i = 0; i < ItemDetails.Count; i++)
                {
                    var item = ItemDetails[i];
                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO f_indent_detail(IndentNo,ItemId,ItemName,ReqQty,UnitType,DeptFrom,DeptTo,StoreId,Narration,UserId,Type,CentreID,Hospital_Id,ToCentreID,Remarks)  ");
                    sb.Append("values('" + IndentNo + "','" + item.ItemID + "','" + item.ItemName + "'," + item.NetQuantity + "");
                    sb.Append(",'" + item.PurchaseUnit + "','" + departmeledgerno + "','" + issueToDepartment + "', ");
                    sb.Append(" '" + storeId + "','" + narration + "', ");
                    sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + requestType + "','" + centreid + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + issueToCenterID + "','" + item.Remarks + "') ");

                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                    {
                        Tranx.Rollback();
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage, response = AllGlobalFunction.errorMessage });
                    }
                }
                Tranx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Record Save Successfully.", response = "Record Save Successfully.", IndentNo = IndentNo });
            }
            else
            {
                Tranx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Please Create Indent No.", response = "Please Create Indent No." });
            }
        }

        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = ex.Message, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            PrintIndent(IndentNo);
        }
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
        public string Remarks { get; set; }
        private int _ID;
        public int ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
    }
    public static void PrintIndent(string IndentNo)
    {
        StringBuilder sb1 = new StringBuilder();
        sb1.Append("select id.IndentNo,(rd.RoleName)DeptFrom,(rd1.RoleName)DeptTo,id.ItemName,id.ReqQty,id.UnitType,id.Narration,id.isApproved, ");
        sb1.Append("id.ApprovedBy,id.ApprovedReason,id.dtEntry,id.UserId,CONCAT(em.Title,' ',em.Name)EmpName,id.Type, id.Remarks AS ItemRemarks FROM f_indent_detail id   ");
        sb1.Append(" INNER JOIN f_roleMaster rd on id.DeptFrom=rd.DeptLedgerNo INNER JOIN f_roleMaster rd1  ");
        sb1.Append("on id.DeptTo=rd1.DeptLedgerNo INNER JOIN employee_master em on id.UserId=em.EmployeeID  ");
        sb1.Append("where indentNo='" + IndentNo + "' ");
        DataTable dtImg = All_LoadData.CrystalReportLogo();
        DataSet ds = new DataSet();
        ds.Tables.Add(StockReports.GetDataTable(sb1.ToString()).Copy());
        ds.Tables.Add(dtImg.Copy());
        HttpContext.Current.Session["ds"] = ds;
        HttpContext.Current.Session["ReportName"] = "NewIndent";
    }

    [WebMethod(EnableSession = true)]
    public static string GetItems(string storeID, string itemtype, string DeptLedgerNo, string SubCategoryID)
    {
        DataTable dtItem = new DataTable();
        int configID = 0;
        if (storeID == "STO00001")
            configID = 11;
        else
            configID = 28;
        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT IM.itemcode, IM.Typename ItemName, IM.Typename, IM.SubCategoryID, im.MinorUnit, im.MajorUnit,im.ItemID,im.ConversionFactor FROM f_itemmaster IM  INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID  INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID ");
     // sqlCMD.Append(" INNER JOIN f_stock st ON st.`ItemID`=im.`ItemID` AND IF(st.IsExpirable=0,1=1,st.`MedExpiryDate`>CURDATE() ) "); 
        sqlCMD.Append(" LEFT JOIN f_stock st ON st.`ItemID`=im.`ItemID` ");   
        sqlCMD.Append(" WHERE CR.ConfigID = @configID  AND im.IsActive = 1 AND itc.`IsActive`=1 AND im.IsStockable=" + itemtype + " ");
     // sqlCMD.Append(" AND (st.`InitialCount`-st.`ReleasedCount`)>0  AND IF(@DeptLedgerNo='0',1=1,st.`DeptLedgerNo`=@DeptLedgerNo) ");
        sqlCMD.Append(" AND itc.`CentreID`= '" + HttpContext.Current.Session["CentreID"].ToString() + "'  ");

        if (SubCategoryID != "0")
            sqlCMD.Append(" AND im.SubCategoryID = " + SubCategoryID + " ");

        sqlCMD.Append(" GROUP BY im.ItemID ");
        ExcuteCMD excuteCMD = new ExcuteCMD();

        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            configID = configID,
            DeptLedgerNo = DeptLedgerNo
        });
        string rowQ = excuteCMD.GetRowQuery(sqlCMD.ToString(), new
        {
            configID = configID

        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
}