using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;

public partial class Design_Finance_OPDBillEdit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //ceFromDate.EndDate = ceToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
        if (dtAuthority.Rows.Count > 0)
        {
            if (dtAuthority.Rows[0]["CanChangePanel"].ToString() != "")
            {
                lblCanChangePanel.Text = dtAuthority.Rows[0]["CanChangePanel"].ToString();
            }
            else
            {
                lblCanChangePanel.Text = "0";
            }
            if (dtAuthority.Rows[0]["CanEditBill"].ToString() != "")
            {
                lblCanEditBill.Text = dtAuthority.Rows[0]["CanEditBill"].ToString();
            }
            else
            {
                lblCanEditBill.Text = "0";
            }
            if (dtAuthority.Rows[0]["CanChangeRelation"].ToString() != "")
            {
                lblCanChangeRelation.Text = dtAuthority.Rows[0]["CanChangeRelation"].ToString();
            }
            else
            {
                lblCanChangeRelation.Text = "0";
            }
            if (dtAuthority.Rows[0]["CanUploadPanelDocuments"].ToString() != "")
            {
                lblCanUploadPanelDocuments.Text = dtAuthority.Rows[0]["CanUploadPanelDocuments"].ToString();
            }
            else
            {
                lblCanUploadPanelDocuments.Text = "0";
            }
        }
        else
        {
            lblCanChangeRelation.Text = "0";
            lblCanEditBill.Text = "0";
            lblCanChangePanel.Text = "0";
        }
    }
}