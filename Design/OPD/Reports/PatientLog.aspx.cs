using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_PatientLog : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindUsers();
        }
    }

    protected void BindUsers()
    {
        MySqlConnection cn = Util.GetMySqlCon();
        cn.Open();
        DataSet ds = new DataSet();
        MySqlDataAdapter adp = new MySqlDataAdapter();

        string query = "SELECT Employee_ID,CONCAT(Title,NAME)NAME FROM Employee_master";
        using (MySqlCommand cmd = new MySqlCommand(query, cn))
        {
            cmd.CommandType = CommandType.Text;
            adp.SelectCommand = cmd;
            adp.Fill(ds);
        }

        int rowcount;
        rowcount = ds.Tables[0].Rows.Count;
        if (rowcount > 0)
        {
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                ddlUsers.DataSource = ds;
                ddlUsers.DataTextField = "NAME";
                ddlUsers.DataValueField = "Employee_ID";
                ddlUsers.DataBind();
                ddlUsers.Items.Insert(0, new ListItem("All", "0"));
            }
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable dtSearch = AllLoadData_OPD.SearchpatientLog(Util.GetDateTime(txtfromDate.Text), Util.GetDateTime(txtToDate.Text), txtPatientName.Text, txtPatientID.Text, ddlUsers.SelectedValue);
        if (dtSearch != null && dtSearch.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dtSearch;
            Session["ReportName"] = "PatientLog";
            Session["Period"] = "From : " + Util.GetDateTime(txtfromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Data not found";
        }
    }
}