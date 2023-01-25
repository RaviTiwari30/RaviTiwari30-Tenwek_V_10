using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Emergency_EMG_BedShift : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ViewState["LedgerTnxNo"] = Request.QueryString["LTnxNo"].ToString();
        if (Resources.Resource.AllowFiananceIntegration == "1")//
        {
            if (AllLoadData_IPD.CheckDataPostToFinance(ViewState["LedgerTnxNo"].ToString()) > 0)
            {
                string Msga = "Patient Final Bill Already Posted To Finance...";
                Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msga);
            }
        }
    }
}