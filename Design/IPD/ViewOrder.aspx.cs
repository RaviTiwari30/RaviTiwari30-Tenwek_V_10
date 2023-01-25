using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;
using System.Data;

public partial class Design_IPD_ViewOrder : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string BindOrder(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pt.indent_No,im.TypeName,pt.Quantity,CONCAT(dm.title,' ',dm.Name)DrName,pt.Remarks,em.Name,");
        sb.Append(" DATE_FORMAT(CreatedDate,'%d-%b-%y')Created_Date,em1.Name AS IssueBy,DATE_FORMAT(IssueDate,'%d-%b-%y')Issue_Date,pt.IsIssue ");
        sb.Append(" FROM patient_test pt INNER JOIN employee_master em ON em.Employee_ID=pt.CreatedBy ");
        sb.Append(" LEFT JOIN employee_master em1 ON em1.Employee_ID=pt.IssueBy ");
        sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID = pt.DoctorID");
        sb.Append(" INNER JOIN f_itemmaster im ON im.itemID=pt.Test_ID");
        sb.Append(" where TransactionID='"+ TransactionID+"' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if(dt.Rows.Count >0)
         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}