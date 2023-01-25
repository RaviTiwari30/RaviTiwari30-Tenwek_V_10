using System;
using System.Web.Services;
using System.Text;
using System.Web;
using System.Data;
using System.Collections.Generic;
using MySql.Data.MySqlClient;

public partial class Design_EDP_DiscountApproveUnApprove : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFrom.EndDate = DateTime.Now;
            calTo.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");

    }
    [WebMethod(EnableSession = true)]
    public static string Search(string type, string uhid, string billNo, string status, string fromDate, string toDate,string tnxType)
    {
        StringBuilder sb = new StringBuilder();

        int isSuperAuthority = Util.GetInt(StockReports.ExecuteScalar(" SELECT if(ColName='CanApproveAllDiscountApproval','1','0')CanApproveAllDiscountApproval FROM userauthorization WHERE RoleId='" + HttpContext.Current.Session["RoleID"].ToString() + "' AND EmployeeId='" + HttpContext.Current.Session["ID"].ToString() + "' and colName='CanApproveAllDiscountApproval' "));
        
        if (type.Trim().ToUpper() == "OPD")
        {
            sb.Append(" SELECT 'OPD' AS 'Type',IF(lt.GrossAmount<0,'Refund','Discount')TnxType,pm.PatientID 'UHID',lt.`BillNo`,DATE_FORMAT(lt.`BillDate`,'%d-%b-%Y')'BillDate',CONCAT(pm.`Title`,' ',pm.`PName`)'PName', ");
            sb.Append(" pm.`Age`,pm.`Mobile`,lt.`GrossAmount`,lt.`DiscountOnTotal` 'DiscAmt',lt.`NetAmount`,CONCAT(em.`Title`,' ',em.`Name`)'DiscUser', ");
            sb.Append(" lt.`DiscountReason`,lt.`DiscountApproveBy`,IF(lt.discountApprovalStatus=0,'Pending',IF(lt.discountApprovalStatus=1,'Approved','UnApproved'))'Status' ");
            sb.Append(" ,IF(lt.discountApprovalStatus=0,'',(SELECT CONCAT(e.`Title`,' ',e.`Name`) FROM employee_master e WHERE e.`EmployeeID`=lt.discountApprovalStatusUpdatedBy))'UpdatedBy',IFNULL(lt.discountApprovalRemarks,'') 'Remarks' ");
            sb.Append(" FROM `f_ledgertransaction` lt  ");
            sb.Append(" INNER JOIN `patient_medical_history` pmh ON lt.`TransactionID`=pmh.`TransactionID`  ");
            sb.Append(" AND lt.`Date`>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + "' AND lt.`Date`<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + "' ");
            if (tnxType == "Discount")
                sb.Append(" AND lt.`DiscountOnTotal`>0 ");
            else if (tnxType == "Refund")
                sb.Append(" AND lt.GrossAmount<0 ");
            else
                sb.Append("  AND (lt.GrossAmount<0 OR lt.DiscountOnTotal>0) ");
            sb.Append(" AND lt.`DiscountApproveBy`<>'' AND pmh.`Type`='OPD' AND lt.discountApprovalStatus=" + Util.GetInt(status) + " ");
            if (!String.IsNullOrEmpty(uhid))
                sb.Append(" AND pmh.`Patient_ID`='" + uhid.Trim() + "' ");
            if (!String.IsNullOrEmpty(billNo))
                sb.Append(" lt.`BillNo`='" + billNo.Trim() + "' ");
            sb.Append(" INNER JOIN f_discountapproval da ON da.`ApprovalType`=lt.`DiscountApproveBy` ");
            if (isSuperAuthority != 1)
            sb.Append(" AND da.`EmployeeID`='" + HttpContext.Current.Session["ID"].ToString() + "' ");
            sb.Append(" INNER JOIN `patient_master` pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append(" INNER JOIN employee_master em ON em.`EmployeeID`=lt.`UserID` ORDER BY lt.BillNo  ");
        }
        else
        {
            sb.Append(" SELECT 'IPD' AS 'Type',pm.`PatientID` 'UHID',pmh.`BillNo`,DATE_FORMAT(pmh.`BillDate`,'%d-%b-%Y')'BillDate',CONCAT(pm.`Title`,' ',pm.`PName`)'PName', ");
            sb.Append(" pm.`Age`,pm.`Mobile`,SUM(ltd.`Rate`*ltd.`Quantity`) `GrossAmount`,(SUM(ltd.`DiscAmt`)+pmh.`DiscountOnBill`) 'DiscAmt',(SUM(ltd.`Rate`*ltd.`Quantity`)-(SUM(ltd.`DiscAmt`)+pmh.`DiscountOnBill`))`NetAmount`,CONCAT(em.`Title`,' ',em.`Name`)'DiscUser', ");
            sb.Append(" pmh.finalDiscReason  'DiscountReason',pmh.finalDiscountApproval 'DiscountApproveBy',IF(pmh.discountApprovalStatus=0,'Pending',IF(pmh.discountApprovalStatus=1,'Approved','UnApproved'))'Status' ");
            sb.Append(" ,IF(pmh.`discountApprovalStatus`=0,'',(SELECT CONCAT(e.`Title`,' ',e.`Name`) FROM employee_master e WHERE e.`EmployeeID`=pmh.discountApprovalStatusUpdatedBy ))'UpdatedBy',IFNULL(pmh.discountApprovalRemarks,'') 'Remarks' ");
            sb.Append(" FROM `patient_medical_history` pmh  ");
            sb.Append(" INNER JOIN f_discountapproval da ON da.`ApprovalType`=pmh.`finalDiscountApproval` AND pmh.`BillNo`<>'' ");
            sb.Append(" AND pmh.`BillDate`>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND pmh.`BillDate`<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (!String.IsNullOrEmpty(uhid))
                sb.Append(" AND pmh.`PatientID`='" + uhid.Trim() + "' ");
            if (!String.IsNullOrEmpty(billNo))
                sb.Append(" pmh.`BillNo`='" + billNo.Trim() + "' ");
            sb.Append(" AND pmh.discountApprovalStatus=" + Util.GetInt(status) + " ");
            if (isSuperAuthority != 1)
            sb.Append(" AND da.`EmployeeID`='" + HttpContext.Current.Session["ID"].ToString() + "' ");
            sb.Append(" INNER JOIN `f_ledgertnxdetail` ltd ON ltd.`TransactionID`=pmh.`TransactionID` AND ltd.`IsVerified`=1 AND ltd.`IsPackage`=0 ");
            sb.Append(" INNER JOIN `patient_master` pm ON pm.`PatientID`=pmh.`PatientID` ");
            sb.Append(" INNER JOIN employee_master em ON em.`EmployeeID`=pmh.`UserID` GROUP BY pmh.`TransactionID`  HAVING DiscAmt>0 ORDER BY pmh.`BillNo` ");

        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Discount Approve/Un Approve Report";
            HttpContext.Current.Session["Period"] = "From Date " + fromDate + " To " + toDate;
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

        }
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string ApproveUnapprove(List<dataDisc> dataList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string sqlCommand = string.Empty;
            foreach (var item in dataList)
            {

                if (item.dataType.ToUpper().Trim() == "OPD")
                    sqlCommand = "UPDATE `f_ledgertransaction` lt SET  lt.discountApprovalStatus =@status,lt.discountApprovalStatusUpdatedBy =@updatedBy,lt.discountApprovalRemarks=@remarks WHERE lt.`BillNo`=@billNo";
                else
                    sqlCommand = "UPDATE patient_medical_history adj SET adj.`discountApprovalStatus`=@status,adj.`discountApprovalStatusUpdatedBy`=@updatedBy,adj.discountApprovalRemarks=@remarks WHERE adj.`BillNo`=@billNo";
                ExcuteCMD cmd = new ExcuteCMD();
                cmd.DML(tnx, sqlCommand, CommandType.Text, new
                {
                    status = Util.GetInt(item.updateType),
                    updatedBy = HttpContext.Current.Session["ID"].ToString(),
                    billNo = Util.GetString(item.billNo),
                    remarks=item.remark

                });

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

}
public class dataDisc
{
    public string dataType { get; set; }
    public string billNo { get; set; }
    public string updateType { get; set; }
    public string remark { get; set; }
}