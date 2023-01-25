using System;
using System.Data;
using System.Web.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web;
public partial class Design_Dispatch_InvoiceSettlement : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.BindBank(ddlBank);
            dtEntryDate.EndDate = System.DateTime.Now;
        }
        txtRefDate.Attributes.Add("readOnly", "true");
    }

    [WebMethod]
    public static string bindBank()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.dtBankMaster());
    }
  
    [WebMethod]
    public static string GetPanelAccountVoucher(string panelID)
    {
        DataTable dt = new DataTable();
        //if (Resources.Resource.AllowFiananceIntegration == "1")
        //{
        var centre = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        dt = StockReports.GetDataTable("SELECT pt.ID,CONCAT(pt.GL_INSTRMNT_NO,'-',pt.BANK_NAME,'(',(pt.GL_AMT_BS-pt.SettledAmount),')')`Text` FROM ess.panel$onaccount pt WHERE pt.IsCancel=0 AND (pt.GL_AMT_BS-pt.SettledAmount)>0 AND pt.FIELD_VAL=" + panelID + " AND pt.GL_ORG_ID=" + centre + "");
        //}

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
      
    [WebMethod]
    public static string GetAccountVoucherDetails(string VoucherID)
    {
        DataTable dt = new DataTable();
       // if (Resources.Resource.AllowFiananceIntegration == "1")
        //{
            dt = StockReports.GetDataTable("SELECT CONCAT('Bank Name : ',IFNULL(pt.BANK_NAME,''),',  Currency : ',IFNULL(pt.CURR,''),',  Currency Conversion : ',IFNULL(pt.CURR_CONV,''),',Amount : ',Round((pt.GL_AMT_BS-pt.SettledAmount),4),',  Ref. No. : ',IFNULL(pt.DOC_TXN_ID_DISP,''),', Payment Mode : ',IFNULL(p.PaymentMode,'')) as VoucherDetail,IFNULL(pt.GL_INSTRMNT_NO,'') AS VoucherNo ,IFNULL(pt.BANK_NAME,'') AS BankName,IFNULL(pt.CURR,'') AS Currency,IFNULL(pt.CURR_CONV,'') AS CurrencyConversion ,IFNULL(pt.DOC_TXN_ID_DISP,'') AS RefNo,IFNULL(pt.INSTRUMNT_TYPE,'') AS PaymentMode  FROM ess.panel$onaccount pt INNER JOIN PaymentMode_master p ON p.PaymentModeId=pt.INSTRUMNT_TYPE WHERE pt.IsCancel=0 AND (pt.GL_AMT_BS-pt.SettledAmount)>0 AND pt.ID='" + VoucherID + "'");
        //}

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string GetPaymentMode()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT p.PaymentModeID,p.PaymentMode FROM paymentmode_master p WHERE p.PaymentModeId IN(2,3,6,1) AND p.Active=1 ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable("SELECT pm.Company_Name 'PanelName',DATE_FORMAT(pa.VOUCHER_DATE,'%d-%b-%Y')PaymentDate,pa.GL_INSTRMNT_NO 'RefNo', "+
                       " IF(pa.IsTransfer=0,pa.GL_AMT_BS,0) 'ReceivedAmount(unallocated)',if(pa.IsTransfer=1,(pa.GL_AMT_BS-pa.SettledAmount),0)Transfer , "+
                       " pa.SettledAmount SettledAmount,  "+
                       " (pa.GL_AMT_BS-pa.SettledAmount)Remaining, "+
                        " if(pa.FromID is not null,(select pmt.Company_name  "+
                        " from ess.panel$onaccount pt inner join f_panel_master pmt on pmt.PanelID=pt.FIELD_VAL where pt.ID = pa.FromID),'') FromTransfer_Panel "+
                       " FROM ess.panel$onaccount pa  "+
                       " INNER JOIN f_panel_master pm ON pm.PanelID=pa.FIELD_VAL WHERE pa.IsCancel=0  "+
                       " Order By pm.Company_Name,date(pa.VOUCHER_DATE);");
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "UnAllocated Amount Report";
            Session["Period"] = "As On" + DateTime.Now.ToString("dd-MM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
    }
}