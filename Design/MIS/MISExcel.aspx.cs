using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using System.IO;
using ClosedXML.Excel;

public partial class Design_MIS_MISExcel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucDateFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucDateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

        }
        ucDateFrom.Attributes.Add("readOnly", "true");
        ucDateTo.Attributes.Add("readOnly", "true");
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        string url = "";
        if (rblReportType.SelectedItem.Value == "1")
            url = Server.MapPath("~/ExcelData/Transactional.xlsx");
        else
            url = Server.MapPath("~/ExcelData/Clinical.xlsx");

        if (File.Exists(url))
        {
            try
            {
                StringBuilder sbQry = new StringBuilder();
                if (rblReportType.SelectedItem.Value == "1")
                {
                    sbQry.Append(" SELECT t.*,pnl.Company_Name,SM.Name SubGroupName,CM.Name GroupName,Pm.PName,pm.Mobile,t2.ReceiptNo,t.centreID,t.centreName     ");
                    sbQry.Append(" FROM (");
                    sbQry.Append(" SELECT t.DoctorID,t.doctor,t.LedgerTransactionNo,t.Amount,t.Rate,t.Quantity,(t.Rate*t.Quantity)GrossAmt,");
                    sbQry.Append(" t.DiscountPercentage, ((t.Rate*t.Quantity)*t.DiscountPercentage)/100 DisAmt,IF(t.IsPackage = 0,'No','Yes')Package,itemname,");
                    sbQry.Append(" pmh.PanelID,t.TransactionID,t.Date,t.BillNo,IF(pmh.Type = 'IPD','IPD','OPD') TnxType,typeofTnx,t.GrossAmount BillAmt,t.ItemID,t.PatientID,");
                    sbQry.Append(" SubCategoryID,t.centreID,t.centreName, pmh.TotalBilledAmt     FROM ( ");
                    sbQry.Append(" SELECT lt.typeofTnx,SubCategoryID,ltd.itemname,ltd.DoctorID,(SELECT CONCAT(title,' ',NAME) FROM doctor_master WHERE DoctorID=ltd.DoctorID)Doctor,ltd.LedgerTransactionNo,ltd.Amount,");
                    sbQry.Append(" ltd.Rate,ltd.Quantity,ltd.DiscountPercentage, LTd.IsPackage,LT.Date,LT.BillNo,ltd.ItemID,lt.GrossAmount ,lt.TransactionID,lt.PatientID,");
                    sbQry.Append(" ltd.EntryDate,cmt.centreID,cmt.centreName  FROM f_ledgertransaction lt INNER JOIN f_ledgertnxdetail ltd ");
                    sbQry.Append(" ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo  INNER JOIN center_master cmt ON cmt.centreID= lt.`CentreID`");
                    sbQry.Append(" WHERE (lt.Date  >= '" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "') AND (lt.Date  <= '" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "') AND LT.IsCancel = 0 AND LTD.IsFree = 0 AND LTD.IsVerified IN (0,1)");
                    sbQry.Append(" )t ");
                    sbQry.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = t.TransactionID ");
                    sbQry.Append(" WHERE IF(pmh.Type <> 'IPD',t.Date,t.EntryDate) >= DATE('" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "') AND IF(pmh.Type <> 'IPD',T.Date,t.EntryDate) <= DATE('" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "') ");
                    sbQry.Append(" )t ");
                    sbQry.Append(" INNER JOIN f_subcategorymaster SM ON SM.SubCategoryID = t.SubCategoryID ");
                    sbQry.Append(" INNER JOIN f_categorymaster CM ON SM.CategoryID = CM.CategoryID ");
                    sbQry.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID = t.PanelID ");
                    sbQry.Append(" INNER JOIN patient_master PM ON pm.PatientID = t.PatientID ");
                    sbQry.Append(" LEFT JOIN ( ");
                    sbQry.Append(" SELECT ReceiptNo,AsainstLedgerTnxNo FROM f_reciept WHERE AsainstLedgerTnxNo <> '' ");
                    sbQry.Append(" AND DATE BETWEEN '" + Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd") + "'");
                    sbQry.Append(" AND '" + Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd") + "' ");
                    sbQry.Append(" ) t2 ON T.LedgerTransactionNo = t2.AsainstLedgerTnxNo  ORDER BY t.date ");
                }
                else
                {
                    //Add Query for Patient Clinical data
                    sbQry.Clear();
                    sbQry.Append(" ");
                }

                DataTable dtExcel = StockReports.GetDataTable(sbQry.ToString());

                if (dtExcel.Rows.Count > 0)
                {
                    XLWorkbook wb = new XLWorkbook(url);
                    StringBuilder sb = new StringBuilder();

                    var sheet = wb.Worksheet("RowData");
                    
                    var source = sheet.Cell(1, 1).InsertTable(dtExcel, true);
                    Response.Clear();
                    Response.Buffer = true;
                    Response.Charset = "";
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;filename=MISExcel.xlsx");
                    using (MemoryStream MyMemoryStream = new MemoryStream())
                    {
                        wb.SaveAs(MyMemoryStream);
                        MyMemoryStream.WriteTo(Response.OutputStream);
                        Response.Flush();
                        //Response.End();
                    }
                }
                else
                    lblMsg.Text = "Record Not Found";
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('" + ex.Message + "');", true);
            }
        }
    }
}