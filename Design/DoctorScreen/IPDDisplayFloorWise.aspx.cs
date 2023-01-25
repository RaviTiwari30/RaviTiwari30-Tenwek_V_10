using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_DoctorScreen_IPDDisplayFloorWise : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {

            ddlFloor.DataSource = StockReports.GetDataTable(" SELECT NAME FROM floor_master where CentreID="+ Util.GetInt(Session["CentreID"]) + " ORDER BY SequenceNo ");
            ddlFloor.DataTextField = "NAME";
            ddlFloor.DataValueField = "NAME";
            ddlFloor.DataBind();
        }

    }
}