using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
public partial class Design_Lab_SampleTransferReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            if (!IsPostBack)
            {
                FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            }
            FrmDate.Attributes.Add("readOnly", "true");
            ToDate.Attributes.Add("readOnly", "true");
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IFNULL(sl.DipatchCode,'')DipatchCode,IFNULL(sl.CourierBoy,'')CourierBoy,pm.PatientID,CONCAT(pm.Title,' ',pm.PName)Pname,lt.CurrentAge,im.Name Testname,plo.BarcodeNo, ");
        sb.Append("cm.CentreName 'Registration Center', cm1.CentreName 'From Center', cm2.CentreName 'To Center', ");
        sb.Append("IFNULL(DATE_FORMAT(sl.EntryDate,'%d-%b-%y %h:%i %p'),'') 'Transfer Date', ");
        sb.Append("IFNULL((SELECT CONCAT(em.Title,'',em.Name) FROM employee_master em WHERE em.EmployeeID=sl.EntryBy),'') 'Transfer By', ");
        sb.Append("IFNULL(DATE_FORMAT(sl.DispatchDate,'%d-%b-%y %h:%i %p'),'') 'Dispatch Date', ");
        sb.Append("IFNULL((SELECT CONCAT(em.Title,'',em.Name) FROM employee_master em WHERE em.EmployeeID=sl.DispatchBy),'') 'Dispatch By',lt.GrossAmount,lt.DiscountOnTotal,lt.NetAmount ");
        sb.Append("FROM patient_labinvestigation_opd plo  ");
        sb.Append("INNER JOIN sample_logistic sl ON sl.Test_ID=plo.Test_ID AND sl.isActive=1 ");
        sb.Append("INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=plo.LedgerTransactionNo ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID = plo.PatientID ");
        sb.Append("INNER JOIN investigation_master im ON im.Investigation_Id = plo.Investigation_ID ");
        sb.Append("INNER JOIN center_master cm ON cm.CentreID = plo.CentreID ");
        sb.Append("INNER JOIN center_master cm1 ON cm1.CentreID = sl.FromCentreID ");
        sb.Append("INNER JOIN center_master cm2 ON cm2.CentreID = sl.ToCentreID ");
        sb.Append("WHERE lt.IsCancel=0 AND plo.isTransfer=1 ");
        if (rdbsearchby.SelectedValue == "F")
            sb.Append("AND sl.FromCentreID IN (" + Centre + ") ");
        else
            sb.Append("AND sl.ToCentreID IN (" + Centre + ") ");
        sb.Append("AND sl.DispatchDate >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append("AND sl.DispatchDate <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Sample Transfer Report";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/common/ExportToExcel.aspx');", true);
            lblMsg.Text = dt.Rows.Count + " Records Found ";
        }
        else
        {
            lblMsg.Text = "Record Not found";
        }
    }
}