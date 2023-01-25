using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_BloodBank_ComponentReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = search();
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
            Session["ReportName"] = "ComponentReport";

            //ds.WriteXmlSchema("C:/ComponentReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        dt = search();
        if (dt.Rows.Count > 0)
        {
            grdComponent.DataSource = dt;
            grdComponent.DataBind();

            pnlHide.Visible = true;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
            grdComponent.DataSource = null;
            grdComponent.DataBind();
            pnlHide.Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtcollectionfrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtcollectionTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            btnSearch.Attributes.Add("onclick", String.Format("this.value='Please Wait...';this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnSearch, String.Empty)));
            btnPrint.Attributes.Add("onclick", String.Format("this.disabled = true; {0};", this.ClientScript.GetPostBackEventReference(btnPrint, String.Empty)));

        }
        txtcollectionfrom.Attributes.Add("readOnly", "true");
        txtcollectionTo.Attributes.Add("readOnly", "true");
    }

    private DataTable search()
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT bc.BloodCollection_Id,bc.Component_Id,bcm.ComponentName,bc.BagType,bc.Volumn,bc.CreatedBy,DATE_FORMAT(bc.CreatedDate,'%d-%b-%Y')CreatedDate,bc.ExpiryDate,em.Name FROM bb_component bc  ");
            sb.Append("  INNER JOIN bb_component_master bcm ON bcm.Id=bc.Component_Id INNER JOIN employee_master em ON em.EmployeeID=bc.CreatedBy Where bc.status=1 AND bc.CentreID=" + Util.GetInt(Session["CentreID"]) + "");

            if (txtCollectionID.Text.Trim() != "")
            {
                sb.Append(" AND bc.BloodCollection_Id='" + txtCollectionID.Text.Trim() + "'");
            }
            if (txtCollectionID.Text == "")
            {
                if (txtcollectionfrom.Text != "")
                {
                    sb.Append(" AND DATE(bc.CreatedDate) >='" + Util.GetDateTime(txtcollectionfrom.Text).ToString("yyyy-MM-dd") + "' ");
                }
                if (txtcollectionTo.Text != "")
                {
                    sb.Append(" and DATE(bc.CreatedDate) <='" + Util.GetDateTime(txtcollectionTo.Text).ToString("yyyy-MM-dd") + "'");
                }
            }
            sb.Append(" ORDER BY bcm.Id ");
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