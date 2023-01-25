using System;
using System.Data;
using System.Text;

public partial class Design_Token_ShowTokenScreen : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindDocDepartment();
            BindRadiologyDepartment();
            BindLaboratoryDepartment();
        }
    }

    private void bindDocDepartment()
    {
        DataTable docDept = StockReports.GetDataTable("Select ID,Name From type_master WHERE TypeID =5 ORDER BY NAME");
        if (docDept.Rows.Count > 0)
        {
            chkDocDepartment.DataSource = docDept;
            chkDocDepartment.DataTextField = "Name";
            chkDocDepartment.DataValueField = "ID";
            chkDocDepartment.DataBind();
        }
    }
    protected void BindRadiologyDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" +Resources.Resource.RadiologyRoleId + "' ");
        sb.Append(" order by ot.Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            chkRadioDepartment.DataSource = dt;
            chkRadioDepartment.DataValueField = "ObservationType_ID";
            chkRadioDepartment.DataTextField = "Name";
            chkRadioDepartment.DataBind();
            //chkRadioDepartment.Items.Insert(0, "All");
        }
    }
    protected void BindLaboratoryDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='" + Resources.Resource.LaboratoryRoleId + "' ");
        sb.Append(" order by ot.Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ChkLaboratorydepartment.DataSource = dt;
            ChkLaboratorydepartment.DataValueField = "ObservationType_ID";
            ChkLaboratorydepartment.DataTextField = "Name";
            ChkLaboratorydepartment.DataBind();
            //chkRadioDepartment.Items.Insert(0, "All");
        }
    }

}