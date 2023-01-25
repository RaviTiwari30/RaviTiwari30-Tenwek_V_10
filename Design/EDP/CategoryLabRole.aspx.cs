using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_CategoryLabRole : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string sb = "";

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (ddlLoginType.SelectedIndex != -1)
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from f_categoryrole where RoleID='" + ddlLoginType.SelectedItem.Value + "'");

                foreach (ListItem li in chkObservationType.Items)
                {
                    if (li.Selected)
                    {
                        sb = "Insert into f_categoryrole (ObservationType_ID,RoleID,ObservationTypeName,RoleName,CreatedBy,IPAddress)";
                        sb += "values('" + li.Value + "'," + ddlLoginType.SelectedValue + ",";
                        sb += "'" + li.Text + "','" + ddlLoginType.SelectedItem.Text + "','"+Session["ID"].ToString()+"','"+All_LoadData.IpAddress()+"')";
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb);
                    }
                }

                tranX.Commit();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            tranX.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSelectAll.Checked)
        {
            foreach (ListItem li in chkObservationType.Items)
            {
                li.Selected = true;
            }
            chkSelectAll.Text = "De-Select All";
        }
        else
        {
            foreach (ListItem li in chkObservationType.Items)
            {
                li.Selected = false;
            }
            chkSelectAll.Text = "Select All";
        }
    }

    protected void ddlLoginType_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadObservationTypes(ddlLoginType.SelectedItem.Value);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadRole();
        }
    }

    private void LoadObservationTypes(string RoleID)
    {
        string str = "SELECT om.Name,om.ObservationType_ID,IF(cr.ObservationType_ID IS NULL,'false','true')isExist FROM (SELECT * FROM observationtype_master )om LEFT JOIN (SELECT * FROM f_categoryrole WHERE roleID=" + RoleID + ") cr ON om.ObservationType_ID = cr.ObservationType_ID order by Name";

        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);
        chkObservationType.DataSource = dt;
        chkObservationType.DataTextField = "Name";
        chkObservationType.DataValueField = "ObservationType_ID";
        chkObservationType.DataBind();

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                foreach (ListItem li in chkObservationType.Items)
                {
                    if (dr["ObservationType_ID"].ToString() == li.Value)
                    {
                        li.Selected = Util.GetBoolean(dr["isExist"]);
                        break;
                    }
                }
            }
        }
    }

    private void LoadRole()
    {
        DataTable dt = All_LoadData.LoadRole();
        ddlLoginType.DataSource = dt;
        ddlLoginType.DataTextField = "RoleName";
        ddlLoginType.DataValueField = "ID";
        ddlLoginType.DataBind();

        if (ddlLoginType.Items != null && ddlLoginType.Items.Count > 0)
            LoadObservationTypes(ddlLoginType.SelectedItem.Value);
    }
}