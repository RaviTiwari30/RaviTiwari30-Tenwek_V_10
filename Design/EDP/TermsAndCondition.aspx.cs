using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Design_EDP_TermsAndCondition : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           btnUpdate.Visible = false;
           btnCancel.Visible = false;
            Search();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtName.Text=="")
        {
            lblMsg.Text = "Please Enter Name";
            txtName.Focus();
            rblType.SelectedIndex = 0;
            return;
        }
        if (Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_term_condition WHERE Terms='" + txtName.Text + "'")) > 0)
        {
            lblMsg.Text = "Name Already exist";
            txtName.Focus();
            txtName.Text = "";
            rblType.SelectedIndex = 0;
            return;
        }
      
        string str="";
        str = "insert into f_term_condition(Terms,Active,Created_By,Created_DateTime)values('" + txtName.Text + "','" + rblType.SelectedValue + "','" + Session["id"].ToString() + "',now())";
        StockReports.ExecuteDML(str);
        lblMsg.Text = "Record Saved Sucessfully";
        txtName.Text = "";
        
        Search();
    
    }
    private void Search()
    {
        string str = "SELECT Id,Terms,IF(Active=1,'Active','De-Active')Active,Active IsActive,Created_By,Created_DateTime FROM f_term_condition";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            grdTerms.DataSource = dt;
            grdTerms.DataBind();
           
        }

        else
        {
            grdTerms.DataSource = null;
            grdTerms.DataBind();
            
        }
    }
    protected void grdTerms_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        
        if (e.CommandName == "Edit")
        {
            txtName.Text = e.CommandArgument.ToString().Split('#')[0].ToString();
            rblType.SelectedIndex = rblType.Items.IndexOf(rblType.Items.FindByValue(e.CommandArgument.ToString().Split('#')[1].ToString()));
            ViewState["Id"] = e.CommandArgument.ToString().Split('#')[2].ToString();
            btnUpdate.Visible = true;
            btnCancel.Visible = true;
            btnSave.Visible   = false;
            lblMsg.Text = "";
        }
        if (e.CommandName == "Delete")
        {
           string str = "DELETE FROM f_term_condition WHERE Id=" + Util.GetInt(e.CommandArgument.ToString()) + "";
            StockReports.ExecuteDML(str);
            lblMsg.Text = "Record deleted Sucessfully";
            Search();
        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {

        if (Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_term_condition WHERE Terms='" + txtName.Text + "' and Active='" + rblType.SelectedValue + "'")) > 0)
        {
            lblMsg.Text = "Name Already exist";
            txtName.Focus();
            txtName.Text = "";
            return;
        }
        string str = "";
        str = "update f_term_condition set Terms='" + txtName.Text + "', Active='" + rblType.SelectedValue + "',Updated_By='" + Session["id"].ToString() + "',Updated_DateTime=now() where Id='" + ViewState["Id"].ToString() +"' ";
        StockReports.ExecuteDML(str);
        lblMsg.Text = "Record Updated Sucessfully";
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        btnCancel.Visible = false;
        txtName.Text = "";
        rblType.SelectedIndex = 0;
        
        Search();
    }
    protected void grdTerms_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

    }
    protected void grdTerms_RowEditing(object sender, GridViewEditEventArgs e)
    {

    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        txtName.Text = "";
        rblType.SelectedIndex = 0;
        lblMsg.Text = "";
    }
}