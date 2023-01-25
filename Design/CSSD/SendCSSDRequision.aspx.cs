using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_CSSD_SendCSSDRequision : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            BindDepartments();
        }

    }

    private void BindDepartments()
    {
        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' ORDER BY LedgerName";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlToDepartment.DataSource = dt;
            ddlToDepartment.DataTextField = "LedgerName";
            ddlToDepartment.DataValueField = "LedgerNumber";
            ddlToDepartment.DataBind();
            ddlToDepartment.Items.Insert(0, new ListItem("Select", "0"));
            ddlToDepartment.SelectedIndex = ddlToDepartment.Items.IndexOf(ddlToDepartment.Items.FindByText("Sterilizing(CSSD)"));
            ddlToDepartment.Enabled = false;

        }
        else
        {
            ddlToDepartment.Items.Insert(0, new ListItem("--No Data Bound--", "0"));
        }


    }

    [WebMethod]
    public static string loadSetItems(string setId)
    {
        string sqlCommand = " SELECT sid.`SetID`,sm.`Name`'SetName',sid.`ItemID`,im.`TypeName` 'ItemName',sid.`Quantity` 'Qty'  ";
        sqlCommand += " FROM cssd_set_itemdetail sid ";
        sqlCommand += "  INNER JOIN f_itemmaster im ON im.`ItemID`=sid.`ItemID` ";
        sqlCommand += "  INNER JOIN cssd_f_set_master sm ON sm.`Set_ID`=sid.`SetID` ";
        sqlCommand += "  WHERE sid.`SetID`='" + setId + "' AND sid.`IsActive`=1 AND sm.`IsActive`=1";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCommand));
    }

    [WebMethod(EnableSession = true)]
    public static string loadReturnableSetItems(string setId, string requestId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  CONCAT(req.`requestId`,'#',req.setId)'SetIdSelected',req.setId,sm.name 'SetName',st.`ItemName` 'ItemName',st.`ItemID` 'ItemID' ");
        sb.Append(" ,(st.`InitialCount`-st.`ReleasedCount`)'Qty' FROM f_stock st  ");
        sb.Append(" INNER JOIN cssd_batchtnx_requisition tr ON tr.`toStockId`=st.`StockID`  AND st.`DeptLedgerNo`='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' ");
        sb.Append(" INNER JOIN cssd_requisition req ON req.`requestId`=tr.`requisitionid` AND st.`SetID`=req.`setId` AND st.`ItemID`=req.`itemId` ");
        sb.Append(" INNER JOIN cssd_f_batch_tnxdetails bt ON bt.`ID`=tr.`batchTnxId` ");
        sb.Append(" INNER JOIN cssd_f_set_master sm ON sm.`Set_ID`=req.`setId` ");
        sb.Append(" WHERE (st.`InitialCount`-st.`ReleasedCount`)>0 AND (req.`isUsed`=1 OR bt.`validityDate`>CURDATE()) ");
        sb.Append(" AND req.`requestId`='" + requestId + "' AND req.`setId`='" + setId + "' ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod(EnableSession = true)]
    public static string SaveRequisition(List<requisitionDataList> data, string toDeptLedgerNo)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string sqlCommand = "SELECT get_cssd_request_id('" + toDeptLedgerNo + "')";
            ExcuteCMD cmd = new ExcuteCMD();
            string requestId = Util.GetString(cmd.ExecuteScalar(tnx, sqlCommand, CommandType.Text));

            sqlCommand = " INSERT INTO cssd_requisition(requestId,fromDept,toDept,setId,itemId,masterQty,reqQty,userId,ipAddress,requestType,retrunAgainstRequestId,Comment) ";
            sqlCommand += " VALUES(@requestId,@fromDept,@toDept,@setId,@itemId,@masterQty,@reqQty,@userId,@ipAddress,@requestType,@retrunAgainstRequestId,@Comment) ";
            foreach (var item in data)
            {
                cmd.DML(tnx, sqlCommand, CommandType.Text, new
                {
                    requestId = requestId,
                    fromDept = HttpContext.Current.Session["DeptLedgerNo"].ToString(),
                    toDept = toDeptLedgerNo,
                    setId = item.setId,
                    itemId = item.itemId,
                    masterQty = Util.GetInt(item.masterQty),
                    reqQty = Util.GetInt(item.reqQty),
                    userId = HttpContext.Current.Session["ID"].ToString(),
                    ipAddress = All_LoadData.IpAddress(),
                    requestType = item.requestType,
                    retrunAgainstRequestId = item.retrunAgainstRequestId,
                    Comment=item.Comment

                });
            }

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Request Id :<span class='patientInfo'>" + requestId + "</span> Generated." });
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
    public static string LoadReturnableSets()
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  CONCAT(sm.`Name`,'(Req. Id :',req.`requestId`,')')'SetName',CONCAT(req.`requestId`,'#',req.setId)'Set_Id' FROM f_stock st  ");
        sb.Append(" INNER JOIN cssd_batchtnx_requisition tr ON tr.`toStockId`=st.`StockID`  AND st.`DeptLedgerNo`='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "'  ");
        sb.Append(" INNER JOIN cssd_requisition req ON req.`requestId`=tr.`requisitionid` AND st.`SetID`=req.`setId` AND st.`ItemID`=req.`itemId` ");
        sb.Append(" INNER JOIN cssd_f_batch_tnxdetails bt ON bt.`ID`=tr.`batchTnxId` ");
        sb.Append(" INNER JOIN cssd_f_set_master sm ON sm.`Set_ID`=req.`setId` ");
        sb.Append(" WHERE (st.`InitialCount`-st.`ReleasedCount`)>0 AND (req.`isUsed`=1 OR bt.`validityDate`>CURDATE()) GROUP BY req.`requestId`,req.`setId` ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}


public class requisitionDataList
{
    public string setId { get; set; }
    public string itemId { get; set; }
    public string setName { get; set; }
    public string itemName { get; set; }
    public string masterQty { get; set; }
    public int reqQty { get; set; }
    public string requestType { get; set; }
    public string retrunAgainstRequestId { get; set; }
    public string Comment { get; set; }




}