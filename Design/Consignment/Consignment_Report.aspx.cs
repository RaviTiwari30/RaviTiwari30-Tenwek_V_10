using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Consignment_Consignment_Report : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindVendor();
            BindCentre();
            BindCategory();
            BindSubCategory();
            BindDepartment();
        }

    }

    private void BindDepartment()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ledgerNumber,ledgerName FROM f_ledgermaster lm INNER JOIN f_rolemaster rm ON lm.ledgerNumber=rm.DeptLedgerNo WHERE lm.GroupID = 'DPT' AND lm.IsCurrent=1 AND rm.Active=1  order by ledgerName ");

        if (dt.Rows.Count > 0)
        {
            ddlDpt.DataSource = dt;
            ddlDpt.DataTextField = "ledgerName";
            ddlDpt.DataValueField = "ledgerNumber";
            ddlDpt.DataBind();
            ddlDpt.Items.Insert(0, "Select");
        }
    }


    public void BindVendor()
    {

        string sql = "select LedgerNumber,LedgerName from f_ledgermaster where groupID='VEN' and IsCurrent=1 order by LedgerName";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt.Rows.Count > 0)
        {
            ddlVendor.DataSource = dt;
            ddlVendor.DataTextField = "LedgerName";
            ddlVendor.DataValueField = "LedgerNumber";
            ddlVendor.DataBind();

            ddlVendor.Items.Insert(0, "Select");
        }
        else
        {
            ddlVendor.Items.Clear();
            ddlVendor.DataSource = null;
            ddlVendor.DataBind();
        }

    }
    public void BindCentre()
    {

        string sql = "select CentreID,CentreName from center_master Where IsActive=1 order by CentreName ";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt.Rows.Count > 0)
        {
            ddlCentre.DataSource = dt;
            ddlCentre.DataTextField = "CentreName";
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataBind();
            ddlCentre.Items.Insert(0, "Select");
        }
        else
        {
            ddlCentre.Items.Clear();
            ddlCentre.DataSource = null;
            ddlCentre.DataBind();
        }

    }

    public void BindCategory()
    {

        string sql = " SELECT cm.Name,cm.CategoryID,cf.ConfigID FROM f_categorymaster cm INNER JOIN f_configrelation cf ON cm.categoryid = cf.categoryid  Where cf.ConfigID=11 And Active=1 ORDER BY cm.Name  ";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt.Rows.Count > 0)
        {

            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("All", "0"));
        }
        else
        {
            ddlCategory.Items.Clear();
            ddlCategory.DataSource = null;
            ddlCategory.DataBind();
        }

    }
    public void BindSubCategory()
    {

        string categoryID = ddlCategory.SelectedItem.Value;

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT SubCategoryID,sm.Name FROM f_subcategorymaster sm INNER JOIN f_configrelation cf ON sm.categoryid = cf.categoryid  WHERE cf.ConfigID=11 ");

        if (categoryID != "0")
            sb.Append(" and sm.CategoryID='" + categoryID + "' ");

        sb.Append("  ORDER BY sm.Name  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {

            ddlSubCategory.DataSource = dt;
            ddlSubCategory.DataTextField = "Name";
            ddlSubCategory.DataValueField = "SubCategoryID";
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Insert(0, "All");
        }
        else
        {
            ddlSubCategory.Items.Clear();
            ddlSubCategory.DataSource = null;
            ddlSubCategory.DataBind();
        }

    }

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubCategory();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        if (rbtnType.SelectedItem.Value == "0")
        {
            sb.Append("SELECT cm.CentreName, cd.ConsignmentNo,DATE_FORMAT(cd.EntDate,'%d-%b-%Y') ReceiveDate,em.Name ReceiveBy, cd.ChallanNo AS DeliveryNo, ");
            sb.Append(" if(cd.ChallanNo<>'',DATE_FORMAT(cd.ChallanDate,'%d-%b-%Y'),'') AS DeliveryDate ");
            sb.Append(" ,cd.BillNo AS InvoiceNo,if(cd.BillNo<>'',DATE_FORMAT(cd.BillDate,'%d-%b-%Y'),'') AS InvoiceDate,  ccm.Name Category,sc.Name SubCategory, ");
            sb.Append(" cd.ItemName,cd.BatchNumber,cd.Rate,cd.InititalCount Qty ,cd.UnitPrice AS PurchasePrice,(cd.InititalCount*cd.UnitPrice) AS TotalPurchasePrice, cd.DiscAmt,cd.DiscountPer, ");
            sb.Append(" cd.TaxPer AS PurTaxPer,cd.PurTaxAmt,(cd.MRP/cd.ConversionFactor)MRP,DATE_FORMAT(cd.StockDate,'%d-%b-%Y') StockDate,IF(cd.IsFree=0,'No','Yes')Free, ");
            sb.Append(" DATE_FORMAT(cd.MedExpiryDate,'%d-%b-%Y') MedExpiryDate,cd.ConversionFactor,cd.MarkUpPercent,cd.Currency,cd.CurrencyFactor, ");
            sb.Append(" lmd.LedgerName Department,lm.LedgerName SupplierName, cd.Naration ");
            sb.Append(" FROM Consignmentdetail cd ");
            sb.Append(" INNER JOIN center_master cm ON cm.CentreID= cd.CentreID ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=cd.ItemID ");
            sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=cd.VendorLedgerNo ");
            sb.Append(" INNER JOIN f_ledgermaster lmd ON lmd.LedgerNumber= cd.DeptLedgerNo ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
            sb.Append(" INNER JOIN f_categorymaster ccm ON ccm.CategoryID=sc.CategoryID ");
            sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=cd.UserID ");
            sb.Append(" WHERE cd.IsPost=1 ");


            sb.Append(" AND cd.EntDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'");
            sb.Append(" AND cd.EntDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'");
            if (ddlVendor.SelectedIndex > 0)
                sb.Append(" AND cd.VendorLedgerNo='" + ddlVendor.SelectedItem.Value.Split('#')[0] + "' ");

            if (txtConsignmentNo.Text.ToString() != string.Empty)
                sb.Append(" AND cd.ConsignmentNo='" + txtConsignmentNo.Text.ToString() + "' ");

            if (txtDeliveryNo.Text.ToString() != string.Empty)
                sb.Append(" AND cd.ChallanNo='" + txtDeliveryNo.Text.ToString() + "' ");

            if (ddlCentre.SelectedIndex > 0)
                sb.Append(" AND cd.CentreID='" + ddlCentre.SelectedItem.Value.Split('#')[0] + "' ");

            if (ddlCategory.SelectedIndex > 0)
                sb.Append(" AND sc.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0] + "' ");

            if (ddlSubCategory.SelectedIndex > 0)
                sb.Append(" AND sc.SubCategoryID='" + ddlSubCategory.SelectedItem.Value.Split('#')[0] + "' ");

            if (ddlDpt.SelectedIndex > 0)
                sb.Append(" AND DeptLedgerNo='" + ddlDpt.SelectedItem.Value + "' ");

            if (txtItemName.Text.ToString() != string.Empty)
                sb.Append(" AND cd.ItemName like '%" + txtItemName.Text.ToString() + "%' ");

            sb.Append(" ORDER BY cd.ConsignmentNo,ccm.Name,sc.Name,cd.ItemName ");

        }
        else if (rbtnType.SelectedItem.Value == "1")
        {
            sb.Append(" SELECT cm.CentreName,cr.ReturnNo,DATE_FORMAT(cr.ReturnDate,'%d-%b-%Y') AS ReturnDate,em.Name ReturnedBy, cd.ConsignmentNo,cd.ChallanNo AS DeliveryNo, ");
            sb.Append(" if(cd.ChallanNo<>'',DATE_FORMAT(cd.ChallanDate,'%d-%b-%Y'),'') AS DeliveryDate ");
            sb.Append(" ,cd.BillNo AS InvoiceNo,if(cd.BillNo<>'',DATE_FORMAT(cd.BillDate,'%d-%b-%Y'),'') AS InvoiceDate, ccm.Name Category,sc.Name SubCategory, ");
            sb.Append(" cd.ItemName,cr.BatchNo,cr.Rate,cr.ReturnQuantity Qty ,cr.UnitPrice, ");
            sb.Append(" (cr.ReturnQuantity*cr.UnitPrice) AS TotalReturnAmt, cd.DiscAmt,cd.DiscountPer, ");
            sb.Append(" cd.TaxPer AS PurTaxPer,cd.PurTaxAmt,(cr.MRP/cd.ConversionFactor)MRP,DATE_FORMAT(cd.StockDate,'%d-%b-%Y') StockDate,IF(cd.IsFree=0,'No','Yes')Free, ");
            sb.Append(" DATE_FORMAT(cd.MedExpiryDate,'%d-%b-%Y') MedExpiryDate,cd.ConversionFactor,cd.MarkUpPercent,cd.Currency,cd.CurrencyFactor, ");
            sb.Append(" lmd.LedgerName Department,lm.LedgerName SupplierName, cr.ReturnReason ");
            sb.Append(" FROM consignmentreturn cr  ");
            sb.Append(" INNER JOIN Consignmentdetail cd ON cd.ID=cr.ConsignmentID ");
            sb.Append(" INNER JOIN center_master cm ON cm.CentreID= cd.CentreID ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=cr.ItemID ");
            sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=cr.VendorLedgerNo ");
            sb.Append(" INNER JOIN f_ledgermaster lmd ON lmd.LedgerNumber= cd.DeptLedgerNo ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
            sb.Append(" INNER JOIN f_categorymaster ccm ON ccm.CategoryID=sc.CategoryID ");
            sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=cr.ReturnByUserID ");

            sb.Append("  WHERE cr.ReturnDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'");
            sb.Append(" AND cr.ReturnDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'");
            if (ddlVendor.SelectedIndex > 0)
                sb.Append(" AND cr.VendorLedgerNo='" + ddlVendor.SelectedItem.Value.Split('#')[0] + "' ");

            if (txtConsignmentNo.Text.ToString() != string.Empty)
                sb.Append(" AND cd.ConsignmentNo='" + txtConsignmentNo.Text.ToString() + "' ");

            if (txtDeliveryNo.Text.ToString() != string.Empty)
                sb.Append(" AND cd.ChallanNo='" + txtDeliveryNo.Text.ToString() + "' ");

            if (ddlCentre.SelectedIndex > 0)
                sb.Append(" AND cd.CentreID='" + ddlCentre.SelectedItem.Value.Split('#')[0] + "' ");

            if (ddlCategory.SelectedIndex > 0)
                sb.Append(" AND sc.CategoryID='" + ddlCategory.SelectedItem.Value.Split('#')[0] + "' ");

            if (ddlSubCategory.SelectedIndex > 0)
                sb.Append(" AND sc.SubCategoryID='" + ddlSubCategory.SelectedItem.Value.Split('#')[0] + "' ");

            if (ddlDpt.SelectedIndex > 0)
                sb.Append(" AND cd.DeptLedgerNo='" + ddlDpt.SelectedItem.Value + "' ");

            if (txtItemName.Text.ToString() != string.Empty)
                sb.Append(" AND cd.ItemName like '%" + txtItemName.Text.ToString() + "%' ");

            sb.Append("  ORDER BY cr.ReturnNo, cd.ConsignmentNo,ccm.Name,sc.Name,cd.ItemName ");
        }
        else if (rbtnType.SelectedValue == "3")
        {
            sb.Append("SELECT st.StockDate,sd.Date,st.InvoiceNo,st.ChalanNo 'Delivery No.',st.ConsignmentID AS ConsignmentNo,rm.RoleName DeptName, ");
            sb.Append("st.ItemName,sd.SoldUnits,st.unitPrice,st.PurTaxPer,REPLACE(sd.TransactionID,'ISHHI','')IPNo,llt.BillNo GRNNo,lm.LedgerName ");
            sb.Append("FROM f_stock st ");
            sb.Append("INNER JOIN f_salesdetails sd ON sd.StockID=st.StockID  ");
            sb.Append("INNER JOIN f_rolemaster rm ON rm.DeptLedgerNo=st.DeptLedgerNo ");
            sb.Append("INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=sd.LedgertransactionNo ");
			sb.Append(" INNER JOIN f_ledgertransaction llt  ON llt.LedgertransactionNo = st.LedgertransactionNo ");
            sb.Append("INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=st.VenLedgerNo ");
            sb.Append("WHERE st.ConsignmentID<>'' AND sd.TrasactionTypeID=3 AND st.StockDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND st.StockDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
            if (ddlDpt.SelectedIndex > 0)
                sb.Append(" AND st.DeptLedgerNo='" + ddlDpt.SelectedItem.Value + "' ");
            if (ddlCentre.SelectedIndex > 0)
                sb.Append(" AND st.CentreID='" + ddlCentre.SelectedItem.Value.Split('#')[0] + "' ");
            sb.Append("GROUP BY sd.ID; ");
        }

        //System.IO.File.WriteAllText (@"F:\niraj.txt", sb.ToString());
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            if(rbtnType.SelectedItem.Value =="0")
            Session["ReportName"] = "Consignment Receive Report";
            else
                Session["ReportName"] = "Consignment Return Report";

            Session["Period"] = "From : " + txtFromDate.Text + " To : " + txtFromDate.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            //grdSearch.DataSource = dt;
            //grdSearch.DataBind();
            lblMsg.Text = "";
        }

        else
        {
            lblMsg.Text = "No records found";


        }
    }

}
