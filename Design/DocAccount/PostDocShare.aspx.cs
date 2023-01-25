using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class Design_DocAccount_PostDocShare : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindShareDoctorList(ddlDoctor, 0, "ALL");
        }
    }

}