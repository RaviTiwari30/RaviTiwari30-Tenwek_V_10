using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_EDP_LoginDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {

        lblMsg.Text = "";
        //StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT CONCAT(em.title,'',em.name)NAME,GROUP_CONCAT(rm.RoleName)RoleName,DATE_FORMAT(fl.lastLoginTime,'%d-%b-%y'),fl.Username,fl.Password ");
        //sb.Append(" FROM f_login fl INNER JOIN employee_master em ON em.employee_ID=fl.employeeID ");
        //sb.Append(" INNER JOIN f_rolemaster rm ON rm.ID=fl.roleID  WHERE em.isActive=1 AND EmployeeID<>'EMP001' GROUP BY em.Employee_ID ");
        DataTable dt = StockReports.GetDataTable("CALL Employee_Log_Management(" + ddlType.SelectedValue + ",'" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "')");
        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "";
        //    DataColumn dc1 = new DataColumn();
        //    dc1.ColumnName = "User";
        //    dc1.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
        //    dt.Columns.Add(dc1);
        //    DataSet ds = new DataSet();
        //    ds.Tables.Add(dt.Copy());
        //    // ds.WriteXmlSchema(@"E:\LoginDetail.xml");
        //    Session["ds"] = ds;
        //    Session["ReportName"] = "LoginDetails";
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);

           string ReportName = ddlType.SelectedItem.Text;
                 
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");

            dt.Columns.Add(dc);
            dt = Util.GetDataTableRowSum(dt);

            string CacheName = HttpContext.Current.Session["ID"].ToString();
            Common.CreateCachedt(CacheName, dt);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E');", true);
           // return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E" });
         
        
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }
}