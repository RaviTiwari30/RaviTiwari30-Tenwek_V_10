using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class Design_IPD_OrderSet_BloodTransfuse : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string OrderSetID = Request.QueryString["ID"].ToString();
            ViewState["ID"] = OrderSetID;
            string TID = Request.QueryString["TID"].ToString();
            ViewState["TransID"] = TID;
            string Groupid = Request.QueryString["GroupID"].ToString();
            ViewState["GroupID"] = Groupid;
            ViewState["Relational_ID"] = Request.QueryString["RelationalID"].ToString();
            calExpDate1.StartDate = DateTime.Now;
            calExpdateSection1.StartDate = DateTime.Now;
            txtTimeSection1.Text = System.DateTime.Now.ToString("hh:mm tt");
            txtBloodProductinitiated.Text = System.DateTime.Now.ToString("hh:mm tt");
            txtBloodProductterminated.Text = System.DateTime.Now.ToString("hh:mm tt");
            txtTimeSection3.Text = System.DateTime.Now.ToString("hh:mm tt");
            txtReactionNotedAt.Text = System.DateTime.Now.ToString("hh:mm tt");
            txtTransfusion.Text = System.DateTime.Now.ToString("hh:mm tt");
            txtAmounttransfused.Text = System.DateTime.Now.ToString("hh:mm tt");
            BloodGroup();
        }

    }
    private void  BloodGroup()
    {
        DataTable Blood=StockReports.GetDataTable("Select Id,BloodGroup from bb_bloodgroup_master where isActive=1");
        if(Blood.Rows.Count>0)
        {
            ddlPatientBloodGroup.DataSource=Blood;
            ddlPatientBloodGroup.DataTextField="BloodGroup";
            ddlPatientBloodGroup.DataValueField="ID";
            ddlPatientBloodGroup.DataBind();
            ddlDonorBloodGroup.DataSource = Blood;
            ddlDonorBloodGroup.DataTextField = "BloodGroup";
            ddlDonorBloodGroup.DataValueField = "ID";
            ddlDonorBloodGroup.DataBind();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

    }
}