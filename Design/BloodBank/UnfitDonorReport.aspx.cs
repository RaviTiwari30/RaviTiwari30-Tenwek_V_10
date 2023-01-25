using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_BloodBank_UnfitDonorReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = search();
        if (dt != null && dt.Rows.Count > 0)
        {
            lblerrmsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            //dc.DefaultValue = "Period From " + EntryDate1.GetDateForDisplay() + " To : " + EntryDate1.GetDateForDisplay();
            dc.DefaultValue = "Period From " + txtdatefrom.Text + " To : " + txtdateTo.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "DonorUnfitReport";

            //ds.WriteXmlSchema("C:/DonorUnfitReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = search();
        if (dt.Rows.Count > 0)
        {
            grdGrid.DataSource = dt;
            grdGrid.DataBind();

            pnlHide.Visible = true;
        }
        else
        {
            grdGrid.DataSource = null;
            grdGrid.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
            //lblerrmsg.Text = "No Fecord Found";
            pnlHide.Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDonorId.Focus();
            txtdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            btnPrint.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnPrint, String.Empty)));
        }
        txtdatefrom.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }

    private DataTable search()
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT bv.visitor_id,bv.Name,bv.gender,DATE_FORMAT(bv.dtentry,'%d-%b-%Y')dtentry,concat(bv.address,' ',bv.city)Address  ");
            sb.Append(" ,CASE WHEN bv.MobileNo!='' THEN MobileNo  ELSE bv.PhoneNo END AS ContactNo,bvh.remarks ");
            sb.Append("  FROM bb_visitors bv INNER JOIN bb_visitors_history bvh ON bvh.Visitor_ID=bv.Visitor_ID   WHERE bvh.isfit=0 ");
            if (txtDonorId.Text != "")
            {
                sb.Append(" AND bv.visitor_id='" + txtDonorId.Text + "'");
            }
            if (txtName.Text != "")
            {
                sb.Append(" AND bv.Name like '" + txtName.Text + "%'");
            }
            if (txtDonorId.Text == "" && txtName.Text == "")
            {
                if (txtdatefrom.Text != "")
                {
                    sb.Append(" AND DATE(bv.dtentry) >='" + Util.GetDateTime(txtdatefrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtdateTo.Text != "")
                {
                    sb.Append(" and DATE(bv.dtentry) <='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }
            dt1 = StockReports.GetDataTable(sb.ToString());
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