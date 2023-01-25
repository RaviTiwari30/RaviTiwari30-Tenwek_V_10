using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_Payroll_MiscellaneousReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        //StringBuilder sb1 = new StringBuilder();
        //sb1.Append("  SELECT ID,NAME  FROM pay_remuneration_master remu INNER JOIN pay_transactiontype tran  ");
        //sb1.Append(" ON tran.TypeID=remu.ID WHERE remu.IsActive=1 AND remu.IsInitial=1 AND remu.ID<>33  ");
        //DataTable DtMiss = StockReports.GetDataTable(sb1.ToString());

        StringBuilder sb = new StringBuilder();
        sb.Append(" select ID,EmployeeID,Name,SalaryType,sum(OTHERDEDUCTION)OTHERDEDUCTION,sum(INCOMETAX)INCOMETAX,sum(SALARYADVANCE)SALARYADVANCE,sum(STAFFWELFARE)STAFFWELFARE,SalaryMonth from (");
        sb.Append(" select mst.ID,mst.EmployeeID,mst.Name,SalaryType, ");
        sb.Append(" ( case TypeID when 22 then det.Amount else 0 end)OTHERDEDUCTION ");
        sb.Append(" ,( case TypeID when 16 then det.Amount else 0 end)INCOMETAX ");
        sb.Append(" ,( case TypeID when 48 then det.Amount else 0 end)SALARYADVANCE ");
        sb.Append(" ,( case TypeID when 42 then det.Amount else 0 end)STAFFWELFARE ");
        sb.Append(" ,SalaryMonth from pay_empsalary_master mst ");
        sb.Append(" inner join pay_empsalary_detail det on mst.ID=det.MasterID where date(mst.SalaryMonth)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' and  date(mst.SalaryMonth)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" and Amount>0 order by mst.EmployeeID,SalaryMonth  ");
        sb.Append(" )T group by ID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        //DataTable CrossTab = new DataTable();
        //CrossTab.Columns.Add(new DataColumn("ID"));
        //CrossTab.Columns.Add(new DataColumn("EmployeeID"));
        //CrossTab.Columns.Add(new DataColumn("Name"));
        //foreach (DataRow row in DtMiss.Rows)
        //{
        //    CrossTab.Columns.Add(new DataColumn(row["NAME"].ToString()));

        //}
        //for (int i = 0; i < dt.Rows.Count; i++)
        //{
        //    DataRow newrow = CrossTab.NewRow();
        //    newrow[i] = dt.Rows[i]["ID"].ToString();
        //    newrow[i] = dt.Rows[i]["EmployeeID"].ToString();
        //    newrow[i] = dt.Rows[i]["Name"].ToString();
        //    newrow[i] = dt.Rows[i]["Name"].ToString();
        //    CrossTab.Rows.Add(newrow);
        //}

        if (dt.Rows.Count > 0)
        {
            lblmsg.Text = "";
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("E:/Miscellaneous.xml");
            if (RadioButtonList2.SelectedItem.Text == "Excel")
            {
                Session["ReportName"] = "Miscellaneous";
                Session["CustomData"] = dt;
                Session["Period"] = "From Date: " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + "To Date: " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
            }
            else
            {
                Session["ds"] = ds;
                Session["ReportName"] = "Miscellaneous";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }
}