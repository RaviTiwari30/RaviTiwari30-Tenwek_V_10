using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using System.Linq;
public partial class Design_Purchase_PRNormsReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_Store.bindStoreDepartments(ddlStoreDepartment, "", "All");
        }
    }

    private DataTable bindData()
        {
        DataTable inputTable = LoadCacheQuery.bindStoreDepartment();
        DataTable dtSoreDept = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TypeName ItemName,lm.LedgerName DepartmentName,spr.LastMonthConsumption,spr.DepartmentStock,spr.CurrentQuantity,spr.Minimum,spr.Maximum ");
        sb.Append("  FROM f_setPurchaseRequestQuantity spr INNER JOIN f_itemmaster im ON im.ItemID=spr.ItemID ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=spr.DeptLedgerNo ");
        sb.Append(" WHERE spr.StoreType='" + rdoStoretype.SelectedValue + "' AND spr.IsActive=1 ");
        if (ddlStoreDepartment.SelectedIndex != 0)
            sb.Append(" AND spr.DeptLedgerNo='" + ddlStoreDepartment.SelectedValue + "' ");


        DataTable dtItem = StockReports.GetDataTable(sb.ToString());
        if (inputTable.Rows.Count > 0)
            {
            dtSoreDept.Columns.Add("ItemName").DataType = typeof(string);
            foreach (DataRow dr in inputTable.Rows)
                {
                string StoreName = Util.GetString(dr["ledgerName"]);

                dtSoreDept.Columns.Add(StoreName).DataType = typeof(string);
                dtSoreDept.Columns.Add(Util.GetString(dr["ledgerNumber"])).DataType = typeof(string);
                string deptStock = StoreName + "_StockDept";
                string currentQty = StoreName + "_currentQty";
                string Min = StoreName + "_Min";
                string Max = StoreName + "_Max";
                dtSoreDept.Columns.Add(deptStock).DataType = typeof(string);
                dtSoreDept.Columns.Add(currentQty).DataType = typeof(string);
                dtSoreDept.Columns.Add(Min).DataType = typeof(string);
                dtSoreDept.Columns.Add(Max).DataType = typeof(string);

                if (dtItem.Rows.Count > 0)
                    {
                    for (int i = 0; i < dtItem.Rows.Count; i++)
                        {
                        DataRow drnew = dtSoreDept.NewRow();
                        drnew["ItemName"] = Util.GetString(dtItem.Rows[i]["ItemName"]);
                        dtSoreDept.Rows.Add(drnew);
                        }

                    }

                }
            }

        return dtSoreDept;
        }
    protected void btnReport_Click(object sender, EventArgs e)
        {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.ItemID,im.TypeName ItemName,lm.LedgerName DepartmentName,spr.LastMonthConsumption,spr.DepartmentStock,spr.CurrentQuantity,spr.Minimum,spr.Maximum ");
        sb.Append("  FROM f_setPurchaseRequestQuantity spr INNER JOIN f_itemmaster im ON im.ItemID=spr.ItemID ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=spr.DeptLedgerNo ");
        sb.Append(" WHERE spr.StoreType='" + rdoStoretype.SelectedValue + "' AND spr.IsActive=1 ");
        if(ddlStoreDepartment.SelectedIndex !=0)
            sb.Append(" AND spr.DeptLedgerNo='"+ddlStoreDepartment.SelectedValue+"' ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            {
            //DataSet ds = new DataSet();
            //ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"D:\PRNormReport.xml");
            //Session["ds"] = ds;
            //Session["ReportName"] = "PRNormReport";
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);

            DataTable dtSoreDept = new DataTable();
            DataTable SoreDept = LoadCacheQuery.bindStoreDepartment();
            if (SoreDept.Rows.Count > 0)
                {
                dtSoreDept.Columns.Add("ItemName").DataType = typeof(string);
                dtSoreDept.Columns.Add("ItemID").DataType = typeof(string);
                foreach (DataRow dr in SoreDept.Rows)
                    {
                    string StoreName = Util.GetString(dr["ledgerName"]);
                    dtSoreDept.Columns.Add(StoreName).DataType = typeof(string);

                    string LastMonthConsumption = StoreName + "_LastMonthConsumption";
                    string deptStock = StoreName + "_DepartmentStock";
                    string currentQty = StoreName + "_CurrentQuantity";
                    string Min = StoreName + "_Min";
                    string Max = StoreName + "_Max";

                    dtSoreDept.Columns.Add(LastMonthConsumption).DataType = typeof(string);
                    dtSoreDept.Columns.Add(deptStock).DataType = typeof(string);
                    dtSoreDept.Columns.Add(currentQty).DataType = typeof(string);
                    dtSoreDept.Columns.Add(Min).DataType = typeof(string);
                    dtSoreDept.Columns.Add(Max).DataType = typeof(string);
                    }
                if (dt.Rows.Count > 0)
                    {
                    DataTable dtGroup = dt.AsEnumerable().GroupBy(r => r.Field<string>("ItemID")).Select(g => g.First()).CopyToDataTable();


                    for (int i = 0; i < dtGroup.Rows.Count; i++)
                        {
                        DataRow drnew = dtSoreDept.NewRow();
                        drnew["ItemName"] = Util.GetString(dtGroup.Rows[i]["ItemName"]);
                        dtSoreDept.Rows.Add(drnew);
                        }

                    }
                }

            Session["dtExport2Excel"] = dtSoreDept;
            Session["ReportName"] = "PR Norms Report";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
      
            }



        }
}