using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_Investigation_SampleTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtdeptname.Focus();
            BindGrid("");
            btnUpdate.Visible = false;
            bindContainerColor();
            BindContainer();
            BindColor();
        }
    }
    void BindContainer()
    {
        DataTable dt = StockReports.GetDataTable("SELECT  containername,Concat(ID,'#',color)ID FROM samplecontainer_master");
        ddlcontainername.DataSource = dt;
        ddlcontainername.DataTextField = "containername";
        ddlcontainername.DataValueField = "ID";
        ddlcontainername.DataBind();
        ddlcontainername.Items.Insert(0, new ListItem("select", ""));
    }
    void BindColor()
    {
        DataTable dt = StockReports.GetDataTable("SELECT  Distinct(color)color FROM samplecontainer_master ");
        ddlContainerColor.DataSource = dt;
        ddlContainerColor.DataTextField = "color";
        ddlContainerColor.DataValueField = "color";
        ddlContainerColor.DataBind();
        ddlContainerColor.Items.Insert(0, new ListItem("", ""));
        ddlContainerColor.Enabled = false;      
    }
    private void bindContainerColor()
    {
        DataTable dt = StockReports.GetDataTable("Select ColorCode,ColorName from colormaster order by ColorName");
        ddlContainerColor.DataSource = dt;
        ddlContainerColor.DataTextField = "ColorName";
        ddlContainerColor.DataValueField = "ColorCode";
        ddlContainerColor.DataBind();
        ddlContainerColor.Items.Insert(0, new ListItem("select", ""));
    }
    private void BindGrid(string testname)
    {
        txtdeptname.Text = "";
        txtdisplayname.Text = "";
        chkActive.Checked = true;
        //txtContainerName.Text = "";
        ddlContainerColor.SelectedIndex = 0;

        string query = "SELECT id ID,SampleType NAME,DisplayName,IsActive, IF(IsActive=1,'Active','Deactive') STATUS,Container,UPPER(ColorName)ColorName,UPPER(Color)Color FROM sample_Type  ";
        if (testname != "")
        {
            query += " where SampleType like '%" + testname + "%' ";
        }
        query += " order by SampleType";
        DataTable dt = StockReports.GetDataTable(query);
        GridView1.DataSource = dt;
        GridView1.DataBind();
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string status = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label3")).Text;
        string ID = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label1")).Text;
        if (status == "1")
        {
            StockReports.ExecuteDML("update  sample_Type set isactive='0' where ID='" + ID + "' ");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Deactivated Successfully');", true);
        }
        else
        {
            StockReports.ExecuteDML("update  sample_Type set isactive='1' where ID='" + ID + "' ");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Activated Successfully');", true);
        }

        // lblMsg.Text = "Record Updated..!";
       // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Updated Successfully');", true);
        BindGrid("");
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = ((Label)e.Row.FindControl("Label3")).Text;
            string Name = ((Label)e.Row.FindControl("Label2")).Text;
            LinkButton lb = (LinkButton)e.Row.FindControl("LinkButton2");

            if (status == "1")
            {
                lb.Text = "Deactive";
            }
            else
            {
                lb.Text = "Active";
            }
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)GridView1.SelectedRow.FindControl("Label1")).Text;
        string Name = ((Label)GridView1.SelectedRow.FindControl("Label2")).Text;
        string Status = ((Label)GridView1.SelectedRow.FindControl("Label3")).Text;
        string displayname = ((Label)GridView1.SelectedRow.FindControl("lbldisplayname")).Text;

        txtdeptname.Text = Name;
        txtdisplayname.Text = displayname;
        txtId.Text = ID;
        if (((Label)GridView1.SelectedRow.FindControl("lblContainer")).Text == "")
        {
            ddlcontainername.ClearSelection();
            ddlcontainername.Items.FindByText("select").Selected = true;
        }
        else
        {
            ddlcontainername.ClearSelection();
            ddlcontainername.Items.FindByText(((Label)GridView1.SelectedRow.FindControl("lblContainer")).Text).Selected = true;
        }

        try
        {
            ddlContainerColor.SelectedValue = ((Label)GridView1.SelectedRow.FindControl("lblColor")).Text.ToUpper();
        }
        catch
        {
            ddlContainerColor.Items.Insert(0, new ListItem(((Label)GridView1.SelectedRow.FindControl("lblColorName")).Text, ((Label)GridView1.SelectedRow.FindControl("lblColor")).Text.ToUpper()));
            ddlContainerColor.SelectedValue = ((Label)GridView1.SelectedRow.FindControl("lblColor")).Text.ToUpper();
        }
        if (Status == "1")
        {
            chkActive.Checked = true;
        }
        else
        {
            chkActive.Checked = false;
        }
        btnSave.Visible = false;
        btnUpdate.Visible = true;
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        BindGrid(txtsearch.Text);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        int st = chkActive.Checked ? 1 : 0;
        if (txtdeptname.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Sample Name');", true);
            return;
        }
        if (ddlcontainername.SelectedIndex == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Container');", true);
            return;
        }
        if (txtdisplayname.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Display Name');", true);
            return;
        }
        if (StockReports.ExecuteScalar("select SampleType from sample_Type where SampleType='" + txtdeptname.Text.Trim()+ "' ").ToString() == "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("insert into sample_Type (SampleType,DisplayName,IsActive, CreatedBy,Container,ColorName,Color)");
            sb.Append(" values ('" + txtdeptname.Text.ToUpper() + "','" + txtdisplayname.Text.ToUpper() + "','" + st + "','" + Util.GetString(Session["ID"]) + "','" + ddlcontainername.SelectedItem.Text + "','" + ddlContainerColor.SelectedItem + "','" + ddlContainerColor.SelectedValue + "')");
            StockReports.ExecuteDML(sb.ToString());

            // lblMsg.Text = "Record Saved";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
            BindGrid("");


            ddlContainerColor.SelectedIndex = 0;
            ddlcontainername.SelectedIndex = 0;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Sample Type Already Exist');", true);
            return;
        }

    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        string id = txtId.Text;

        int st = chkActive.Checked ? 1 : 0;

        if (txtdeptname.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Sample Name');", true);
            return;
        }
        if (ddlcontainername.SelectedIndex == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Container');", true);
            return;
        }
        if (txtdisplayname.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Display Name');", true);
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("update sample_Type set SampleType='" + txtdeptname.Text.ToUpper() + "',DisplayName='" + txtdisplayname.Text.ToUpper() + "' ");
        sb.Append(" ,Container='" + ddlcontainername.SelectedItem.Text + "',ColorName='" + ddlContainerColor.SelectedItem + "',Color='" + ddlContainerColor.SelectedValue + "'  ");
        sb.Append(",IsActive='" + st + "',UpdatedOn=now(),UpdatedByID='" + Util.GetString(Session["ID"]) + "',UpdatedBy='" + Util.GetString(Session["LoginName"]) + "' ");

        sb.Append(" where id='" + id + "'");

        StockReports.ExecuteDML(sb.ToString());

        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Updated Successfully');", true);
        //lblMsg.Text = "Record Updated";
        btnUpdate.Visible = false; 
        ddlContainerColor.SelectedIndex= 0; 
        ddlcontainername.SelectedIndex = 0;
        btnSave.Visible = true;

        txtId.Text = "";
        BindGrid("");
        txtdeptname.Focus();
    }
    protected void ddlcontainername_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlContainerColor.SelectedIndex = ddlContainerColor.Items.IndexOf(ddlContainerColor.Items.FindByText(ddlcontainername.SelectedValue.Split('#')[1].ToString()));
    }
}