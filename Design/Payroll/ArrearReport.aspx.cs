using System;
using System.Data;
using System.Web.UI;

public partial class Design_Payroll_ArrearReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (RadioButtonList1.SelectedItem.Text == "Word")
        {
            Session["PrintType"] = "ExpToWord";
        }
        else
        {
            Session["PrintType"] = "ExpToPDF";
        }

        string s = "select mst.EmployeeID,mst.Name,mst.PayableDays,mst.ArrearMonth,ArrearType,mst.TotalEarning,mst.TotalDeduction,mst.NetPayable from pay_empsalary_master mst";
        s += " inner join pay_arreardetail arr on mst.EmployeeID=arr.EmployeeID and date(mst.ArrearMonth)=date(arr.ArrearMonth) where SalaryType='A' and  Month(SalaryMonth)=Month('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') and year(SalaryMonth)=Year('" + Util.GetDateTime(SalaryMonth.Text).ToString("yyyy-MM-dd") + "') order by mst.EmployeeID,date(mst.ArrearMonth)";
        DataTable dt = StockReports.GetDataTable(s);
        DataColumn dc = new DataColumn("SalaryMonth");
        dc.DefaultValue = SalaryMonth.Text;
        dt.Columns.Add(dc);
        DataColumn dc1 = new DataColumn("User");
        dc1.DefaultValue = Session["LoginName"].ToString();
        dt.Columns.Add(dc1);
        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        if (ds.Tables[0].Rows.Count > 0)
        {
            Session["ds"] = ds;
            Session["ReportName"] = "ArrearReport";
            // ds.WriteXmlSchema("C:/ArrearReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Payroll/Report/Commonreport.aspx');", true);
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
            SalaryMonth.Text = System.DateTime.Now.ToString("MMM-yyyy");
        }
        SalaryMonth.Attributes.Add("readonly", "readonly");
    }
}