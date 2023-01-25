using System;
using System.Data;
using System.Web.UI;
using CrystalDecisions.CrystalReports.Engine;

public partial class Design_Purchase_LowStockReport : System.Web.UI.Page
{
    private ReportDocument obj1 = new ReportDocument();

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (rbtnMedNonMed.SelectedIndex < 0)
        {
            lblMsg.Text = "Select Store Type";
            return;
        }
        DataSet ds = new DataSet();
        DataTable dt = new DataTable();
        dt = GetMinStockReport();
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "ClientName";
            dc.DefaultValue = GetGlobalResourceObject("Resource", "ClientFullName").ToString();
            dt.Columns.Add(dc);

            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("D:\\MedLowStockReport.xml");
            if (ds != null)
            {
                Session["ds"] = ds;
                Session["ReportName"] = "MedLowStockReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
        }
        else
            lblMsg.Text = "No Record Found";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["DeptLedgerNo"] != null)
                ViewState["CurDeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            else
                ViewState["CurDeptLedgerNo"] = "";
            AllLoadData_Store.checkStoreRight(rbtnMedNonMed);
        }
    }

    private DataTable GetMinStockReport()
    {
        string str = "";
        str = "SELECT * FROM (select SUM(st.InitialCount-st.ReleasedCount-st.PendingQty) as QtyInHand,Im.ItemID,Im.TypeName as ItemName,Im.BillingUnit,IM.MinLevel as minLimit,im.MaxLevel as maxLimit from f_itemmaster im";
        str = str + "  INNER JOIN f_stock st on st.ItemID = im.ItemID WHERE ";

        str = str + " st.StoreLedgerNo='" + rbtnMedNonMed.SelectedValue + "' AND DeptLedgerNo='" + ViewState["CurDeptLedgerNo"].ToString() + "' ";

        str = str + " GROUP BY ItemID) tb ";
        str = str + " WHERE tb.QtyInHand < tb.minlimit";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        return dt;
    }
}
