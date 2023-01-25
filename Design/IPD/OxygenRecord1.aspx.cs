using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_IPD_OxygenRecord1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();

            BindData();
        }

        lblMsg.Text = "";
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Validate())
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                string query = "INSERT INTO ipd_ventilator_input_output_chart (PatientID,TransactionID,OI_VS_IP,OI_VS_PIP,OI_VS_PEEP,OI_PS_IP,OI_PS_PIP,OI_PS_PEEP,DO_VS_IP,DO_VS_PIP,DO_VS_PEEP,DO_PS_IP,DO_PS_PIP,DO_PS_PEEP,CreatedBy,CreatedDate) " +
                               "VALUES ('" + Util.GetString(ViewState["PatientID"]) + "','" + Util.GetString(ViewState["TransactionID"]) + "','" + Util.GetString(txtOI_VS_IP.Text.Trim()) + "','" + Util.GetString(txtOI_VS_PIP.Text.Trim()) + "','" + Util.GetString(Util.GetString(txtOI_VS_PEEP.Text.Trim())) + "'," +
                               "'" + Util.GetString(txtOI_PS_IP.Text.Trim()) + "','" + Util.GetString(txtOI_PS_PIP.Text.Trim()) + "','" + Util.GetString(txtOI_PS_PEEP.Text.Trim()) + "','" + Util.GetString(txtDO_VS_IP.Text.Trim()) + "','" + Util.GetString(txtDO_VS_PIP.Text.Trim()) + "','" + Util.GetString(txtDO_VS_PEEP.Text.Trim()) + "'," +
                               "'" + Util.GetString(txtDO_PS_IP.Text.Trim()) + "','" + Util.GetString(txtDO_PS_PIP.Text.Trim()) + "','" + Util.GetString(txtDO_PS_PEEP.Text.Trim()) + "','" + Util.GetString(ViewState["UserID"]) + "',NOW())";

                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

                tranx.Commit();

                BindData();
                Clear();
                lblMsg.Text = "Record Saved Successfully";
            }
            catch (Exception ex)
            {
                tranx.Rollback();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);

                lblMsg.Text = "Error occurred, Please contact administrator";
            }
            finally
            {
                tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void grdVentilatorChart_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            int rowIndex = Convert.ToInt16(e.CommandArgument.ToString());

            lblID.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblID")).Text;
            txtOI_VS_IP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblOI_VS_IP")).Text;
            txtOI_VS_PIP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblOI_VS_PIP")).Text;
            txtOI_VS_PEEP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblOI_VS_PEEP")).Text;
            txtOI_PS_IP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblOI_PS_IP")).Text;
            txtOI_PS_PIP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblOI_PS_PIP")).Text;
            txtOI_PS_PEEP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblOI_PS_PEEP")).Text;
            txtDO_VS_IP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblDO_VS_IP")).Text;
            txtDO_VS_PIP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblDO_VS_PIP")).Text;
            txtDO_VS_PEEP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblDO_VS_PEEP")).Text;
            txtDO_PS_IP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblDO_PS_IP")).Text;
            txtDO_PS_PIP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblDO_PS_PIP")).Text;
            txtDO_PS_PEEP.Text = ((Label)grdVentilatorChart.Rows[rowIndex].FindControl("lblDO_PS_PEEP")).Text;

            btnSave.Visible = false;
            btnUpdate.Visible = true;
            btnCancel.Visible = true;
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (Validate())
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                string query = "UPDATE ipd_ventilator_input_output_chart SET OI_VS_IP='" + Util.GetString(txtOI_VS_IP.Text.Trim()) + "',OI_VS_PIP='" + Util.GetString(txtOI_VS_PIP.Text.Trim()) + "',OI_VS_PEEP='" + Util.GetString(Util.GetString(txtOI_VS_PEEP.Text.Trim())) + "'," +
                               "OI_PS_IP='" + Util.GetString(txtOI_PS_IP.Text.Trim()) + "',OI_PS_PIP='" + Util.GetString(txtOI_PS_PIP.Text.Trim()) + "',OI_PS_PEEP='" + Util.GetString(txtOI_PS_PEEP.Text.Trim()) + "',DO_VS_IP='" + Util.GetString(txtDO_VS_IP.Text.Trim()) + "'," +
                               "DO_VS_PIP='" + Util.GetString(txtDO_VS_PIP.Text.Trim()) + "',DO_VS_PEEP='" + Util.GetString(txtDO_VS_PEEP.Text.Trim()) + "',DO_PS_IP='" + Util.GetString(txtDO_PS_IP.Text.Trim()) + "',DO_PS_PIP='" + Util.GetString(txtDO_PS_PIP.Text.Trim()) + "'," +
                               "DO_PS_PEEP='" + Util.GetString(txtDO_PS_PEEP.Text.Trim()) + "',UpdatedBy='" + Util.GetString(ViewState["UserID"]) + "',UpdatedDate=NOW() " +
                               "WHERE ID='" + lblID.Text.Trim() + "'";

                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);

                tranx.Commit();

                BindData();
                Clear();
                lblMsg.Text = "Record Updated Successfully";
            }
            catch (Exception ex)
            {
                tranx.Rollback();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);

                lblMsg.Text = "Error occurred, Please contact administrator";
            }
            finally
            {
                tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
    }

    private void BindData()
    {
        string query = "SELECT ivioc.ID,ivioc.PatientID,ivioc.TransactionID,ivioc.OI_VS_IP,ivioc.OI_VS_PIP,ivioc.OI_VS_PEEP,ivioc.OI_PS_IP,ivioc.OI_PS_PIP,ivioc.OI_PS_PEEP,ivioc.DO_VS_IP,ivioc.DO_VS_PIP,ivioc.DO_VS_PEEP,ivioc.DO_PS_IP,ivioc.DO_PS_PIP,ivioc.DO_PS_PEEP,DATE_FORMAT(ivioc.CreatedDate,'%d-%b-%Y') AS Date,TIME_FORMAT(ivioc.CreatedDate,'%h:%i %p') AS Time,CONCAT(emp.Title,' ',emp.Name) AS CreatedBy " +
                       "FROM ipd_ventilator_input_output_chart ivioc INNER JOIN employee_master emp ON ivioc.CreatedBy = emp.EmployeeID WHERE ivioc.TransactionID='" + ViewState["TransactionID"].ToString() + "'";

        DataTable dt = StockReports.GetDataTable(query);

        if (dt.Rows.Count > 0)
        {
            grdVentilatorChart.DataSource = dt;
            grdVentilatorChart.DataBind();
        }
        else
        {
            grdVentilatorChart.DataSource = null;
            grdVentilatorChart.DataBind();
        }
    }

    private bool Validate()
    {
        return true;
    }

    private void Clear()
    {
        lblID.Text = "";
        txtOI_VS_IP.Text = "";
        txtOI_VS_PIP.Text = "";
        txtOI_VS_PEEP.Text = "";
        txtOI_PS_IP.Text = "";
        txtOI_PS_PIP.Text = "";
        txtOI_PS_PEEP.Text = "";
        txtDO_VS_IP.Text = "";
        txtDO_VS_PIP.Text = "";
        txtDO_VS_PEEP.Text = "";
        txtDO_PS_IP.Text = "";
        txtDO_PS_PIP.Text = "";
        txtDO_PS_PEEP.Text = "";

        btnSave.Visible = true;
        btnUpdate.Visible = false;
        btnCancel.Visible = false;
    }
}