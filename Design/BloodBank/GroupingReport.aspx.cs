using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_BloodBank_GroupingReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = Search();
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + txtdatefrom.Text + " To : " + txtdateTo.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "GroupingReport";

            //ds.WriteXmlSchema("C:/GroupingReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = Search();
        if (dt.Rows.Count > 0)
        {
            grdDonorList.DataSource = dt;
            grdDonorList.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            grdDonorList.DataSource = null;
            grdDonorList.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
            pnlHide.Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtBloodCollectionID.Focus();
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            btnPrint.Attributes.Add("onclick", String.Format("this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnPrint, String.Empty)));          
        }
        txtdatefrom.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }

    private DataTable Search()
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb2 = new StringBuilder();
            sb2.Append(" Select bcd.BloodCollection_Id,CASE WHEN (bg.AntiA=1) THEN 'N' ELSE 'P' END  AS AntiA,  ");
            sb2.Append(" CASE WHEN (bg.AntiB=1) THEN 'N' ELSE 'P' END AS AntiB,CASE WHEN (bg.AntiAB=1) THEN 'N' ELSE 'P' END AS AntiAB,");
            sb2.Append(" CASE WHEN (bg.RH=1) THEN 'N' ELSE 'P' END AS RH,CASE WHEN (bg.ACell=1) THEN 'N' ELSE 'P' END AS ACell,CASE WHEN (bg.BCell=1) THEN 'N' ELSE 'P' END AS BCell,");
            sb2.Append(" CASE WHEN (bg.OCell=1) THEN 'N' ELSE 'P' END AS OCell,bg.BloodGroupAlloted,");
            sb2.Append(" bg.BloodTested,DATE_FORMAT(bg.CreatedDate,'%d-%b-%Y')CreatedDate from bb_Grouping  bg ");
            sb2.Append(" inner join bb_collection_details bcd ON bg.BloodCollection_Id=bcd.BloodCollection_Id   ");
            if (txtBloodCollectionID.Text.Trim() != "")
            {
                sb2.Append(" AND bcd.BloodCollection_Id='" + txtBloodCollectionID.Text.Trim() + "'");
            }

            if (txtBloodCollectionID.Text == "")
            {
                if (txtdatefrom.Text != "")
                {
                    sb2.Append(" AND DATE(bcd.Collecteddate) >='" + Util.GetDateTime(txtdatefrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtdateTo.Text != "")
                {
                    sb2.Append(" and DATE(bcd.Collecteddate) <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }
            sb2.Append(" ORDER BY bcd.BloodCollection_Id");
            dt1 = StockReports.GetDataTable(sb2.ToString());
            return dt1;
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            return dt1;
        }
    }
}