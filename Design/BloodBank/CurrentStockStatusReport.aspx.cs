using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_BloodBank_CurrentStockStatusReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblerrmsg.Text = "Please Select Centre";
            return;
        }
        DataTable dt = new DataTable();
        dt = search(Centre);
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + txtcollectionfrom.Text + " To : " + txtcollectionTo.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "CurrentStockStatusReport";

            //ds.WriteXmlSchema("E:/CurrentStockStatusReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblerrmsg.Text = "Please Select Centre";
            return;
        }
        DataTable dt = new DataTable();
        dt = search(Centre);
        if (dt.Rows.Count > 0)
        {
            grdStock.DataSource = dt;
            grdStock.DataBind();

            pnlHide.Visible = true;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
            grdStock.DataSource = null;
            grdStock.DataBind();
            pnlHide.Visible = false;
        }
    }

    protected void grdStock_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        lblerrmsg.Text = "";
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblerrmsg.Text = "Please Select Centre";
            return;
        }
        grdStock.PageIndex = e.NewPageIndex;
        search(Centre);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtcollectionfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtcollectionTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BloodBank.bindBagType(ddlBagType);
            ddlBagType.Items.Insert(0, "Select");
            Component();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPrint);
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            btnPrint.Attributes.Add("onclick", String.Format("this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnPrint, String.Empty)));
        }
        txtcollectionfrom.Attributes.Add("readOnly", "true");
        txtcollectionTo.Attributes.Add("readOnly", "true");
    }

    private void Component()
    {
        DataTable dt = StockReports.GetDataTable("Select ID,Componentname from bb_Component_master Where Active=1");
        if (dt.Rows.Count > 0)
        {
            ddlComponentName.DataSource = dt;
            ddlComponentName.DataTextField = "ComponentName";
            ddlComponentName.DataValueField = "ID";
            ddlComponentName.DataBind();
            ddlComponentName.Items.Insert(0, "Select");
        }
    }

    private DataTable search(string Centre)
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cm.CentreName, Stock_Id,BloodCollection_Id,BagType,BBTubeNo,BloodGroup,ComponentName,ComponentId,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate, ");
            sb.Append("  DATE_FORMAT(ExpiryDate,'%d-%b-%Y')ExpiryDate FROM bb_stock_master sm  INNER JOIN center_master cm ON sm.CentreID=cm.CentreID WHERE STATUS=1 AND IsDiscarded=0 AND IsDispatch=0 AND IsHold=0 AND ExpiryDate >= NOW() AND initialcount-releasecount>0 and sm.CentreID IN (" + Centre + ")");

            if (txtCollectionID.Text.Trim() != "")
            {
                sb.Append("AND BloodCollection_Id='" + txtCollectionID.Text.Trim() + "'");
            }
            if (ddlBagType.SelectedIndex != 0)
            {
                sb.Append(" AND BagType='" + ddlBagType.SelectedItem.Text + "'");
            }
            if (txtTubeNo.Text.Trim() != "")
            {
                sb.Append("AND BBTubeNo ='" + txtTubeNo.Text.Trim() + "'");
            }
            if (ddlComponentName.SelectedIndex != 0)
            {
                sb.Append(" AND ComponentId='" + ddlComponentName.SelectedItem.Value + "'");
            }
            if (txtCollectionID.Text == "" && txtTubeNo.Text.Trim() == "" && ddlBagType.SelectedIndex == 0 && ddlComponentName.SelectedIndex == 0)
            {
                if (chkDate.Checked)
                {
                    if (txtcollectionfrom.Text != "")
                    {
                        sb.Append(" AND EntryDate >='" + Util.GetDateTime(txtcollectionfrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    }
                    if (txtcollectionTo.Text != "")
                    {
                        sb.Append(" and EntryDate <='" + Util.GetDateTime(txtcollectionTo.Text).ToString("yyyy-MM-dd") + " 23:59:59'");
                    }
                }
            }
            sb.Append(" ORDER BY Id ");
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
    protected void btnStockreport_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = Reports();

        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + txtcollectionfrom.Text + " To : " + txtcollectionTo.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "BloodComponentIssuedReport";//Stockreport

            //ds.WriteXmlSchema("E:/CurrentStockStatusReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }

    }

    private DataTable Reports()
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt1 = new DataTable();
        sb.Append(" SELECT sm.ComponentName,sm.`ComponentID`, sm.BloodGroup FROM bb_stock_master sm  INNER JOIN center_master cm ON sm.CentreID=cm.CentreID AND STATUS=1 AND IsDiscarded=0 AND IsDispatch=0 AND ExpiryDate >= NOW() AND initialcount-releasecount>0 and  sm.CentreID=" + Session["CentreID"] + "  ORDER BY sm.ComponentName; ");

        dt1 = StockReports.GetDataTable(sb.ToString());

        return dt1;
    }
}