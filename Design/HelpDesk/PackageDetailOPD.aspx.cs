using System;

public partial class Design_HelpDesk_PackageDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_OPD.BindOPDPackage(ddlPackageName);
        }
    }
}