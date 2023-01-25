using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_BabyChart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtEDDBydates.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtBookingdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtGestationDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtExaminatioDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            string TID = Request.QueryString["TransactionID"].ToString();
            string MotherTID = StockReports.ExecuteScalar("SELECT motherTID FROM patient_medical_history WHERE TransactionID='" + TID + "' limit 1");
            if (MotherTID == "")
            {
               // Page.ClientScript.RegisterStartupScript(this.GetType(), "blockPage", "$(function () { onBlockUI(function(){});});", true);
            }
        }
    }
    protected void btnprint_Click(object sender, EventArgs e)
    {
        string TransactionID = Request.QueryString["TransactionID"].ToString();
        if (TransactionID != "")
        {
             int count = Util.GetInt(StockReports.ExecuteScalar("Select COUNT(*) From baby_chart where TransactionID='" + TransactionID + "'  "));
             if (count > 0)
             {
                 ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow1", "window.open('BabyChartReport.aspx?TransactionID=" + TransactionID.Trim() + " ');", true);
             }
             else
             {
                 ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Data Not Available For Print.');", true);
             }
           }
    }
}