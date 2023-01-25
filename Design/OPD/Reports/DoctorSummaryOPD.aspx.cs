using System;
using System.Data;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_OPD_DoctorSummaryOPD : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            All_LoadData.bindDocGroup(ddlDoctorGroup, "All");
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
        lblMsg.Text = "";
    }
    
    protected void btnSearch_Click(object sender, EventArgs e)
    {

        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string DocGroup = "0";
        if (ddlDoctorGroup.SelectedItem.Text.ToUpper() != "ALL")
        {
            DocGroup = ddlDoctorGroup.SelectedValue;
        }
         int PackageCondition = 0;
         if (chkPackageCondition.Checked)
            PackageCondition = 1;
         DataTable dtAppDetail = AllLoadData_OPD.DoctorWiseOPDSummary("", Util.GetDateTime(ucFromDate.Text), Util.GetDateTime(ucToDate.Text), PackageCondition, Centre, DocGroup);

        if (dtAppDetail.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text.Trim()).ToString("dd-MMM-yyyy");
            dtAppDetail.Columns.Add(dc);

            DataColumn dc2 = new DataColumn();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            dc2.ColumnName = "UserName";
            dc2.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dtAppDetail.Columns.Add(dc2);
            DataSet ds = new DataSet();
            ds.Tables.Add(dtAppDetail.Copy());
            ds.Tables.Add(dtImg.Copy());
            Session["ds"] = ds;
           // ds.WriteXmlSchema(@"E:\DoctorWiseAppointmentSummary.xml");
            Session["ReportName"] = "DoctorWiseAppointmentSummary";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/common/Commonreport.aspx');", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found');", true);
    }
}
