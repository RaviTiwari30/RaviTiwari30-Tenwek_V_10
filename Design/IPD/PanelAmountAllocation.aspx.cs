using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections.Generic;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Web.Services;
using System.Text;




public partial class Design_IPD_PanelAmountAllocation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //if (Resources.Resource.skipPanelAllocation == "1")
            //{
            //    string Msg = "This Process in not applicable on your Site...";
            //    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            //}

            if (Resources.Resource.AllowFiananceIntegration == "2")//
            {
                string TransNo = (StockReports.ExecuteScalar(" Select TransNo FROM patient_medical_history WHERE  TransactionID = '" + Request.QueryString["TransactionID"].ToString() + "'"));

                if (TransNo == "")
                { TransNo = Request.QueryString["TransactionID"].ToString(); }
                if (AllLoadData_IPD.CheckAllocationPostToFinance(TransNo) > 0)
                {
                    string Msga = "Patient's Final Bill Already Posted To Finance...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msga);
                }
            }
            lblTID.Text = Util.GetString(Request.QueryString["TransactionID"]);
            string panelID = Util.GetString(StockReports.ExecuteScalar(" Select PanelID FROM patient_medical_history WHERE  TransactionID = '" + lblTID.Text + "'"));//AllLoadData_IPD.getPatientPanelID(lblTID.Text, null);
            if (panelID == "1")
            {
                string Msg = "This Form Is Not For CASH Patient...";
                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            }
            ViewState["PanelAllType"] = Request.QueryString["AdmissionType"].ToString();
            if (Util.GetString(ViewState["PanelAllType"]) != "OPD_Al")
            {
                BindPanels(lblTID.Text);
            }
            else
            {
                All_LoadData.BindPanelOPD(ddlPanel);
                ddlPanel.Items.Remove(ddlPanel.Items.FindByValue(Resources.Resource.DefaultPanelID));
                if(panelID!="")
                ddlPanel.SelectedValue = panelID;
            }
        }
    }




    public class allocationDetails
    {
        public int panelID { get; set; }
        public string transactionID { get; set; }
        public decimal amount { get; set; }
        public string allocationType { get; set; }
        public string userID { get; set; }

    }



    private void BindPanels(string transactionID)
    {

        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" SELECT TRIM(Company_Name) AS Company_Name,p.PanelID,ReferenceCode,ReferenceCodeOPD,IsCash,applyCreditLimit,CreditLimitType  ");
        sqlCMD.Append(" FROM f_panel_master pm ");
        sqlCMD.Append(" INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID      ");
        sqlCMD.Append(" INNER JOIN f_IpdPanelApproval p ON p.PanelID=pm.PanelID       ");
        sqlCMD.Append(" WHERE  pm.Isactive=1 ");
        sqlCMD.Append(" AND pm.DateTo>NOW() ");
        sqlCMD.Append(" AND  fcp.CentreID=@centerID ");
        sqlCMD.Append(" AND fcp.isActive=1 ");
        sqlCMD.Append(" AND p.TransactionID=@transactionID GROUP BY p.PanelID ORDER BY Company_Name ");

        ExcuteCMD excuteCMD = new ExcuteCMD();

        //var s = excuteCMD.GetRowQuery(sqlCMD.ToString(),new
        //{
        //    centerID = HttpContext.Current.Session["CentreID"].ToString(),
        //    transactionID = transactionID
        //});


        var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            centerID = HttpContext.Current.Session["CentreID"].ToString(),
            transactionID = transactionID

        });

        ddlPanel.DataSource = dt;
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataBind();

    }




    [WebMethod(EnableSession = true)]
    public static string SavePanelAmountAllocationDetails(List<allocationDetails> panelAllocationDetails, decimal totalNetBillAmount)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();

        var userID = HttpContext.Current.Session["ID"].ToString();

        try
        {
            decimal BillAmount = Util.round(Util.GetDecimal(StockReports.ExecuteScalar("SELECT SUM(amount)-(SELECT IFNULL(DiscountOnBill,0) FROM patient_medical_history WHERE TransactionID='" + panelAllocationDetails[0].transactionID + "') FROM f_ledgertnxdetail WHERE TransactionID='" + panelAllocationDetails[0].transactionID + "' AND IsVerified=1 AND IsPackage=0 group by TransactionID")));//f_ipdadjustment
            //var IsInvoiceGenerated = StockReports.ExecuteScalar("SELECT COUNT(*)IsInvoiceGenerated FROM  f_dispatch f WHERE f.TransactionID='" + panelAllocationDetails[0].transactionID + "'");
            //if (Util.GetInt(IsInvoiceGenerated) > 0)
            //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Sorry Panel Invoive Generated." });

            var isShareAllocationDone = StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_paymentallocation p WHERE p.TransactionID='" + panelAllocationDetails[0].transactionID + "' AND p.IsActive=1");

            if (Util.GetInt(isShareAllocationDone) > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Sorry Doctor Allocation Done." });


            decimal totalAllocationAmount = 0;
            panelAllocationDetails.ForEach(i =>
            {
                if (i.allocationType == "DR")
                    i.amount = (Util.GetDecimal(i.amount) * -1);

                totalAllocationAmount = i.amount + totalAllocationAmount;
            });



            var totalAllocatedAmount = Util.GetFloat(excuteCMD.ExecuteScalar("SELECT SUM(am.Amount)allocatedAmount FROM panel_amountallocation am INNER JOIN f_panel_master pm  ON pm.PanelID=am.PanelID WHERE am.TransactionID=@transactionID", new
            {
                transactionID = panelAllocationDetails[0].transactionID
            }));


            totalAllocationAmount = (totalAllocationAmount + Util.GetDecimal(totalAllocatedAmount));

            if (totalAllocationAmount < 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Invalid Allocation Amount." });

            
            if (Util.round(Util.GetDecimal(totalAllocationAmount)) > Util.round(Util.GetDecimal(BillAmount)))
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Allocation amount is greater then Bill Amount." });



            var sqlCMD = "INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (@panelID,@transactionID,@amount,@userID,@allocationType)";

            //var financeSqlCmd = "CALL ess_AllocationAmountInFinance(@transactionID,@panelName,@panelID,@adjustmentAmount,@allocationAmount,@allocationDate,@approvalDate,@userName,@userID)";


            for (int i = 0; i < panelAllocationDetails.Count; i++)
            {
                var ad = panelAllocationDetails[i];
                ad.userID = userID;
                excuteCMD.DML(tnx, sqlCMD.ToString(), CommandType.Text, ad);


                //var _temp = excuteCMD.GetDataTable("SELECT IFNULL(SUM(ip.PanelApprovedAmt),0)PanelApprovedAmt,ip.PanelApprovalDate ApprovalDate ,(SELECT pm.Company_Name FROM f_panel_master pm WHERE pm.PanelID=@panelID)PanelName FROM f_ipdpanelapproval ip WHERE ip.TransactionID=@transactionID AND ip.PanelID=@panelID", CommandType.Text, new
                //{
                //    panelID = panelAllocationDetails[i].panelID,
                //    transactionID = panelAllocationDetails[i].transactionID,
                //});


                //if (Resources.Resource.AllowFiananceIntegration == "1")
                //{
                //    excuteCMD.DML(financeSqlCmd, CommandType.Text, new
                //    {
                //        transactionID = panelAllocationDetails[i].transactionID,
                //        panelID = panelAllocationDetails[i].panelID,
                //        panelName = _temp.Rows[0]["PanelName"].ToString(),
                //        adjustmentAmount = _temp.Rows[0]["PanelApprovedAmt"].ToString(),
                //        allocationAmount = panelAllocationDetails[i].amount,
                //        allocationDate = System.DateTime.Now.ToString("yyyy-MM-dd"),
                //        approvalDate = Util.GetDateTime(_temp.Rows[0]["ApprovalDate"].ToString()).ToString("yyyy-MM-dd"),
                //        userName = HttpContext.Current.Session["EmployeeName"].ToString(),
                //        userID = HttpContext.Current.Session["ID"].ToString(),
                //    });
                //}

            }


            tnx.Commit();
            
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
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
    public static string GetPatientPanelAmountAllocationDetails(string transactionID)
    {

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable("SELECT pm.PanelID panelID,pm.Company_Name panelName,SUM(am.Amount)allocatedAmount,am.IsMerge IsSmartCard,IFNULL(CONCAT(em.`Title`,' ',em.`NAME`),'')EmpName FROM panel_amountallocation am INNER JOIN f_panel_master pm  ON pm.PanelID=am.PanelID LEFT JOIN employee_master em ON em.`EmployeeID`=am.EntryBy WHERE am.TransactionID=@transactionID GROUP BY pm.PanelID", CommandType.Text, new
        {
            transactionID = transactionID
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);


    }





}