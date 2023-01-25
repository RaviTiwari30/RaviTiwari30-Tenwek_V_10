using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Services;

public partial class Design_Kitchen_Diet_FixSubDietType : System.Web.UI.Page
{
    [WebMethod]
    public static string getComponent(string DietTimeID, string subDietID, string MenuID, string IPDCaseTypeID, string PanelID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dmdc.ComponentName,IFNULL(frl.Rate,0)Rate,dmdc.Qty,dcm.Type,IFNULL(dcm.Unit,'')Unit,IFNULL(dcm.Calories,'')Calories,IFNULL(dcm.Protein,'')Protein,IFNULL(dcm.Sodium,'')Sodium,IFNULL(dcm.SaturatedFat,'')SaturatedFat, ");
        sb.Append(" IFNULL(dcm.T_Fat,'')T_Fat,IFNULL(Calcium,'')Calcium,IFNULL(Iron,'')Iron,IFNULL(zinc,'')zinc FROM diet_map_diet_component dmdc ");
        sb.Append(" INNER JOIN diet_menu_master dmm ON dmm.DietMenuID=dmdc.DietMenuID ");
        sb.Append(" INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID=dmdc.SubDietID ");
        sb.Append(" INNER JOIN diet_timing dt ON dt.ID=dmdc.DietTimeID ");
        sb.Append(" INNER JOIN diet_component_master dcm ON dcm.ComponentID=dmdc.ComponentID ");
        sb.Append(" LEFT JOIN f_ratelist_ipd frl ON frl.ItemID=dcm.ItemID AND  frl.IPDcaseTypeID='" + IPDCaseTypeID + "' AND frl.PanelID=" + PanelID + " AND frl.IsCurrent=1 ");
        sb.Append(" WHERE dmdc.DietMenuID='" + MenuID + "' ");
        sb.Append(" AND dmdc.SubDietID='" + subDietID + "' ");
        sb.Append(" AND dmdc.DietTimeID='" + DietTimeID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            bool flag = false;
            foreach (GridViewRow row in grdPatientDiet.Rows)
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM diet_fix_patient_diet WHERE TransactionID='" + ((Label)row.FindControl("lblTID")).Text + "' AND DietTimeID='" + ddlDietTiming.SelectedValue + "'");
                if (((DropDownList)row.FindControl("ddlDietType")).SelectedIndex > 0)
                {
                    if (((DropDownList)row.FindControl("ddlSubDiet")).SelectedIndex > 0)
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append("INSERT INTO diet_fix_patient_diet(TransactionID,SubDietID,DietMenuID,DietTimeID,Remarks,EnterBy,DietID)");
                        sb.Append(" VALUES ('" + ((Label)row.FindControl("lblTID")).Text + "','" + ((DropDownList)row.FindControl("ddlSubDiet")).SelectedValue);
                        sb.Append("','" + ((DropDownList)row.FindControl("ddlMenu")).SelectedValue + "','" + ddlDietTiming.SelectedValue + "','" + ((TextBox)row.FindControl("txtRemarks")).Text + "','" + Session["ID"] + "','" + ((DropDownList)row.FindControl("ddlDietType")).SelectedValue + "')");
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                        flag = true;
                    }
                    else
                    {
                        lblMsg.Text = "Select SubDiet";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Select SubDiet');", true);
                        ((DropDownList)row.FindControl("ddlSubDiet")).Focus();
                        Tranx.Rollback();
                        return;
                    }
                }
            }
            Tranx.Commit();
            if (flag)
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            BindGrid();
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (ddlDietTiming.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Diet Timing";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Diet Timing');", true);
            return;
        }

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ddm.DietID,ddm.Name As DietName,dsm.SubdietID,dsm.Name as SubDietName FROM diet_map_diet_component dmdc");
        sb.Append(" INNER JOIN diet_diettype_master ddm ON ddm.DietID=dmdc.DietID ");
        sb.Append(" INNER JOIN diet_Subdiettype_master dsm ON dsm.SubDietID=dmdc.SubDietID ");
        sb.Append(" INNER JOIN diet_timing dt ON dt.ID=dmdc.DietTimeID ");
        sb.Append(" WHERE dt.ID='" + ddlDietTiming.SelectedValue + "' ");
        sb.Append(" GROUP BY ddm.DietID ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        ViewState.Add("DietType", oDT);

        BindGrid();

        if (grdPatientDiet.Rows.Count > 0)
        {
            lblMsg.Text = "";
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void ddlDietType_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        GridViewRow row = (GridViewRow)ddl.NamingContainer;
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT dsm.SubDietID,dsm.Name AS SubDietName FROM diet_map_diet_component dmdc ");
        sb.Append("INNER JOIN diet_diettype_master ddm ON ddm.DietID=dmdc.DietID ");
        sb.Append(" INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID = dmdc.SubDietID ");
        sb.Append(" INNER JOIN diet_timing dt ON dt.ID = dmdc.DietTimeID ");
        sb.Append("  WHERE dt.ID = '" + ddlDietTiming.SelectedValue + "' AND ddm.DietID='" + ((DropDownList)row.FindControl("ddlDietType")).SelectedValue + "' GROUP BY dsm.SubDietID ");

        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        ViewState.Add("SubDietID", oDT);

        ((DropDownList)row.FindControl("ddlSubDiet")).DataSource = oDT;
        ((DropDownList)row.FindControl("ddlSubDiet")).DataTextField = "SubDietName";
        ((DropDownList)row.FindControl("ddlSubDiet")).DataValueField = "SubDietID";
        ((DropDownList)row.FindControl("ddlSubDiet")).DataBind();
        ((DropDownList)row.FindControl("ddlSubDiet")).Items.Insert(0, new ListItem("Select", "0"));
        if (grdPatientDiet.Rows.Count > 0)
        {
            lblMsg.Text = "";
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void ddlSubDiet_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        GridViewRow row = (GridViewRow)ddl.NamingContainer;
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT dmm.DietMenuID,dmm.Name FROM diet_map_diet_component dmdc");
        sb.Append(" INNER JOIN diet_menu_master dmm ON dmm.DietMenuID=dmdc.DietMenuID ");
        sb.Append(" WHERE dmdc.SubDietID='" + ddl.SelectedValue + "'  AND dmdc.DietID='" + ((DropDownList)row.FindControl("ddlDietType")).SelectedValue + "' ");
        sb.Append(" AND dmdc.DietTimeID='" + ddlDietTiming.SelectedValue + "' GROUP BY dmm.DietMenuID ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        if (oDT.Rows.Count > 0)
        {
            ((DropDownList)row.FindControl("ddlMenu")).DataSource = oDT;
            ((DropDownList)row.FindControl("ddlMenu")).DataTextField = "Name";
            ((DropDownList)row.FindControl("ddlMenu")).DataValueField = "DietMenuID";
            ((DropDownList)row.FindControl("ddlMenu")).DataBind();
            ((DropDownList)row.FindControl("ddlMenu")).Items.Insert(0, new ListItem("Select", "0"));
            if (!string.IsNullOrEmpty(((Label)row.FindControl("lblDietMenuID")).Text) && ((DropDownList)row.FindControl("ddlSubDiet")).SelectedIndex > 0)
                ((DropDownList)row.FindControl("ddlMenu")).SelectedValue = ((Label)row.FindControl("lblDietMenuID")).Text;

            ((DropDownList)row.FindControl("ddlMenu")).Enabled = true;

        }

        else
        {
            ((DropDownList)row.FindControl("ddlMenu")).Enabled = false;
        }


    }

    protected void grdPatientDiet_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (ViewState["DietType"] != null)
            {
                ((DropDownList)e.Row.FindControl("ddlDietType")).DataSource = (DataTable)ViewState["DietType"];
                ((DropDownList)e.Row.FindControl("ddlDietType")).DataTextField = "DietName";
                ((DropDownList)e.Row.FindControl("ddlDietType")).DataValueField = "DietID";
                ((DropDownList)e.Row.FindControl("ddlDietType")).DataBind();
                ((DropDownList)e.Row.FindControl("ddlDietType")).Items.Insert(0, new ListItem("Select", "0"));
                if (!string.IsNullOrEmpty(((Label)e.Row.FindControl("lblDeitID")).Text))
                {
                    ((DropDownList)e.Row.FindControl("ddlDietType")).SelectedValue = ((Label)e.Row.FindControl("lblDeitID")).Text;
                }

                ((DropDownList)e.Row.FindControl("ddlSubDiet")).DataSource = (DataTable)ViewState["DietType"];
                ((DropDownList)e.Row.FindControl("ddlSubDiet")).DataTextField = "SubDietName";
                ((DropDownList)e.Row.FindControl("ddlSubDiet")).DataValueField = "SubDietID";
                ((DropDownList)e.Row.FindControl("ddlSubDiet")).DataBind();
                ((DropDownList)e.Row.FindControl("ddlSubDiet")).Items.Insert(0, new ListItem("Select", "0"));
                if (!string.IsNullOrEmpty(((Label)e.Row.FindControl("lblSubDietID")).Text))
                {
                    ((DropDownList)e.Row.FindControl("ddlSubDiet")).SelectedValue = ((Label)e.Row.FindControl("lblSubDietID")).Text;
                    e.Row.BackColor = System.Drawing.Color.LightCyan;
                    ddlSubDiet_SelectedIndexChanged(((DropDownList)e.Row.FindControl("ddlSubDiet")), e);
                }
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindWard();
            BindDietTime();

            if (Session["RoleID"].ToString() == "167")
            {
                ddlWard.SelectedValue = "LSHHI1";
                ddlWard.Enabled = false;
            }
            else if (Session["RoleID"].ToString() == "168")
            {
                ddlWard.SelectedValue = "LSHHI2";
                ddlWard.Enabled = false;
            }
        }
    }

    private void BindDietTime()
    {
        string str = "SELECT ID,NAME FROM diet_timing WHERE IsActive='1'";
        ddlDietTiming.DataSource = StockReports.GetDataTable(str);
        ddlDietTiming.DataTextField = "NAME";
        ddlDietTiming.DataValueField = "ID";
        ddlDietTiming.DataBind();
        ddlDietTiming.Items.Insert(0, new ListItem("Select", "0"));
    }

    private void BindGrid()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pip.PatientID,REPLACE(pip.TransactionID,'ISHHI','') AS IPDNo,pip.TransactionID,CONCAT(pm.Title,' ',pm.PName) AS PName,fpd.ID,fpd.SubDietID,fpd.DietMenuID,fpd.Remarks,fpd.DietID,pip.IPDCaseTypeID,pip.RoomID,pip.PanelID ");
        sb.Append(" FROM patient_ipd_profile pip ");
        //sb.Append(" INNER JOIN f_ipdadjustment adj ON adj.TransactionID = pip.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pip.PatientID ");
        sb.Append(" LEFT JOIN diet_fix_patient_diet fpd ON fpd.TransactionID=pip.TransactionID AND fpd.DietTimeID='" + ddlDietTiming.SelectedValue + "'");
        sb.Append(" WHERE pip.Status='IN' ");
        if (ddlWard.SelectedIndex > 0)
            sb.Append("AND pip.IPDCaseTypeID='" + ddlWard.SelectedValue + "'");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        grdPatientDiet.DataSource = oDT;
        grdPatientDiet.DataBind();
    }

    private void BindWard()
    {
        string str = "SELECT NAME,IPDCaseTypeID FROM ipd_case_type_master WHERE IsActive=1";
        ddlWard.DataSource = StockReports.GetDataTable(str);
        ddlWard.DataTextField = "NAME";
        ddlWard.DataValueField = "IPDCaseTypeID";
        ddlWard.DataBind();
        ddlWard.Items.Insert(0, new ListItem("Select", "0"));
    }
}