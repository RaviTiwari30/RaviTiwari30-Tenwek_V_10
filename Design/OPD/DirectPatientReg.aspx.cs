using System;
using System.Web.UI.HtmlControls;

public partial class Design_OPD_DirectPatientReg : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       // ((HtmlGenericControl)PatientInfo.FindControl("divApp")).Attributes.Add("style", "display:none");
        if (!IsPostBack)
        {
            ViewState["IsDiscount"] = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "IsDiscount");
        }
    }
}