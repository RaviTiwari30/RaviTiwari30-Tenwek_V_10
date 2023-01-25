using System;
using System.Web.Services;


public partial class Design_EDP_ApprovalTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string getEmployeeList() {
        string sqlCommand = "SELECT em.EmployeeID 'EMP_ID',CONCAT(em.`Title`,' ',em.`Name`)'Name' FROM `employee_master` em WHERE em.`IsActive`=1 ORDER BY  em.`Name`";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sqlCommand));
    }
}