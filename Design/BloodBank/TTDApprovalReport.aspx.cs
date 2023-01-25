using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_BloodBank_TTDApprovalReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = search();
        if (dt != null && dt.Rows.Count > 0)
        {
            //lblerrmsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";
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
            Session["ReportName"] = "TTDApprovalReport";

            // ds.WriteXmlSchema("C:/TTDApprovalReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = search();
        if (dt.Rows.Count > 0)
        {
            //lblerrmsg.Text = "Total " + dt.Rows.Count + " Record Founds";
            grdTTDRecord.DataSource = dt;
            grdTTDRecord.DataBind();
            pnlhide.Visible = true;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
            //lblerrmsg.Text = "No Record Founds";
            grdTTDRecord.DataSource = null;
            grdTTDRecord.DataBind();
            pnlhide.Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BloodBank.bindResult(ddlResult);
            BloodBank.bindMethod(ddlMethod);
            ddlMethod.Items.Insert(0, new ListItem("Select", "0"));
            txtdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            //EntryDate1.SetCurrentDate();
            //EntryDate2.SetCurrentDate();
            txtCollectionID.Focus();
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
            sb.Append(" SELECT cd.BloodCollection_Id,bs.method,bm.testName,bs.value,bs.result,DATE_FORMAT(bs.ApprovedDate,'%d-%b-%Y')ApprovedDate,       CONCAT(em1.Title,em1.name)ApprovedBy, ");
            sb.Append(" CONCAT(em.Title,em.name)CollectedBy,DATE_FORMAT(cd.CollectedDate,'%d-%b-%Y')CollectedDate FROM bb_blood_screening bs INNER JOIN bb_collection_details cd ON cd.BloodCollection_Id=bs.BloodCollection_Id ");
            sb.Append(" INNER JOIN bb_BloodTests_master BM ON bs.TestName=BM.Id  INNER JOIN employee_master em ON em.EmployeeId=cd.collectedby ");
            sb.Append(" LEFT OUTER JOIN employee_master em1 ON em1.EmployeeId=bs.ApprovedBy WHERE bs.isApproved=3 AND bs.IsActive=1 ");
            if (txtCollectionID.Text != "")
            {
                sb.Append(" AND cd.BloodCollection_Id='" + txtCollectionID.Text.Trim() + "'");
            }
            if (ddlMethod.SelectedIndex != 0)
            {
                sb.Append(" AND bs.method='" + ddlMethod.SelectedItem.Text + "'");
            }
            if (ddlResult.SelectedIndex != 0)
            {
                sb.Append(" AND bs.result='" + ddlResult.SelectedItem.Text + "'");
            }
            if (txtCollectionID.Text == "" && ddlMethod.SelectedIndex == 0 && ddlResult.SelectedIndex == 0)
            {
                if (txtdatefrom.Text != "")
                {
                    sb.Append(" AND DATE(cd.CollectedDate)>='" + Util.GetDateTime(txtdatefrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtdateTo.Text != "")
                {
                    sb.Append(" and DATE(cd.CollectedDate)<='" + Util.GetDateTime(txtdateTo.Text).ToString("yyyy-MM-dd") + "'");
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