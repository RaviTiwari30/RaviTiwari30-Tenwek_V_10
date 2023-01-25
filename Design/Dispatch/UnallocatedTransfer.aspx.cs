using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Services;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Dispatch_UnallocatedTransfer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        BindCentre();
    }
    [WebMethod]
    public static string GetPanelAccountVoucher(string panelID, string centreId)
    {
        try
        {
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT CONCAT(pt.ID,'#',Round(pt.GL_AMT_BS,2),'#',Round((pt.GL_AMT_BS-pt.SettledAmount),2))ID,CONCAT(pt.GL_INSTRMNT_NO,'-',pt.BANK_NAME)`Text` FROM ess.panel$onaccount pt WHERE pt.IsCancel=0 AND (pt.GL_AMT_BS-pt.SettledAmount)>0 AND pt.FIELD_VAL=" + panelID + " AND pt.GL_ORG_ID=" + centreId + "");
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = dt });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Error" });
        }
    }
    [WebMethod]
    public static string TransferAmount(string ID, string ToPanel, decimal Amount, string CentreID, int type)
    {
        //ALTER TABLE ess.panel$onaccount ADD COLUMN EntryBy VARCHAR(20),ADD COLUMN IsTransfer INT DEFAULT 0,ADD COLUMN FromID INT DEFAULT 0,ADD COLUMN updatedBy VARCHAR(20),ADD COLUMN updateddate DATETIME;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        string userID = HttpContext.Current.Session["ID"].ToString();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            if (Util.GetInt(ID) > 0)
            {
                string remaningAmountAfterSettled = StockReports.ExecuteScalar("SELECT pt.GL_AMT_BS-(pt.SettledAmount+(" + Util.GetDecimal(Amount) + ")) FROM  ess.panel$onaccount pt WHERE pt.IsCancel=0 AND pt.ID=" + ID);
                if (Util.GetDecimal(remaningAmountAfterSettled) < 0)
                {
                    tranX.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Invalid Amount." + remaningAmountAfterSettled });
                }
                else
                {
                    excuteCMD.DML(tranX, "UPDATE ess.panel$onaccount pt SET  pt.SettledAmount=(pt.SettledAmount+@amount),updatedBy=@userID,updateddate=Now() WHERE pt.ID=@id", CommandType.Text, new
                    {
                        id = ID,
                        userID = userID,
                        amount = Amount
                    });

                    //excuteCMD.DML(tranX, "INSERT INTO ess.panel$onaccount (DOC_TXN_ID_DISP,DOC_TXN_ID,GL_AMT_BS,FIELD_VAL,BANK_NAME,VOUCHER_DATE,GL_INSTRMNT_NO, " +
                    //" GL_INSTRMNT_DT,INSTRUMNT_TYPE,CURR,CURR_CONV,EntryBy,IsTransfer,FromID,ParentID " +
                    //" )  " +
                    //" (SELECT DOC_TXN_ID_DISP,DOC_TXN_ID,@settledAmount,@ToPanel,BANK_NAME,VOUCHER_DATE,GL_INSTRMNT_NO, " +
                    //" GL_INSTRMNT_DT,INSTRUMNT_TYPE,CURR,CURR_CONV,@userID,1,ID,if(ParentID=0,ID,ParentID) FROM ess.panel$onaccount WHERE ID=@ID)", CommandType.Text, new
                    //{
                    //    ToPanel = ToPanel,
                    //    userID = userID,
                    //    settledAmount = Amount,
                    //    ID = ID
                    //});

                    int transferID = 0;
                    if (type == 0)
                    {
                        transferID = Util.GetInt(excuteCMD.ExecuteScalar(tranX, "CALL insert_panel_unallocationTransfer(@ID,@settledAmount,@ToPanel,@userID,@CentreID) ", CommandType.Text, new
                        {
                            ToPanel = ToPanel,
                            userID = userID,
                            settledAmount = Amount,
                            ID = ID,
                            CentreID = CentreID

                        }));
                    }
                    else
                    {
                        ToPanel = "0";
                    }

                    excuteCMD.DML(tranX, " call insert_panel_unallocation_log(@ID,@settledAmount,@ToPanel,@userID,@transferId,@availType,@receiptNo,@invoiceNo,@CentreID,@IsReversal) ", CommandType.Text, new
                   {
                       ToPanel = ToPanel,
                       userID = userID,
                       settledAmount = Amount,
                       ID = ID,
                       transferId = transferID,
                       availType = "PAN",
                       receiptNo = "",
                       invoiceNo = "",
                       CentreID = CentreID,
                       IsReversal = type
                   });

                }
                tranX.Commit();
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Amount Transfer Successfully." });
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public void BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Centre(Session["ID"].ToString());
        ddlCentre.DataSource = dt;
        ddlCentre.DataTextField = "CentreName";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
        ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(Session["CentreID"].ToString()));
    }
    [WebMethod]
    public static string bindPanel(string centreId)
    {
        try
        {
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable("SELECT TRIM(Company_Name) AS Company_Name,pm.PanelID FROM f_panel_master pm INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID WHERE pm.Isactive=1 AND fcp.CentreID='" + centreId + "' AND fcp.isActive=1 AND pm.DateTo>NOW() ORDER BY Company_Name");
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = dt });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Error" });
        }
    }
}