using System;
using System.Data;
using System.Web.UI;


public partial class Design_IPD_BillingRemarks : System.Web.UI.Page
{
   
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
            {
                ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            }
            LoadAdmissionRemark();
            LoadRemarks();
            
        }
    }

    private void LoadRemarks()
    {
        string str = "Select BillingRemarks from patient_medical_history where TransactionID='" + ViewState["TransactionID"].ToString() + "'";//f_ipdadjustment
        DataTable dt=new DataTable();
       dt = StockReports.GetDataTable(str);
       if (dt.Rows.Count > 0 && dt != null)
       {
           for (int i = 0; i < dt.Rows.Count; i++)
           {
               lblRemark.Text = dt.Rows[i]["BillingRemarks"].ToString();

               lblRemark.Text = lblRemark.Text.Replace("\r\n", "<br/>");
               pnlhide.Visible = true;
           }
       }
       else
       {
           pnlhide.Visible = false;
       }
    }
    private void LoadAdmissionRemark()
    {
        string strQry = "SELECT AdmissionReason As Remarks FROM patient_medical_history where TransactionID='" + ViewState["TransactionID"].ToString() + "'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(strQry);
        if (dt.Rows.Count > 0)
        {
            txtAdRemark.Text = dt.Rows[0]["Remarks"].ToString();
        }
    }




    protected void btnBillRemarks_Click(object sender, EventArgs e)
    {
        if (txtRemarks.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Billing Remarks";
            return;
        }
        try
        {
            lblMsg.Text = "";
            if (Request.QueryString["TransactionID"] != "" && Util.GetString(txtRemarks.Text) != "")
            {
                string BillingRemarks = "Date : " + DateTime.Now.ToString("dd-MMM-yyyy") + "   User : " + Util.GetString(Session["LoginName"]);
                BillingRemarks += System.Environment.NewLine + "Note :  " + Util.GetString(txtRemarks.Text);
                BillingRemarks += System.Environment.NewLine + System.Environment.NewLine;

                string str = "Update patient_medical_history Set BillingRemarks = concat(BillingRemarks,'" + BillingRemarks + "') where TransactionID='" + ViewState["TransactionID"].ToString() + "' ";//f_ipdadjustment
                StockReports.ExecuteDML(str);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);

                LoadRemarks();
                txtRemarks.Text = "";


            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}
   