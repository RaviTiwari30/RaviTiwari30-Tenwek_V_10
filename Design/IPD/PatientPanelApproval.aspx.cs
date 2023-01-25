using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;


public partial class Design_IPD_PatientPanelApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {

            if (Request.QueryString["TransactionID"] != null)
            {
                lblTransactionID.Text = Request.QueryString["TransactionID"].ToString();
                lblTID.Text = lblTransactionID.Text;
                lblPatientID.Text = Request.QueryString["PatientId"].ToString();
                   ExcuteCMD excuteCMD = new ExcuteCMD();


                   var panelID = excuteCMD.ExecuteScalar("SELECT ip.PanelID FROM patient_medical_history ip WHERE ip.TransactionID=@transactionID", new  //f_ipdadjustment
                   {
                       transactionID = lblTransactionID.Text
                   });

                lblPanelID.Text = Convert.ToString(panelID);
                if (panelID == 1)
                {
                    string Msg = "This Form Is Not For CASH Patient...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                }


              
                StringBuilder sqlCMD = new StringBuilder(" SELECT pm.ID,p.Company_Name , pm.PolicyNumber, pm.ApprovalAmount, ");
                sqlCMD.Append(" pm.ApprovalRemark,DATE_FORMAT(pm.EntryOn,'%d-%b-%Y') as Approval_Send_On ,CONCAT(em.Title,' ',em.Name) Create_By                  ");
                sqlCMD.Append(" FROM  panelapproval_emaildetails pm                                              ");
                sqlCMD.Append(" INNER JOIN employee_master em ON em.EmployeeID=pm.EntryBy                    ");
                sqlCMD.Append(" INNER JOIN  f_panel_master p ON p.PanelID=pm.PanelID WHERE pm.TransactionID=@transactionID ");


              var dt=  excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new {
                    transactionID = lblTransactionID.Text
                });

              grvPanelApprovalDetails.DataSource = dt;
              grvPanelApprovalDetails.DataBind();


            }
        }

        lblMsg.Text = "";

    }

    protected void grvPanelApprovalDetails_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        if (e.CommandName == "print")
        {
            int PreAuthID = Util.GetInt(e.CommandArgument.ToString());
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Dispatch/PreAuthPrintOut_pdf.aspx?PreAuthID=" + PreAuthID + "&Type=IPD');", true);
        }
    }
}