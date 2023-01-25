using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
using System.Text;
using System.Web;
using System.Web.UI;


public partial class Design_IPD_BloodStockCPOE : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
                ViewState["ID"] = Session["ID"].ToString();          
                ucDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                toDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                caltoDate.EndDate = DateTime.Now;            
                BloodBank.bindBagType(ddlBagType);
                Component();
                btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
                btnPrint.Attributes.Add("onclick", String.Format("this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnPrint, String.Empty)));
        }
        ucDate.Attributes.Add("readOnly", "true");
        toDate.Attributes.Add("readOnly", "true");
    } 

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = search();
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + ucDate.Text + " To : " + toDate.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "CurrentStockStatusReport";

            //ds.WriteXmlSchema("C:/CurrentStockStatusReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = search();
        if (dt.Rows.Count > 0)
        {
            grdStock.DataSource = dt;
            grdStock.DataBind();

            pnlHide.Visible = true;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            grdStock.DataSource = null;
            grdStock.DataBind();
            pnlHide.Visible = false;
        }
    }

    protected void grdStock_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdStock.PageIndex = e.NewPageIndex;
        search();
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

    private DataTable search()
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT Stock_Id,BloodCollection_Id,BagType,BBTubeNo,BloodGroup,ComponentName,ComponentId,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate, ");
            sb.Append("  DATE_FORMAT(ExpiryDate,'%d-%b-%Y')ExpiryDate FROM bb_stock_master WHERE STATUS=1 AND IsDiscarded=0 AND IsDispatch=0 AND IsHold=0 AND DATE(ExpiryDate)>=CURDATE() AND initialcount-releasecount>0 ");

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
                if(ucDate.Text != "")
                {
                    sb.Append(" AND DATE(EntryDate) >='" + Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (toDate.Text != "")
                {
                    sb.Append(" and DATE(EntryDate) <='" + Util.GetDateTime(toDate.Text).ToString("yyyy-MM-dd") + "'");
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

}
