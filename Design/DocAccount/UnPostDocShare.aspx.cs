using System;

public partial class Design_DocAccount_UnPostDocShare : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindShareDoctorList(ddlDoctor, 1, "ALL");
        }
    }
}