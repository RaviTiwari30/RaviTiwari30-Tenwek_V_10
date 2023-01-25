using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;



public partial class Design_Finance_ManualFinanceTransfer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
         //   txtToDate.Text = DateTime.Now.AddDays(-1).ToString("dd-MMM-yyyy");
            CalendarExtender1.EndDate = System.DateTime.Now;//.AddDays(-1);
            CalendarExtender2.EndDate = System.DateTime.Now;//.AddDays(-1);
            BindCentre1();
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");


    }

    private void BindCentre1()
    {
        DataTable dt = All_LoadData.dtbind_Center();

        ddlCentre.DataSource = dt;
        ddlCentre.DataTextField = "CentreName";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
    }

    [WebMethod]
    public static string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public static string TransferData(int type, string module, string fromDate, string toDate, string centreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        StringBuilder sqlCMD;

        try
        {
            var startDate = Util.GetDateTime(fromDate);
            var endDate = Util.GetDateTime(toDate);

            var totalDays = (endDate - startDate).TotalDays;
            if (totalDays < 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Invalid Date Range.", });
            }
            DataTable count = new DataTable();
            if (type == 1)
            {
                count = StockReports.GetDataTable("SELECT GROUP_CONCAT(DISTINCT ltd.ItemName)ItemName,COUNT(*) itemcount FROM f_ledgertnxdetail ltd " +
                               " INNER  JOIN  patient_medical_history p ON p.`TransactionID`=ltd.`TransactionID` left JOIN demo_his_mapping_master dhm ON dhm.HIS_ItemID=ltd.ItemID AND dhm.IsActive=1 " +
                               " WHERE dhm.ID IS NULL AND p.BillDate >='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND p.BillDate <='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59'");
            }
            else if (type == 3)
            {
                count = StockReports.GetDataTable("SELECT GROUP_CONCAT(DISTINCT st.ItemName)ItemName,COUNT(*) itemcount " +
                        " FROM f_Stock st LEFT JOIN demo_his_mapping_master dhm ON st.`ItemID`=dhm.`HIS_ItemID`  AND dhm.IsActive=1 " +
                        " WHERE dhm.`ID` IS NULL and st.`PostDate`>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND st.`PostDate`<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59'");
            } 
            
            if (count.Rows.Count > 0)
            {
                if (Util.GetInt(count.Rows[0]["itemcount"].ToString()) > 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = count.Rows[0]["ItemName"].ToString(), });
                }
            }
            sqlCMD = new StringBuilder("INSERT INTO ess_finance_manual_transferdetails (`TYPE`,ModuleName,FromDate,ToDate,UserID,centreID)VALUES(@type,@moduleName,@fromDate,@toDate,@userID,@centreID)");
            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                type = type,
                moduleName = Util.GetString(module),
                fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
                toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
                userID = (HttpContext.Current.Session["ID"]).ToString(),
                centreID = centreID
            });
            if (type == 1)
                sqlCMD = new StringBuilder("CALL finance_Push_Revenue_Manual(@fromDate,@toDate,@centreID)");
            else if (type == 2)
                sqlCMD = new StringBuilder("CALL finance_Push_Collection_Manual(@fromDate,@toDate,@centreID)");
            else if (type == 3)
                sqlCMD = new StringBuilder("CALL finance_Push_Purchase_Manual(@fromDate,@toDate,@centreID)");
            else if (type == 4)
                sqlCMD = new StringBuilder("CALL finance_Push_Panel_Revenue(@fromDate,@toDate,@centreID)");

            excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, new
            {
                fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
                toDate = Util.GetDateTime(toDate).ToString("yyyy-MM-dd"),
                centreID = centreID
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string GetLastTransferDate(int type, string moduleName, int centreID)
    {
        try
        {
            var lastDate = GetLastTransferDateModuleWise(type, moduleName, centreID);
            if (lastDate.ToString("dd-MMM-yyyy") == "01-Jan-0001")
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, lastDate = Util.GetDateTime(System.DateTime.Now).AddDays(-1).ToString("dd-MMM-yyyy"), response = "", isFirstTimeTransfer = true });

            var different = (Util.GetDateTime(System.DateTime.Now.ToString("dd-MMM-yyyy")).AddDays(-1) - lastDate).TotalDays;

            if (different == 0)
               return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, lastDate = "", response = "Transfer Completed.", isFirstTimeTransfer = false });
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, lastDate = Util.GetDateTime(lastDate).AddDays(1).ToString("dd-MMM-yyyy"), response = "", isFirstTimeTransfer = false });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, lastDate = "", response = "Transfer Failed.", isFirstTimeTransfer = false });
        }
    }


    public static DateTime GetLastTransferDateModuleWise(int type, string moduleName, int centreID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();

        var lastDate = excuteCMD.ExecuteScalar("SELECT  s.ToDate  FROM ess_finance_manual_transferdetails s WHERE s.Type=@type AND s.ModuleName=@moduleName and s.centreID=@centreID ORDER BY s.ID DESC LIMIT 1", new
        {
            type = type,
            moduleName = moduleName,
            centreID = centreID
        });

        return Util.GetDateTime(lastDate);
    }

    



    public   void btnBeforeTransfer_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        var startDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");
        var endDate = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");

        StringBuilder sb = new StringBuilder();
        string ReportName = string.Empty;

        if (ddlTransfer.SelectedItem.Value == "1")
        {
            sb.Append("CALL finance_BeforePushReport_Revenue_Manual('" + startDate + "','" + endDate + "','" + ddlCentre.SelectedItem.Value + "')");

            ReportName = "Revenue Details";
            
        }
        else if (ddlTransfer.SelectedItem.Value == "2")
        {
            sb.Append("CALL finance_BeforePush_Collection_Manual('" + startDate + "','" + endDate + "','" + ddlCentre.SelectedItem.Value + "')");
            ReportName = "Payment Collection";

        }
        else if (ddlTransfer.SelectedItem.Value == "4")
        {
            sb.Append("CALL finance_BeforePush_Panel_Revenue('" + startDate + "','" + endDate + "','" + ddlCentre.SelectedItem.Value + "')");
            ReportName = "Panel Allocation";
        }
        else if (ddlTransfer.SelectedItem.Value == "3")
        {
            sb.Append("CALL finance_BeforePush_Purchase_Manual('" + startDate + "','" + endDate + "','" + ddlCentre.SelectedItem.Value + "')");
            ReportName = "Inventory Details";

        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = ReportName;
            Session["Period"] = "From Data:" + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " ToDate:" + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
        }

        else { lblMsg.Text = "No Records Founds !!!"; }
    }
}