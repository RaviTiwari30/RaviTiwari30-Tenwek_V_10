using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
public partial class Design_OPD_Panelallocation_OPD : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            ucToDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindData();
    }

    private void BindData()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(pm.Title,' ',pm.PName)PName,pmh.TransactionID,pm.PatientID,pm.Age,pm.Mobile,pm.Gender,pmh.BillNo, ");
        sb.Append(" DATE_FORMAT( pmh.BillDate,'%d-%b-%Y %r')BillDate, DATE_FORMAT(pmh.DateOfVisit,'%d-%b-%Y')DateOfVisit,fpm.Company_Name  FROM  patient_medical_history pmh  ");
        sb.Append("  INNER JOIN  patient_master pm ON pm.PatientID=pmh.PatientID INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID ");
        sb.Append(" WHERE IFNULL(BillNo,'')<>'' AND pmh.PanelID<>'"+ Resources.Resource.DefaultPanelID +"' ");
        sb.Append(" AND pmh.DateOfVisit>='" + Util.GetDateTime(ucFromDate.Text.ToString().Trim()).ToString("yyyy-MM-dd") + "' AND pmh.DateOfVisit<='" + Util.GetDateTime(ucToDate.Text.ToString().Trim()).ToString("yyyy-MM-dd") + "' ");
        if (txtUHID.Text.ToString() != "")
        {
            sb.Append(" And  pm.PatientID='" + txtUHID.Text.ToString().Trim() + "' ");
        }
        if (txtName.Text.ToString() != "")
        {
            sb.Append(" And  pm.PName LIKE '%" + txtName.Text.ToString().Trim() + "%'");
        }
        if (txtBillNo.Text.ToString() != "")
        {
            sb.Append(" And  pmh.BillNo='" + txtBillNo.Text.ToString().Trim() + "' ");
        }
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        grdDetails.DataSource = dt;
        grdDetails.DataBind();
    }

    [WebMethod(EnableSession = true)]
    public static string CheckDataFinance(string TID)
    {
        if (Resources.Resource.AllowFiananceIntegration == "2")//
        {
            if (AllLoadData_IPD.CheckAllocationPostToFinance(TID) > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Patient's Final Bill Already Posted To Finance..." }) ;
            }
            else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient's Final Bill Already Posted To Finance..." }) ;}
        }
        else
        {  return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient's Final Bill Already Posted To Finance..." }); }
    }

}