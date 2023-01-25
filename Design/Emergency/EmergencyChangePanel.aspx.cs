using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Emergency_EmergencyChangePanel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
            if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1)) == 0)
            {
               // Response.Redirect("../IPD/PatientBillMsg.aspx?msg=You are not authorized to change the panel.");
                //return;
            }
            ViewState["transactionID"] = Request.QueryString["TID"].ToString();
            ViewState["LedgerTnxNo"] = Request.QueryString["LTnxNo"].ToString();
            //if (AllLoadData_IPD.CheckDataPostToFinance(ViewState["LedgerTnxNo"].ToString()) > 0)
            //{
            //    string Msga = "Patient Final Bill Already Posted To Finance...";
            //    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msga);
            //}
            GetPanelAndBillingCategory(ViewState["transactionID"].ToString());
            bindpanel();
        }
    }
    private void GetPanelAndBillingCategory(string TID)
    {
       DataTable dt =  StockReports.GetDataTable("SELECT fpm.Company_Name,fpm.PanelID FROM patient_medical_history pmh INNER JOIN f_panel_master fpm ON fpm.PanelID=pmh.PanelID WHERE pmh.TransactionID='" + TID + "' ");
       if (dt.Rows.Count > 0)
       {
           lblcurrentpanel.Text = dt.Rows[0]["Company_Name"].ToString();
           lblcurrentpanelid.Text = dt.Rows[0]["PanelID"].ToString();
       }
    }
    private void bindpanel()
    {
        ddlPanel.DataSource = All_LoadData.LoadPanelOPD();
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.Items.Insert(0, new ListItem("Select", "0"));
        ddlPanel.DataBind();
    }
    protected void btnUpdatePanel_Click(object sender, EventArgs e)
    {
        if (lblcurrentpanelid.Text == ddlPanel.SelectedValue)
        {
            lblMsg.Text = "Kindly Change The Panel.";
            return;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try {
            string str = "UPDATE patient_medical_history pmh INNER JOIN f_ledgertransaction lt ON lt.TransactionID=pmh.TransactionID SET pmh.PanelID=" + ddlPanel.SelectedValue + ",lt.PanelID=" + ddlPanel.SelectedValue + ",pmh.Updatedate=NOW(),pmh.LastUpdatedBy='"+ Session["ID"].ToString() +"' WHERE pmh.TransactionID='" + ViewState["transactionID"].ToString() + "'";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
            Tnx.Commit();
            lblMsg.Text = "Panel Updated Successfully.";
            GetPanelAndBillingCategory(ViewState["transactionID"].ToString());
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}