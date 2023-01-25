using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_MonthWiseDiagnosisReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetMyMonthList();
            GetMyYearList();
            GetMyWardList();
        }
        
    }


    public void GetMyMonthList()
    {
        DateTime month = Convert.ToDateTime("01/01/2022");
        for (int i = 0; i < 12; i++)
        {
            DateTime NextMont = month.AddMonths(i);
            ListItem list = new ListItem();
            list.Text = NextMont.ToString("MMM");
            list.Value = NextMont.Month.ToString();
            ddlMonth.Items.Add(list);
        }

        ddlMonth.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;

    }

    public void GetMyWardList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.IPDCaseTypeID Id,im.NAME  FROM ipd_case_type_master im WHERE im.IsActive=1 AND im.CentreID='" + Util.GetString(Session["CentreID"].ToString()) + "'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlward.DataSource = dt;
        ddlward.DataValueField = "Id";
        ddlward.DataTextField = "NAME";
        ddlward.DataBind();
        ddlward.Items.Insert(0, new ListItem("OPD", ""));
    }

    public void GetMyYearList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT(YEAR(cpoe.EntDate))YearId FROM cpoe_10cm_patient cpoe ORDER BY (YEAR(cpoe.EntDate)) ASC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlYear.DataSource = dt;
        ddlYear.DataValueField = "YearId";
        ddlYear.DataTextField = "YearId";
        ddlYear.DataBind();
        ddlYear.Items.FindByValue(DateTime.Now.Year.ToString()).Selected = true;

    }


    protected void btnReport_Click(object sender, EventArgs e)
    {

        decimal FromAgeinDay = (Util.GetDecimal(txtFromAge.Text) * 365);
        decimal ToAgeInDay = (Util.GetDecimal(txtToAge.Text) * 365);

        StringBuilder sb = new StringBuilder(); 

        sb.Append("CALL sp_Diagnosis_count_MonthWise("+Util.GetInt( ddlMonth.SelectedValue.ToString())+","+Util.GetInt(ddlYear.SelectedValue.ToString())+",'"+Util.GetString(ddlward.SelectedItem.Value.ToString())+"',"+FromAgeinDay+","+ToAgeInDay+")");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            Session["ReportName"] = "Month Wise Diagnosis Report";
            Session["dtExport2Excel"] = dt;
            Session["Period"] = ddlMonth.SelectedItem.Text.ToString() + " - " + ddlYear.SelectedValue.ToString();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);


        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);

    }
}