using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_OT_MASTER_OT_Procedure_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtID.Visible = false;
            txtTempHeader.Visible = false;
            lbltemplateheader.Visible = false;
            btnSave.Visible = false;
            btnUpdate.Visible = true;
            LoadTemplates(ddlHeader.SelectedItem.Value);
        }
    }

    protected void grdHeader_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ADelete")
        {
            int index = Util.GetInt(e.CommandArgument);
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                string strQuery = "Delete from ot_procedure_template where ID=" + index + "";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
                Tranx.Commit();
                LoadTemplates(ddlHeader.SelectedItem.Value);
                btnSave.Visible = false;
                btnUpdate.Visible = true;
                lblMsg.Text = "Record Deleted Successfully";
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error occurred, Please contact administrator";
                Tranx.Rollback();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else if (e.CommandName == "AEdit")
        {
            lblMsg.Text = "";
            int index = Util.GetInt(e.CommandArgument);
            string sql = "select ID,Temp_Name,Template_Value from ot_procedure_template where ID='" + index + "'";
            DataTable dtHeader = StockReports.GetDataTable(sql);
            if (dtHeader.Rows.Count > 0)
            {
                ddlTemplates.SelectedIndex = ddlTemplates.Items.IndexOf(ddlTemplates.Items.FindByValue(dtHeader.Rows[0]["ID"].ToString()));
                txtDetail.Text = (dtHeader.Rows[0]["Template_Value"].ToString()).Replace("#", "'");
                txtTempHeader.Text = dtHeader.Rows[0]["Temp_Name"].ToString();
                txtID.Text = dtHeader.Rows[0]["ID"].ToString();
                btnSave.Visible = false;
                btnUpdate.Visible = true;
                txtTempHeader.Visible = false;
                lbltemplateheader.Visible = false;
            }
        }
    }

    public void saveData()
    {
        string sql = "select Temp_Name from ot_procedure_template where Temp_Name='" + txtTempHeader.Text.Trim() + "'";
        DataTable dtHeader = StockReports.GetDataTable(sql);
        if (dtHeader.Rows.Count > 0)
        {
            lblMsg.Text = "Templates Already exist.Please change Header Name..";
            txtTempHeader.Focus();
            return;
        }
        if (txtTempHeader.Text == string.Empty)
        {
            lblMsg.Text = "Please Enter Header Name..";
            txtTempHeader.Focus();
            return;
        }
        txtDetail.Text = txtDetail.Text.Replace("'", " ");
        if (txtDetail.Text == "<br>")
            txtDetail.Text = txtDetail.Text.Replace("<br>", "");
        else if (txtDetail.Text == "<BR>")
            txtDetail.Text = txtDetail.Text.Replace("<BR>", "");
        else if (txtDetail.Text == " <br> ")
            txtDetail.Text = txtDetail.Text.Replace(" <br> ", "");
        else if (txtDetail.Text == " <BR> ")
            txtDetail.Text = txtDetail.Text.Replace(" <BR> ", "");
        else if (txtDetail.Text == "<br /> ")
            txtDetail.Text = txtDetail.Text.Replace("<br/> ", "<br>");
        if (txtDetail.Text.Contains("<br />"))
            txtDetail.Text = txtDetail.Text.Replace("<br />", "<br>");
        if (txtDetail.Text.EndsWith("<BR></P>"))
        {
            int lenght = txtDetail.Text.Length;
            txtDetail.Text = txtDetail.Text.Substring(0, lenght - 8) + "</P>";
        }
        else if (txtDetail.Text.EndsWith("<BR>"))
        {
            int lenght = txtDetail.Text.Length;
            txtDetail.Text = txtDetail.Text.Substring(0, lenght - 4);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string strQuery = "Insert into ot_procedure_template(Headername,Template_Value,Temp_Name,UserID,CreatedDate) values('" + ddlHeader.SelectedItem.Value + "','" + (txtDetail.Text).Replace("'", "#") + "','" + txtTempHeader.Text.Trim() + "','" + Session["ID"].ToString() + "',NOW())";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
            Tranx.Commit();
            LoadTemplates(ddlHeader.SelectedItem.Value);
            txtTempHeader.Visible = false;
            lbltemplateheader.Visible = false;
            btnSave.Visible = false;
            btnUpdate.Visible = true; ;
            lblMsg.Text = "Record Saved Successfully";
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error occurred, Please contact administrator";
            Tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public void UpdateData()
    {
        txtTempHeader.Visible = false;
        lbltemplateheader.Visible = false;
        txtDetail.Text = txtDetail.Text.Replace("'", " ");
        if (txtDetail.Text == "<br>")
            txtDetail.Text = txtDetail.Text.Replace("<br>", "");
        else if (txtDetail.Text == "<BR>")
            txtDetail.Text = txtDetail.Text.Replace("<BR>", "");
        else if (txtDetail.Text == " <br> ")
            txtDetail.Text = txtDetail.Text.Replace(" <br> ", "");
        else if (txtDetail.Text == " <BR> ")
            txtDetail.Text = txtDetail.Text.Replace(" <BR> ", "");
        else if (txtDetail.Text == "<br /> ")
            txtDetail.Text = txtDetail.Text.Replace("<br/> ", "<br>");
        if (txtDetail.Text.Contains("<br />"))
            txtDetail.Text = txtDetail.Text.Replace("<br />", "<br>");
        if (txtDetail.Text.EndsWith("<BR></P>"))
        {
            int lenght = txtDetail.Text.Length;
            txtDetail.Text = txtDetail.Text.Substring(0, lenght - 8) + "</P>";
        }
        else if (txtDetail.Text.EndsWith("<BR>"))
        {
            int lenght = txtDetail.Text.Length;
            txtDetail.Text = txtDetail.Text.Substring(0, lenght - 4);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string strQuery = "Update ot_procedure_template set Template_Value='" + (txtDetail.Text).Replace("'", "#") + "',UpdatedBy='" + Session["ID"].ToString() + "',UpdatedDate=NOW() WHERE ID=" + Util.GetInt(txtID.Text.Trim()) + "  ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
            Tranx.Commit();
            LoadTemplates(ddlHeader.SelectedItem.Value);
            btnSave.Visible = false;
            btnUpdate.Visible = true;
            txtTempHeader.Visible = false;
            lbltemplateheader.Visible = false;
            lblMsg.Text = "Record Updated Successfully";
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error occurred, Please contact administrator";
            Tranx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void ddlHeader_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadTemplates(ddlHeader.SelectedItem.Value);
    }

    protected void ddlTemplates_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadTemplatesText(ddlTemplates.SelectedItem.Value);
        txtTempHeader.Text = ddlTemplates.SelectedItem.Text;
        txtID.Text = ddlTemplates.SelectedItem.Value;
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        txtTempHeader.Visible = false;
        lbltemplateheader.Visible = false;
    }

    private void LoadTemplates(string TempHeaderName)
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("Select Temp_Name,ID from ot_procedure_template Where HeaderName='" + TempHeaderName + "' order by Temp_Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlTemplates.DataSource = dt;
            ddlTemplates.DataTextField = "Temp_Name";
            ddlTemplates.DataValueField = "ID";
            ddlTemplates.DataBind();
            LoadTemplatesText(ddlTemplates.SelectedItem.Value);
            txtTempHeader.Text = ddlTemplates.SelectedItem.Text;
            txtID.Text = ddlTemplates.SelectedItem.Value;
            FillGrid();
        }
        else
        {
            ddlTemplates.Items.Clear();
            lblMsg.Text = "No Templates Available under " + ddlHeader.SelectedItem.Text;
            ddlTemplates.DataSource = null;
            ddlTemplates.DataBind();
            txtDetail.Text = "";
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        saveData();
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        UpdateData();
    }

    protected void btnNewProcedure_Click(object sender, EventArgs e)
    {
        txtDetail.Text = "";
        txtID.Text = "";
        txtTempHeader.Text = "";
        txtTempHeader.Visible = true;
        lbltemplateheader.Visible = true;
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        lblMsg.Text = "";
    }

    private void LoadTemplatesText(string ID)
    {
        int TempID = Util.GetInt(ID);
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("Select ID,Temp_Name AS HeaderName,Template_Value from ot_procedure_template Where ID=" + TempID + " order by Temp_Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            txtDetail.Text = (dt.Rows[0]["Template_Value"].ToString()).Replace("#", "'");
        }
        else
        {
            txtDetail.Text = "";
        }
    }

    private void FillGrid()
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("Select ID,Temp_Name AS HeaderName from ot_procedure_template order by Temp_Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdHeader.DataSource = dt;
            grdHeader.DataBind();
        }
        else
        {
            grdHeader.DataSource = null;
            grdHeader.DataBind();
        }
    }
}