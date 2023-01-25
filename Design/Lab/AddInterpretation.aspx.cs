using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_Lab_AddInterpretation : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindInvestigation();
        }
    }

    private void BindInvestigation()
    {
        var sb = new StringBuilder();
        sb.Append(" select inv.Name ,inv.Investigation_id from f_itemmaster im   ");
        sb.Append(" inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID  ");
        sb.Append(" inner join f_configrelation c on c.CategoryID=sc.CategoryID ");
        sb.Append(" inner join investigation_master inv on inv.Investigation_id=im.Type_id   ");
        sb.Append(" INNER JOIN investigation_observationtype io ON inv.Investigation_Id = io.Investigation_ID ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = io.ObservationType_ID ");
        sb.Append(" and c.configID='3' and inv.ReportType=1 and im.IsActive=1 AND cr.RoleID='" + Session["RoleID"] + "' order by inv.Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlInvestigation.DataSource = dt;
            ddlInvestigation.DataTextField = "Name";
            ddlInvestigation.DataValueField = "Investigation_id";
            ddlInvestigation.DataBind();
            ddlInvestigation.Items.Insert(0, "Select");
        }

        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Investigation Found');", true);
           // lblMsg.Text = "No Investigation Found";
    }

    protected void ddlObservation_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
    }

    protected void ddlInvestigation_SelectedIndexChanged(object sender, EventArgs e)
    {
        txtInvInterpretaion.Text = StockReports.ExecuteScalar("SELECT Interpretation FROM investigation_master WHERE Investigation_id='" + ddlInvestigation.SelectedValue + "'");
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            if (ddlInvestigation.SelectedIndex > 0)
                StockReports.ExecuteDML("update investigation_master set Interpretation='" + txtInvInterpretaion.Text + "' where Investigation_id='" + ddlInvestigation.SelectedValue + "'");
            else
            {
                // lblMsg.Text = "Please Select Investigation";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Investigation');", true);
                ddlInvestigation.Focus();
                return;
            }
            clearform();
            // lblMsg.Text = "Record saved Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record saved Successfully');", true);
        }
        catch (Exception ex)
        {
           // lblMsg.Text = "Error occurred, Please contact administrator";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }


    private void clearform()
    {
        txtInvInterpretaion.Text = "";
        ddlInvestigation.SelectedIndex = -1;
    }
}