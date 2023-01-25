using System;

public partial class Design_IPD_UpdatePatientDischarge : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_IPD.bindDischargeType(cmbDischargeType);
        }
    }
}