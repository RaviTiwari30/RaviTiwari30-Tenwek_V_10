using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_Finance_MISReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_Store.checkStoreRight(rdbstore);
            BindVendor();
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            BindStoreDepartment();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    private void BindStoreDepartment()
    {
        var CentreID = Util.GetInt(Session["CentreID"].ToString());
        var storetype = rdbstore.SelectedValue;
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT lm.`LedgerName`,lm.`LedgerNumber`FROM f_rolemaster rm INNER JOIN f_ledgermaster lm ON lm.`LedgerNumber`=rm.`DeptLedgerNo`INNER JOIN f_centre_role cr ON cr.RoleID=rm.id AND cr.CentreID IN (" + CentreID + ")  AND cr.isActive=1  WHERE rm.Active=1 AND cr.IsDepartmentIndent=1 ");
        if (storetype == "Medical")
            sb.Append(" and rm.IsMedical=1 ");
        else
            sb.Append(" and rm.IsGeneral=1 ");

        sb.Append(" order by LedgerName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataSource = dt;
        ddlDepartment.DataTextField = "LedgerName";
        ddlDepartment.DataValueField = "LedgerNumber";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, "ALL");
        ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByValue(Session["DeptLedgerNo"].ToString()));
    }

    private void BindVendor()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select LedgerNumber,LedgerName from f_ledgermaster led INNER JOIN f_vendormaster ven ");
        sb.Append(" ON led.LedgerUserID=ven.Vendor_ID where GroupID = 'VEN' ");
        // if(rdbstore.SelectedValue=="Medical")
        //     sb.Append(" AND ven.VendorCategory='MEDICAL ITEMS' ");
        //  else if (rdbstore.SelectedValue == "General")
        //     sb.Append(" AND ven.VendorCategory='GENERAL ITEMS' ");
        sb.Append(" order by LedgerName");
        DataTable dt = StockReports.GetDataTable(sb.ToString());


        if (dt.Rows.Count > 0)
        {
            chkVendor.DataSource = dt;
            chkVendor.DataTextField = "LedgerName";
            chkVendor.DataValueField = "LedgerNumber";
            chkVendor.DataBind();
        }
    }
    protected void ChkAll_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < chkVendor.Items.Count; i++)
        {
            chkVendor.Items[i].Selected = ChkAll.Checked;
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (rdbstore.SelectedIndex < 0)
        {
            lblMsg.Text = "Please Select Store Type";
            return;
        }
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string Vendor = StockReports.GetSelection(chkVendor);
        if (Vendor == "")
        {
            lblMsg.Text = "Please Select Supplier";
            return;
        }
        

        StringBuilder sb = new StringBuilder();
        if (rdbReportType.SelectedValue == "1")
        {
            sb.Append(" SELECT flm.LedgerName as Department,cmt.CentreID,cmt.CentreName,lt.BillNo LedgerTransactionNo,lt.Date,lt.LedgerNoCr,ROUND(SUM(lt.GROSSAMOUNT),0)NetAmount,IM.InvoiceNo,im.InvoiceDate,LM.LedgerName");
            sb.Append(" ,(select distinct(Naration) from f_stock where LedgerTransactionNo = lt.LedgerTransactionNo)Narration ");
            sb.Append(" FROM f_ledgertransaction lt   INNER JOIN f_invoicemaster IM ON lt.LedgerTransactionNo = IM.LedgerTnxNo");
            sb.Append(" INNER JOIN f_ledgermaster LM ON lt.LedgerNoCr = LM.LedgerNumber inner join f_ledgermaster flm on fLM.LedgerNumber= lt.DeptLedgerNo ");
            sb.Append(" INNER JOIN center_master cmt ON cmt.centreID = LT.CentreID ");
            if (rdbstore.SelectedValue == "Medical")
            {
                sb.Append(" WHERE LT.TypeOfTnx = 'Purchase' ");
            }
            else
            {
                sb.Append(" WHERE LT.TypeOfTnx = 'NMPURCHASE' ");
            }
            sb.Append(" AND LT.CentreID IN (" + Centre + ")  and LM.GroupID = 'VEN' AND LT.IsCancel=0  AND ");
            if (rdbDate.SelectedValue == "GRN")
                sb.Append(" Date(lt.Date)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "' and date(lt.Date)<='" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "' ");
            else
                sb.Append(" Date(im.InvoiceDate)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "' and date(im.InvoiceDate)<='" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "' ");

            sb.Append(" and IM.InvoiceNo <> '' ");
            if(Util.GetString(ddlDepartment.SelectedValue)!="ALL")
                sb.Append(" AND lt.DeptLedgerNo='" + ddlDepartment.SelectedValue + "'");

            if (Vendor != string.Empty)
                sb.Append(" AND lt.LedgerNoCr in (" + Vendor + ")");
            sb.Append(" GROUP BY lt.LedgerTransactionNo order by lt.LedgerTransactionNo");

            DataTable dt = new DataTable();

            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                lblMsg.Text = "";
                DataColumn dc = new DataColumn();
                dc.ColumnName = "User";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dc = new DataColumn();
                dc.ColumnName = "ClientName";
                dc.DefaultValue = GetGlobalResourceObject("Resource", "ClientFullName").ToString();
                dt.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                Session["ds"] = ds;
                Session["ReportName"] = "VendorBillDetails";
              //   ds.WriteXmlSchema(@"E:\VendorBillDetails.xml");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);

            }
            else

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
        else
        {
            sb.Append(" SELECT flm.LedgerName as Department, cmt.CentreID,cmt.CentreName,COUNT(lt.LedgerTransactionNo)TotalGRN,lt.Date,ROUND(SUM(lt.GROSSAMOUNT),0)NetAmount,im.InvoiceDate,'" + rdbDate.SelectedValue + "' as ReportType  ");
            sb.Append(" FROM f_ledgertransaction lt   INNER JOIN f_invoicemaster IM ON lt.LedgerTransactionNo = IM.LedgerTnxNo  ");
            sb.Append(" INNER JOIN center_master cmt ON cmt.centreID = LT.CentreID  inner join f_ledgermaster flm on fLM.LedgerNumber= lt.DeptLedgerNo ");
            if (rdbstore.SelectedValue == "Medical")
            {
                sb.Append(" WHERE LT.TypeOfTnx = 'Purchase' ");
            }
            else
            {
                sb.Append(" WHERE LT.TypeOfTnx = 'NMPURCHASE' ");
            }
            sb.Append("  AND LT.CentreID IN ('1') AND LT.IsCancel=0   ");
            sb.Append(" and IM.InvoiceNo <> '' ");
            if (Util.GetString(ddlDepartment.SelectedValue) != "ALL")
                sb.Append(" AND lt.DeptLedgerNo='" + ddlDepartment.SelectedValue + "'");

            if (Vendor != string.Empty)
                sb.Append(" AND lt.LedgerNoCr in (" + Vendor + ")");

            if (rdbDate.SelectedValue == "GRN")
                sb.Append(" and Date(lt.Date)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "' and date(lt.Date)<='" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "' GROUP BY lt.DeptLedgerNo,date ORDER BY date");
            else
                sb.Append(" AND  Date(im.InvoiceDate)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "' and date(im.InvoiceDate)<='" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "' GROUP BY lt.DeptLedgerNo,invoicedate ORDER BY invoicedate");



            DataTable dt = new DataTable();

            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                lblMsg.Text = "";
                DataColumn dc = new DataColumn();
                dc.ColumnName = "User";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dc = new DataColumn();
                dc.ColumnName = "ClientName";
                dc.DefaultValue = GetGlobalResourceObject("Resource", "ClientFullName").ToString();
                dt.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                Session["ds"] = ds;
                Session["ReportName"] = "VendorBillSummary";
               // ds.WriteXmlSchema(@"E:\VendorBillSummary.xml");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);

            }
            else

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    protected void rdbstore_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindVendor();
    }
}
