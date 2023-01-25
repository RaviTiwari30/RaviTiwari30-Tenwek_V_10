using System;
using System.Data;
using System.Web.UI;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Web.UI.WebControls;
public partial class Design_CommonReports_DoctorCashCollectedReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            BindDoctor();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    protected void BindDoctor()
    {
        DataTable dt = All_LoadData.bindDoctor();
        ddlDoctor.DataSource = dt;
        ddlDoctor.DataTextField = "Name";
        ddlDoctor.DataValueField = "DoctorID";
        ddlDoctor.DataBind();
        ddlDoctor.Items.Insert(0, new ListItem("All", "0"));

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        ExcuteCMD excuteCMD = new ExcuteCMD();
        var dt = excuteCMD.GetDataTable("Call sp_DoctorCashCollectionReport(@vFromDate,@vToDate,@vDoctorID,@vCentreID)", CommandType.Text, new
        {
            vFromDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd"),
            vToDate = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"),
            vDoctorID= ddlDoctor.SelectedItem.Value.Trim(),
            vCentreID = Centre
        });

        if (dt.Rows.Count > 0)
        {
            dt.Columns.Remove("ID");

            string ReportName = "Cash Doctor Collection Report";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");

            dt.Columns.Add(dc);
            dt = Util.GetDataTableRowSum(dt);

            string CacheName = Session["ID"].ToString();
            Common.CreateCachedt(CacheName, dt); ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('Commonreport.aspx?ReportName=" + ReportName + "&Type=E');", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    }
}