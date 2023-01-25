using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Text;
public partial class Design_Controls_UCStoreReportSearchCriteria : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["CentreID"] = Session["CentreID"].ToString();
            ViewState["Dept"] = Session["DeptLedgerNo"].ToString();
            ViewState["EmpID"] = Session["ID"].ToString();
            txtdatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtdateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtdatefrom.Attributes.Add("readOnly", "true");
        txtdateTo.Attributes.Add("readOnly", "true");
    }
}