using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_Anatomic_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
        }
    }

    private void BindGrid()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT iam.id,iam.AnatomicName,DATE_FORMAT(iam.CreatedDateTIme, '%d-%M-%Y %h:%i %p')CreatedDateTIme,DATE_FORMAT(iam.UpdatedDateTime,'%d-%M-%Y %h:%i %p') ");
        sb.Append(" UpdatedDateTime,CONCAT(emp.`Title`,'',emp.`NAME`)`NAME`,(CASE WHEN iam.IsActive = 1 THEN 'Yes' ELSE 'No' END)IsActive FROM Investigaion_AnatomicMaster ");
        sb.Append(" iam INNER JOIN employee_master emp ON iam.CreatedBy = emp.`EmployeeID` ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grdPanel.DataSource = dt;
        grdPanel.DataBind();
        txtAnatomicName.Text = "";

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string IsActive = string.Empty;
        if (btnYes.Checked)
        {
            IsActive = "1";
            
        }
        else if (btnNo.Checked)
        {
            IsActive = "0";
        }

        //MySqlConnection con = new MySqlConnection();
        //con = Util.GetMySqlCon();
        //con.Open();
        //MySqlTransaction tranX = con.BeginTransaction();

        if (txtAnatomicName.Text.Trim() == "")
        {

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "modelAlert('Please Enter Anatomic Name')", true);
            return;
        }

        int isExist = Util.GetInt( StockReports.ExecuteScalar("Select Count(*) From Investigaion_AnatomicMaster where AnatomicName= '" + txtAnatomicName.Text.Trim() + "'"));
        if (isExist > 0)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "modelAlert('Anatomic Name Alreat Exists')", true);
            return;
        }
        try 
        {
            MySqlConnection con = Util.GetMySqlCon();

            if (lblAnatomicID.Text == "")
            {              

                MySqlCommand cmd = new MySqlCommand("Insert_AnatomicDetails", con);

                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("vAnatomicName", txtAnatomicName.Text);
                cmd.Parameters.AddWithValue("vIsActive", IsActive);
                cmd.Parameters.AddWithValue("vCreatedDateTIme", Util.GetDateTime(System.DateTime.Now));
                cmd.Parameters.AddWithValue("vCreatedBy", Session["ID"].ToString());

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
                lblAnatomicID.Text = "";
                BindGrid();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "modelAlert('Record Save Successfully')", true);
                btnYes.Checked = true;
                btnNo.Checked = false; 

            }
            else
            {
               
                MySqlCommand cmd = new MySqlCommand("Update_AnatomicDetails", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("vAnatomicName", txtAnatomicName.Text);
                cmd.Parameters.AddWithValue("vIsActive", IsActive);
                cmd.Parameters.AddWithValue("vUpdatedDateTime", Util.GetDateTime(System.DateTime.Now));
                cmd.Parameters.AddWithValue("vUpdatedBy", Session["ID"].ToString());
                cmd.Parameters.AddWithValue("vID", hdnId.Value.ToString());

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
                lblAnatomicID.Text = "";
                BindGrid();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "modelAlert('Record Update Successfully')", true);
                btnSave.Text = "Save";
                btnYes.Checked = true;
                btnNo.Checked = false;   
               
            }
            
        }

        catch (Exception ex)
        {           
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            lblMsg.Text = "Error..";

        }
       
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
    //    txtAnatomicName.Text = "";
    //    btnYes.Checked = true;
    //    btnNo.Checked = false;
    //    btnSave.Text = "Save";
          Response.Redirect("Anatomic_Master.aspx");
    }

    protected void grdPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        string IsActive = ((Label)grdPanel.SelectedRow.FindControl("LblIsActive")).Text;
        if (IsActive == "No")
        {
            btnYes.Checked = false;
            btnNo.Checked = true;
        }
        else if (IsActive == "Yes")
        {
            btnNo.Checked = false;
            btnYes.Checked = true;
        }

        IsActive = ((Label)grdPanel.SelectedRow.FindControl("LblIsActive")).Text;
        txtAnatomicName.Text = ((Label)grdPanel.SelectedRow.FindControl("lblAnatomicName")).Text;        

        btnSave.Text = "Update";
        lblAnatomicID.Text = ((Label)grdPanel.SelectedRow.FindControl("lblAnatomicName")).Text;
        hdnId.Value = ((Label)grdPanel.SelectedRow.FindControl("lblsrNo")).Text;

    }
}