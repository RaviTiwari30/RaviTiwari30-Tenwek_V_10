using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Payroll_DesignationMaster : System.Web.UI.Page
{
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        btnSave.Visible = true; ;
        btnUpdate.Visible = false; ;
        btnCancel.Visible = false;
        Clear();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtDesignation.Text == "")
        {
        }
        if (ValidateName(txtDesignation.Text))
        {
            string Query = "insert into pay_designation_master(Designation_Name,LetterNo,RefNo,CL,EL,Grade)values('" + txtDesignation.Text.Replace("'", "''") + "','" + txtLetterNo.Text + "','" + txtRef.Text.Trim() + "','" + txtCL.Text.Trim() + "','" + txtEL.Text.Trim() + "','" + ddlGrade.SelectedItem.Text + "')";
            StockReports.ExecuteDML(Query);
            //  lblmsg.Text = "Record Save.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            BindData();
            Clear();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM061','" + lblmsg.ClientID + "');", true);
            // lblmsg.Text = "Designation Already Exist.";
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (ValidateNameUpdate(txtDesignation.Text))
        {
            string Query = "update pay_designation_master set Designation_Name='" + txtDesignation.Text.Replace("'", "''") + "',LetterNo=" + Util.GetInt(txtLetterNo.Text) + ",RefNo='" + Util.GetInt(txtRef.Text.Trim()) + "',CL='" + txtCL.Text.Trim() + "',EL='" + txtEL.Text.Trim() + "',Grade='" + ddlGrade.SelectedItem.Text + "' where Des_ID=" + ViewState["Des_ID"].ToString() + " ";
            StockReports.ExecuteDML(Query);
            //lblmsg.Text = "Record Updated.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);

            BindData();
            Clear();
            btnSave.Visible = true; ;
            btnUpdate.Visible = false; ;
            btnCancel.Visible = false;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM061','" + lblmsg.ClientID + "');", true);
            //lblmsg.Text = "Designation Already Exist.";
        }
    }

    protected void Clear()
    {
        //txtLetterNo.Text = "";
        //txtEL.Text = "";
        txtDesignation.Text = "";
        //txtRef.Text = "";
        //txtCL.Text = "";
        ddlGrade.SelectedIndex = 0;
    }

    protected void EmpGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        EmpGrid.PageIndex = e.NewPageIndex;
        EmpGrid.DataBind();
        BindData();
    }

    protected void EmpGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        btnCancel.Visible = true;
        string[] s = ((Label)EmpGrid.SelectedRow.FindControl("lblrecord")).Text.Split('#');
        ViewState["Des_ID"] = s[0].ToString();
        ViewState["Name"] = s[1].ToString();
        txtDesignation.Text = s[1].ToString();
        txtLetterNo.Text = s[2].ToString();
        txtRef.Text = s[3].ToString();

        txtCL.Text = s[4].ToString();
        txtEL.Text = s[5].ToString();
        ddlGrade.SelectedIndex = ddlGrade.Items.IndexOf(ddlGrade.Items.FindByText(s[6].ToString()));
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            btnSave.Visible = true; ;
            btnUpdate.Visible = false; ;
            btnCancel.Visible = false;
            BindData();
            AllLoadDate_Payroll.BindGradePay(ddlGrade);
        }
    }

    protected bool ValidateName(string Name)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_designation_master where Designation_name='" + Name + "'"));
        if (i > 0)
        { return false; }
        else
        { return true; }
    }

    protected bool ValidateNameUpdate(string Name)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from pay_designation_master where Designation_name !='" + ViewState["Name"].ToString() + "' AND Designation_name='" + Name + "'"));
        if (i > 0)
        { return false; }
        else
        { return true; }
    }

    private void BindData()
    {
        EmpGrid.DataSource = StockReports.GetDataTable("select * from pay_designation_master ");
        EmpGrid.DataBind();
    }
}