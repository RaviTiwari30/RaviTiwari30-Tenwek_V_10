using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_DischargeProcessStep : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            BindProcessStep();
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        UpdateProcessStep();
    }

    private void UpdateProcessStep()
    {
        string query = string.Empty;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            for (int i = 0; i < chkProcessStep.Items.Count; i++)
            {
                if (chkProcessStep.Items[i].Selected)
                    query = " UPDATE discharge_process_master SET IsActive='1',LastUpdatedBy='" + ViewState["ID"].ToString() + "',LastUpdatedDate=NOW() WHERE ID='" + chkProcessStep.Items[i].Value.Split('#')[0] + "' ";
                else
                    query = " UPDATE discharge_process_master SET IsActive='0',LastUpdatedBy='" + ViewState["ID"].ToString() + "',LastUpdatedDate=NOW() WHERE ID='" + chkProcessStep.Items[i].Value.Split('#')[0] + "' ";

                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, query);
            }            
            tranx.Commit();
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

        BindProcessStep();
    }

    private void BindProcessStep()
    {
        //Discharge Process changed by Manesh as Suggested by Sunil Sir
        string query = " SELECT CONCAT(ID,'#',IsMandatory,'#',IsActive)ID,Step FROM discharge_process_master ORDER BY sequenceNo ";

        DataTable dtProcessStep = StockReports.GetDataTable(query);

        if (dtProcessStep.Rows.Count > 0)
        {
            chkProcessStep.DataSource = dtProcessStep;
            chkProcessStep.DataTextField = "Step";
            chkProcessStep.DataValueField = "ID";
            chkProcessStep.DataBind();
        }

        foreach (ListItem item in chkProcessStep.Items)
        {
            if (item.Value.Split('#')[2] == "1")
            {
                item.Selected = true;
            }
            else
            {
                item.Selected = false;
            }

            if (item.Value.Split('#')[1] == "1")
            {
                item.Enabled=false;
                item.Attributes.Add("style", "background:none;");
            }
            else
            {
                item.Enabled = true;
                item.Attributes.Add("style", "background:#1AFF1A;");
            }
        }
    }
}