
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_Emergency_EMG_BillingDetails1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["transactionID"] = Request.QueryString["TID"].ToString();
            ViewState["LedgerTnxNo"] = Request.QueryString["LTnxNo"].ToString();
	   if (Session["ID"].ToString() != "LSHHI446")
            {
                if (Resources.Resource.AllowFiananceIntegration == "1")//
                {
                    if (AllLoadData_IPD.CheckDataPostToFinance(ViewState["LedgerTnxNo"].ToString()) > 0)
                    {
                        string Msga = "Patient Final Bill Already Posted To Finance...";
                        Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msga);
                    }
                }
		}
            txtDeathofDate.Text= DateTime.Now.ToString("dd-MMM-yyyy");
            caldate.EndDate = DateTime.Now;
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            AllLoadData_IPD.bindDischargeType(ddlReleaseType);
            ddlReleaseType.Items.Add(new ListItem("Patient Discharge Without Bill", "Patient Discharge Without Bill"));
            ddlReleaseType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            AllLoadData_IPD.bindTypeOfDeath(ddltypeOfDeath);
        }
        txtDeathofDate.Attributes.Add("readOnly", "readOnly");
    }
}