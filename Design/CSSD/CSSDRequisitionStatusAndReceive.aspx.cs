using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CSSD_CSSDRequisitionStatusAndReceive : System.Web.UI.Page
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
        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' ORDER BY LedgerName";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlFromDept.DataSource = dt;
            ddlFromDept.DataTextField = "LedgerName";
            ddlFromDept.DataValueField = "LedgerNumber";
            ddlFromDept.DataBind();
            ddlFromDept.Items.Insert(0, new ListItem("Select", "0"));
            ddlFromDept.SelectedIndex = ddlFromDept.Items.IndexOf(ddlFromDept.Items.FindByText("Sterilizing(CSSD)"));
            ddlFromDept.Enabled = false;

        }
        else
        {
            ddlFromDept.Items.Insert(0, new ListItem("--No Data Bound--", "0"));
        }
    }
    [WebMethod(EnableSession = true)]
    public static string searchReqisition(string requestId, string toDept, string status, string fromDate, string toDate, string requestType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT req.`requestType`,req.`requestId`,DATE_FORMAT(req.`createdDateTime`,'%d-%b-%Y %h:%i %p') 'DateTime', ");
        sb.Append(" rm.`RoleName` 'ToDept',CONCAT(em.`Title`,' ',em.`Name`)'CreatedBy',IF(SUM(req.`isUsed`)>0,'Used',req.`status`)'status',COUNT(DISTINCT req.`setId`) 'TotalSets',COUNT(req.`itemId`)'Total Items' ");
        sb.Append(" FROM cssd_requisition req  ");
        sb.Append(" INNER JOIN `f_rolemaster` rm ON rm.`DeptLedgerNo`=req.`toDept` ");
        sb.Append(" INNER JOIN `employee_master` em ON em.`EmployeeID`=req.`userId` ");
        if (!String.IsNullOrEmpty(requestId))
            sb.Append(" WHERE req.`requestId`='" + requestId + "'  ");
        else
        {
            sb.Append(" WHERE req.`createdDateTime`>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND req.`createdDateTime`<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (!String.IsNullOrEmpty(status))
                sb.Append(" AND  req.`status`=" + Util.GetInt(status) + " ");
            if (toDept != "" && toDept != "0")
                sb.Append(" AND  req.toDept='" + toDept + "' ");

        }
        sb.Append(" AND req.`fromDept`='" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "' AND req.`requestType`='" + requestType + "' ");
        sb.Append(" GROUP BY req.`requestId` ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string getRequestDetails(string requestId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT req.CssdComment,req.Comment,req.`id`,req.`requestId`,sm.`Name` 'SetName',im.`TypeName` 'ItemName', ");
        sb.Append("  req.`reqQty`,req.`setId`,req.`itemId`,req.`IssuedQty`, ");
        sb.Append(" IF(bt.`validityDate` IS NULL,req.`status`,IF(req.IsUsed=1,'Used',IF(bt.`validityDate`<CURDATE(),'Expired',req.`status`)))'Status' ");
        sb.Append(" FROM cssd_requisition req   ");
        sb.Append(" INNER JOIN `f_itemmaster` im ON im.`ItemID`=req.`itemId` ");
        sb.Append(" INNER JOIN cssd_f_set_master sm ON sm.`Set_ID`=req.`setId`  ");
        sb.Append(" LEFT JOIN  cssd_f_batch_tnxdetails bt ON bt.`requestReturnId`=req.`requestId` ");
        sb.Append(" AND bt.`IsIssued`=1 AND bt.`ItemID`=req.`itemId` AND bt.`SetID`=bt.`SetID` ");
        sb.Append(" WHERE req.`requestId`='" + requestId + "' GROUP BY req.`id` ORDER BY sm.`Name`,im.`TypeName`  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public static string updateUsed(List<updatedDataList> data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string usedTID = string.Empty;
            string sqlCommand = string.Empty;
            ExcuteCMD cmd = new ExcuteCMD();
            foreach (var item in data)
            {
                if (!String.IsNullOrEmpty(item.usedUHID))
                {
                    sqlCommand = "SELECT COUNT(*) FROM `patient_master` pm WHERE pm.`PatientID`=@PID";
                    int IsUHIDExists = Util.GetInt(cmd.ExecuteScalar(tnx, sqlCommand, CommandType.Text, new
                    {
                        PID = item.usedUHID
                    }));

                    if (IsUHIDExists == 0)
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "UHID : <span class='patientInfo'>" + item.usedUHID + "</span> Is Invalid." });


                    sqlCommand = "SELECT pip.`TransactionID` FROM `patient_ipd_profile` pip WHERE pip.`PatientID`=@Pid AND pip.`Status`='IN' LIMIT 1";
                    usedTID = Util.GetString(cmd.ExecuteScalar(tnx, sqlCommand, CommandType.Text, new
                    {
                        PID = item.usedUHID
                    }));
                }
                sqlCommand = " UPDATE cssd_requisition req SET req.`isUsed`=1,req.`usedAgainstUHID`=@PID,req.`usedAgainstTID`=@TID,req.`usedUpdatedBy`=@usedId,req.usedUpdatedOn=NOW() WHERE req.`id`=@id ";
                cmd.DML(tnx, sqlCommand, CommandType.Text, new
                {
                    PID = item.usedUHID,
                    TID = usedTID,
                    usedId = HttpContext.Current.Session["ID"].ToString(),
                    id = item.id

                });



            }



            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Items Used Successfully." });

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

public class updatedDataList
{
    public string id { get; set; }
    public string usedUHID { get; set; }


}