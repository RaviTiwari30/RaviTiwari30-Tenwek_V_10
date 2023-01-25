using System;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Centre_CenterAccess : System.Web.UI.Page
{
    public static DataTable checkeCentre(string employee_id)
    {
        return StockReports.GetDataTable("select cm.CentreName,cm.CentreID from Center_master cm INNER JOIN centre_access ca ON ca.CentreAccess = cm.CentreID where ca.IsActive = 1 And ca.EmployeeID = '" + employee_id + "'");
    }

    public void bindCentre(CheckBoxList Centre, string employeeid)
    {
        DataTable dtData = All_LoadData.dtbind_Center();
        DataTable dtcheck = checkeCentre(employeeid);
        if (dtData.Rows.Count > 0)
        {
            Centre.DataSource = dtData;
            Centre.DataTextField = "CentreName";
            Centre.DataValueField = "CentreID";
            Centre.DataBind();
            Centre.RepeatColumns = 4;
            Centre.Width = 600;
            for (int i = 0; i < dtcheck.Rows.Count; i++)
            {
                for (int j = 0; j < dtData.Rows.Count; j++)
                {
                    if (dtcheck.Rows[i]["CentreName"].ToString() == dtData.Rows[j]["CentreName"].ToString())
                    {
                        Centre.Items[i].Selected = true;
                        break;
                    }
                }
            }
        }
        else
        {
            Centre.DataSource = null;
            Centre.DataBind();
        }
    }

    public void bindEmployeeName()
    {
        DataTable dt = All_LoadData.LoadEmployee();
        ddlEmployeeName.DataSource = dt;
        ddlEmployeeName.DataTextField = "Name";
        ddlEmployeeName.DataValueField = "EmployeeID";
        ddlEmployeeName.DataBind();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            string del = "delete from centre_access where EmployeeID ='" + ddlEmployeeName.SelectedValue + "'";
            StockReports.ExecuteDML(del);

            for (int i = 0; i < chkCentre.Items.Count; i++)
            {
                if (chkCentre.Items[i].Selected == true)
                {
                    string str = "insert into centre_access(EmployeeID,CentreAccess,IsActive,UpdateDate) values('" + ddlEmployeeName.SelectedValue + "','" + chkCentre.Items[i].Value + "','1','" + System.DateTime.Now.ToString("yyyy-MM-dd hh-mm-ss") + "')";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                }
                else
                {
                    string str = "insert into centre_access(EmployeeID,CentreAccess,IsActive,UpdateDate) values('" + ddlEmployeeName.SelectedValue + "','" + chkCentre.Items[i].Value + "','0','" + System.DateTime.Now.ToString("yyyy-MM-dd hh-mm-ss") + "')";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                }
            }

            tranX.Commit();

            lblerrmsg.Text = "Record Saved Successfully";
        }
        catch (Exception ex)
        {
            tranX.Rollback();

            lblerrmsg.Text = "Error occurred, Please contact administrator";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void ddlEmployeeName_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        bindCentre(chkCentre, ddlEmployeeName.SelectedValue);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindEmployeeName();
            bindCentre(chkCentre, ddlEmployeeName.SelectedValue);
        }
    }
}