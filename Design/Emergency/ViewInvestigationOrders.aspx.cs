using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Emergency_ViewInvestigationOrders : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            BindPatientExam();
    }
    private void BindPatientExam()
    {
        string TransactionId = Convert.ToString(Request.QueryString["TID"]);
        string LnxNo = Convert.ToString(Request.QueryString["LnxNo"]);

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT (SELECT CONCAT(title,' ',name) FROM doctor_master where DoctorID=doctorID)DoctorName,pt.outsource,pt.Test_ID ItemID,");
        sb.Append(" date_format(pt.PrescribeDate,'%d-%b-%Y') Date,remarks,im.typeName Item,Quantity FROM patient_test pt INNER JOIN f_itemmaster im ");
        sb.Append(" on pt.test_ID = im.ItemID where pt.TransactionID = '" + TransactionId + "' and pt.LedgerTransactionNo ='" + LnxNo + "' and ConfigID = 3");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            grdPreInvestigation.DataSource = dt;
            grdPreInvestigation.DataBind();
        }
    }
}