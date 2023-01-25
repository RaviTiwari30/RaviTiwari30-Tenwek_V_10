using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_BloodBank_BloodPost : System.Web.UI.Page
{
    protected void bindBloodGroup()
    {
        string str = "SELECT id,bloodgroup FROM bb_BloodGroup_master WHERE IsActive=1 AND bloodgroup<>' NA' order by bloodgroup";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlBloodGroup.DataSource = dt;
        ddlBloodGroup.DataTextField = "bloodgroup";
        ddlBloodGroup.DataValueField = "id";
        ddlBloodGroup.DataBind();
        ddlBloodGroup.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void BindComponent()
    {
        string str = "SELECT ComponentName,AliasName FROM bb_component_master  WHERE active='1'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlComponent.DataSource = dt;
        ddlComponent.DataTextField = "ComponentName";
        ddlComponent.DataValueField = "AliasName";
        ddlComponent.DataBind();
        ddlComponent.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void bindOrganisation()
    {
        string str = "SELECT organisaction,id FROM bb_organisation_master WHERE IsActive=1  order by Id";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlOrg.DataSource = dt;
        ddlOrg.DataTextField = "organisaction";
        ddlOrg.DataValueField = "id";
        ddlOrg.DataBind();
        ddlOrg.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdhide.Visible = false;
        DataTable dt = new DataTable();
        dt = search();
        if (dt.Rows.Count > 0)
        {
            pnlgrdStock.Visible = true;
            grdStock.DataSource = dt;
            grdStock.DataBind();
        }
        else
        {
            pnlgrdStock.Visible = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            grdStock.DataSource = null;
            grdStock.DataBind();
        }
    }

    protected void grdStock_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "View")
        {
            grdhide.Visible = true;
            string bloodcollectionid = e.CommandArgument.ToString();
            DataTable dt1 = new DataTable();
            StringBuilder sb = new StringBuilder();
            try
            {
                sb.Append("Select ComponentName,BagType,BloodGroup,BBtubeno,Rate,DATE_FORMAT(Entrydate,'%d-%b-%Y')Entrydate,DATE_FORMAT(expirydate,'%d-%b-%Y')expirydate from bb_stock_master where BloodCollection_Id='" + bloodcollectionid + "'");
                dt1 = StockReports.GetDataTable(sb.ToString());
                if (dt1.Rows.Count > 0)
                {
                    grdStockDetails.DataSource = dt1;
                    grdStockDetails.DataBind();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
                    grdStockDetails.DataSource = null;
                    grdStockDetails.DataBind();
                    grdhide.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ClassLog c1 = new ClassLog();
                c1.errLog(ex);
                grdStockDetails.DataSource = null;
                grdStockDetails.DataBind();
                grdhide.Visible = false;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            bindBloodGroup();
            BindComponent();
            bindOrganisation();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    private DataTable search()
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Select bb_directstockID,Bill_no,DATE_FORMAT(billdate,'%d-%b-%Y')billdate,Organisation,emp.name CreatedBy,DATE_FORMAT(bsp.CreatedDate,'%d-%b-%Y')CreatedDate from bb_stockpost bsp INNER JOIN bb_stock_master bsm ON bsm.bloodcollection_id=bsp.bb_directstockID inner join employee_master emp on emp.employeeid=bsp.CreatedBy Where bsp.Status=1 and bsm.CentreID="+Util.GetInt(Session["CentreID"].ToString())+"");
            if (ddlOrg.SelectedItem.Text != "Select")
            {
                sb.Append("  And Organisation='" + ddlOrg.SelectedItem.Text.Trim() + "'");
            }
            if (ddlBloodGroup.SelectedItem.Text != "Select")
            {
                sb.Append("  And bsm.bloodgroup='" + ddlBloodGroup.SelectedItem.Text + "'");
            }
            if (ddlComponent.SelectedItem.Text != "Select")
            {
                sb.Append("  And bsm.ComponentName like '%" + ddlComponent.SelectedItem.Text.Trim() + "%'");
            }
            if (txtbatchno.Text.Trim() != "")
            {
                sb.Append("  And bsm.batchno like '%" + txtbatchno.Text.Trim() + "%'");
            }
            if (ddlOrg.SelectedItem.Text == "Select" && ddlBloodGroup.SelectedItem.Text == "Select" && ddlComponent.SelectedItem.Text == "Select" && txtbatchno.Text.Trim() == "")
            {
                sb.Append(" and  DATE(bsp.CreatedDate) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
                sb.Append(" and DATE(bsp.CreatedDate) <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append("   GROUP BY bsp.bb_directstockID");
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