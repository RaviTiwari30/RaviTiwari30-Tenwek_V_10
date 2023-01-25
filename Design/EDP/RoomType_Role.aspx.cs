using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_RoomType_Role : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (ddlLoginType.SelectedIndex != -1)
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from f_RoomType_role where Role_ID='" + ddlLoginType.SelectedItem.Value + "' AND FloorID ='" + ddlFloor.SelectedItem.Value + "' ");

                foreach (ListItem li in chkObservationType.Items)
                {
                    if (li.Selected)
                    {
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO f_RoomType_role (IPDCaseTypeID,Role_ID,CreatedBy,IPAddress,FloorID)VALUES('" + li.Value + "'," + ddlLoginType.SelectedValue + ",'" + Session["ID"].ToString() + "','" + HttpContext.Current.Request.UserHostAddress + "','" + ddlFloor.SelectedItem.Value + "') ");
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
        LoadObservationTypes(ddlLoginType.SelectedItem.Value, ddlFloor.SelectedItem.Value, ddlFloor.SelectedItem.Text);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadRole();
            AllLoadData_IPD.bindFloor(ddlFloor, "Select");
            if (ddlFloor.Items != null && ddlFloor.Items.Count > 0)
                LoadObservationTypes(ddlLoginType.SelectedItem.Value, ddlFloor.SelectedItem.Value, ddlFloor.SelectedItem.Text);
        }
    }

    private void LoadObservationTypes(string Role_ID, string FloorID, string Floor)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT ipd.IPDCaseTypeID,ipd.Name,IF(Rr.Role_ID IS NULL AND Rr.FloorID IS NULL,'false','true')isExist FROM");
        sb.Append(" (SELECT ict.IPDCaseTypeID,ict.Name FROM ipd_case_type_master ict Inner Join room_master rm on rm.IPDCaseTypeID=ict.IPDCaseTypeID WHERE ict.isActive=1 AND rm.Floor='" + Floor + "' group by ict.IPDCaseTypeID) ipd");
        sb.Append(" LEFT JOIN ");
        sb.Append(" (SELECT Role_ID,IPDCaseTypeID,FloorID FROM f_RoomType_role WHERE Role_ID=" + Role_ID + " AND FloorID=" + FloorID + " ) Rr");
        sb.Append(" ON Rr.IPDCaseTypeID=ipd.IPDCaseTypeID");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            chkObservationType.DataSource = dt;
            chkObservationType.DataTextField = "NAME";
            chkObservationType.DataValueField = "IPDCaseTypeID";
            chkObservationType.DataBind();

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    foreach (ListItem li in chkObservationType.Items)
                    {
                        if (dr["IPDCaseTypeID"].ToString() == li.Value)
                        {
                            li.Selected = Util.GetBoolean(dr["isExist"]);
                            break;
                        }
                    }
                }
            }
        }
        else
        {
            chkObservationType.Items.Clear();
        }
    }

    private void LoadRole()
    {
        DataTable dt = All_LoadData.LoadRole();
        ddlLoginType.DataSource = dt;
        ddlLoginType.DataTextField = "RoleName";
        ddlLoginType.DataValueField = "ID";
        ddlLoginType.DataBind();
        ddlLoginType.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void ddlFloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadObservationTypes(ddlLoginType.SelectedItem.Value, ddlFloor.SelectedItem.Value, ddlFloor.SelectedItem.Text);
    }
}