using System;
using System.Web.UI.WebControls;

public partial class Design_HelpDesk_HelpDeskDoctor : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtName.Focus();
            All_LoadData.bindDocTypeList(ddlDepartment, 5, "ALL");
            All_LoadData.bindDocTypeList(ddlSpecialization, 3, "ALL");
            
        }
    }

    
    
}