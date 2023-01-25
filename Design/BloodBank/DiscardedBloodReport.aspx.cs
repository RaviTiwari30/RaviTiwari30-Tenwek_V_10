using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_BloodBank_DiscardedBloodReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblerrmsg.Text = "Please Select Centre";
            return;
        }
        DataTable dt = new DataTable();
        dt = Search(Centre);
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + txtdiscardedfrom.Text + " To : " + txtdiscardedTo.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "DiscardedBloodReport";

             ds.WriteXmlSchema("E:/DiscardedBloodReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblerrmsg.Text = "Please Select Centre";
            return;
        }
        DataTable dt = new DataTable();
        dt = Search(Centre);
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
            txtdiscardedfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtdiscardedTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPrint);
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            btnPrint.Attributes.Add("onclick", String.Format("this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnPrint, String.Empty)));
        }
        txtdiscardedfrom.Attributes.Add("readOnly", "true");
        txtdiscardedTo.Attributes.Add("readOnly", "true");
    }

    private DataTable Search(string Centre)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  cm.CentreName,sm.Stock_id,sm.BloodCollection_ID,sm.BBTubeNo,sm.ComponentName,sm.bagtype,sm.DiscardedBy,sm.DiscardedDate,db.Reason,em.Name FROM bb_stock_master sm");
        sb.Append(" INNER JOIN bb_discardbloodstock db ON  sm.stock_id=db.stock_id INNER JOIN center_master cm ON db.CentreID=cm.CentreID INNER JOIN Employee_Master em ON em.EmployeeID=sm.DiscardedBy WHERE sm.IsDiscarded=1 AND db.IsDiscarded=1 and db.centreId in ("+Centre+") ");
        if (txtdiscardedfrom.Text != "")
        {
            sb.Append(" AND DATE(DiscardedDate) >='" + Util.GetDateTime(txtdiscardedfrom.Text).ToString("yyyy-MM-dd") + "' ");
        }
        if (txtdiscardedTo.Text != "")
        {
            sb.Append(" and DATE(DiscardedDate) <='" + Util.GetDateTime(txtdiscardedTo.Text).ToString("yyyy-MM-dd") + "'");
        }

        DataTable dt1 = StockReports.GetDataTable(sb.ToString());
        return dt1;
    }
}