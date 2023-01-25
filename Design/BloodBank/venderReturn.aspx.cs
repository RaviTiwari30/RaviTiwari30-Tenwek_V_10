using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_BloodBank_VenderReturn : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT sm.id,sm.stock_ID,cm.componentname,sm.componentid,(sm.InitialCount-sm.ReleaseCount)InitialCount, ");
        sb.Append(" sm.bagtype,sm.BloodCollection_Id,sm.BBTubeNo,DATE_FORMAT(sm.ExpiryDate,'%d-%b-%Y')ExpiryDate,");
        sb.Append(" sm.BloodGroup,DATE_FORMAT(sm.EntryDate,'%d-%b-%Y')EntryDate FROM bb_stock_master sm ");
        sb.Append("  INNER JOIN  bb_component_master cm ON cm.Id=sm.componentid ");
        sb.Append("   WHERE sm.IsActive=1   AND sm.InitialCount>sm.ReleaseCount  ");
        sb.Append("  AND sm.status=1 AND sm.IsDispatch=0 AND sm.IsDiscarded=0 AND sm.IsHold=0 ");
        if (ddlComponent.SelectedIndex != 0)
        {
            sb.Append(" AND sm.componentid='" + ddlComponent.SelectedItem.Value + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            //  grdSearchList.DataSource = dt;
            //  grdSearchList.DataBind();
        }
    }

    protected void grdSearchList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int index = Convert.ToInt32((e.CommandArgument));
        if (e.CommandName == "AResult")
        {
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BloodBank.bindComponent(ddlComponent);
        }
    }
}