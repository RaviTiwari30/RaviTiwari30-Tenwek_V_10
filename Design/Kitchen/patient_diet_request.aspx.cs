using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Kitchen_patient_diet_request : System.Web.UI.Page
{
    [WebMethod]
    public static string getComponent(string DietTimeID, string subDietID, string MenuID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dmdc.ComponentName,dmdc.Qty,dcm.Type,IFNULL(dcm.Unit,'')Unit,IFNULL(dcm.Calories,'')Calories,IFNULL(dcm.Protein,'')Protein,IFNULL(dcm.Sodium,'')Sodium,IFNULL(dcm.SaturatedFat,'')SaturatedFat, ");
        sb.Append(" IFNULL(dcm.T_Fat,'')T_Fat,IFNULL(Calcium,'')Calcium,IFNULL(Iron,'')Iron,IFNULL(zinc,'')zinc FROM diet_map_diet_component dmdc ");
        sb.Append(" INNER JOIN diet_menu_master dmm ON dmm.DietMenuID=dmdc.DietMenuID ");
        sb.Append(" INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID=dmdc.SubDietID ");
        sb.Append(" INNER JOIN diet_timing dt ON dt.ID=dmdc.DietTimeID ");
        sb.Append(" INNER JOIN diet_component_master dcm ON dcm.ComponentID=dmdc.ComponentID ");
        sb.Append(" WHERE dmdc.DietMenuID='" + MenuID + "' ");
        sb.Append(" AND dmdc.SubDietID='" + subDietID + "' ");
        sb.Append(" AND dmdc.DietTimeID='" + DietTimeID + "'");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        string result = Newtonsoft.Json.JsonConvert.SerializeObject(oDT);
        return result;
    }

    [WebMethod]
    public static string getHistory(string DietTimeID, string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT sm.Name AS 'SubDietType',mm.Name AS 'Menu',DATE_FORMAT(pdr.EnterDate,'%d-%b-%y') AS 'EnterDate',CONCAT(em.Title,' ',em.Name) AS EnterBy ");
        sb.Append(" FROM diet_patient_diet_request pdr ");
        sb.Append(" INNER JOIN diet_subdiettype_master sm ON pdr.SubDietID=sm.SubDietID ");
        sb.Append(" INNER JOIN diet_menu_master mm ON pdr.DietMenuID=mm.DietMenuID ");
        sb.Append(" INNER JOIN employee_master em ON pdr.EnterBy=em.EmployeeID ");
        sb.Append(" WHERE pdr.DietTimeID='" + DietTimeID + "' ");
        sb.Append(" AND pdr.TransactionID='" + TransactionID + "' ORDER BY pdr.EnterDate DESC ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        string result = Newtonsoft.Json.JsonConvert.SerializeObject(oDT);
        return result;
    }

    protected void btnReceive_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        GridViewRow row = (GridViewRow)btn.NamingContainer;
        if (StockReports.ExecuteDML("UPDATE diet_patient_diet_request SET IsReceived = '1' WHERE ID = '" + ((Label)row.FindControl("lblID")).Text + "';"))
        {
            lblMsg.Text = "Order Received Successfully";
            btn.Enabled = false;
            row.BackColor = System.Drawing.Color.LightSeaGreen;
        }
    }

    protected void btnReceiveAll_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (GridViewRow row in grdPatientDiet.Rows)
            {
                if (((Label)row.FindControl("lblIssue")).Text == "1" && ((Label)row.FindControl("lblReceive")).Text != "1")
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_patient_diet_request SET IsReceived = '1' WHERE ID = '" + ((Label)row.FindControl("lblID")).Text + "'");
                }
            }
            Tranx.Commit();
            lblMsg.Text = "Record Saved Successfully";
            BindGrid();
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
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
                if (((DropDownList)row.FindControl("ddlMenu")).SelectedIndex > 0 && ((Label)row.FindControl("lblFreeze")).Text != "1")
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM diet_patient_diet_request WHERE TransactionID='" + ((Label)row.FindControl("lblTID")).Text + "' AND DATE(EnterDate)='" + Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd") + "' AND DietTimeID='" + ddlDietTiming.SelectedValue + "'");
                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO diet_patient_diet_request(TransactionID,SubDietID,DietMenuID,DietTimeID,Remarks,EnterBy,DietID,IPDCaseTypeID,RoomID,RequestDate)");
                    sb.Append(" VALUES ('" + ((Label)row.FindControl("lblTID")).Text + "','" + ((DropDownList)row.FindControl("ddlSubDiet")).SelectedValue);
                    sb.Append("','" + ((DropDownList)row.FindControl("ddlMenu")).SelectedValue + "','" + ddlDietTiming.SelectedValue + "','" + ((TextBox)row.FindControl("txtRemarks")).Text + "','" + Session["ID"] + "','" + ((DropDownList)row.FindControl("ddlDietType")).SelectedValue + "','" + ((Label)row.FindControl("lblIPDCaseTypeID")).Text + "','" + ((Label)row.FindControl("lblRoomID")).Text + "','" + Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd") + "')");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                    flag = true;
                }
            }
            Tranx.Commit();
            if (flag)
                lblMsg.Text = "Record Saved Successfully";
            BindGrid();
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
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
        lblMsg.Text = "";
        if (ddlDietTiming.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select Diet Timing";
            return;
        }
        DataTable timeDT = StockReports.GetDataTable("SELECT concat('" + Convert.ToDateTime(ucDate.Text).ToString("yyyy-MM-dd") + "',' ', TIME_FORMAT(FromTime,'%H:%i %p'))RequestDateTime,IFNULL(OrderBefore,0) AS OrderBefore FROM diet_timing WHERE ID='" + ddlDietTiming.SelectedValue + "'");

        DateTime CanRequestDateTime = Convert.ToDateTime(timeDT.Rows[0]["RequestDateTime"]).AddHours(-Convert.ToInt16(timeDT.Rows[0]["OrderBefore"]));

        if (DateTime.Now > CanRequestDateTime)
        {
            lblMsg.Text = "Order Time has Passed Out. Now You Can Only View the Diet Request";
            btnSave.Enabled = false;
        }
        else
            btnSave.Enabled = true;
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
        if (grdPatientDiet.Rows.Count <= 0)
        {
            lblMsg.Text = "Record Not Found";
            grdPatientDiet.DataSource = "";
            grdPatientDiet.DataBind();
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
        //if (grdPatientDiet.Rows.Count > 0)
        //{
        //    lblMsg.Text = "";
        //}
        //else
        //{
        //    lblMsg.Text = "Record Not Found";
        //}
    }

    protected void ddlSubDiet_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        GridViewRow row = (GridViewRow)ddl.NamingContainer;
        string days = DateTime.Now.ToString("ddd");
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dmm.DietMenuID,dmm.Name FROM diet_map_diet_component dmdc");
        sb.Append(" INNER JOIN diet_menu_master dmm ON dmm.DietMenuID=dmdc.DietMenuID ");
        sb.Append(" WHERE dmdc.SubDietID='" + ddl.SelectedValue + "' AND dmdc.DietID='" + ((DropDownList)row.FindControl("ddlDietType")).SelectedValue + "' ");
        sb.Append(" AND dmdc.DietTimeID='" + ddlDietTiming.SelectedValue + "' AND dmm.days LIKE '%" + days + "%' GROUP BY dmm.DietMenuID ");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        ((DropDownList)row.FindControl("ddlMenu")).DataSource = oDT;
        ((DropDownList)row.FindControl("ddlMenu")).DataTextField = "Name";
        ((DropDownList)row.FindControl("ddlMenu")).DataValueField = "DietMenuID";
        ((DropDownList)row.FindControl("ddlMenu")).DataBind();
        ((DropDownList)row.FindControl("ddlMenu")).Items.Insert(0, new ListItem("Select", "0"));
        if (!string.IsNullOrEmpty(((Label)row.FindControl("lblDietMenuID")).Text) && ((DropDownList)row.FindControl("ddlSubDiet")).SelectedIndex > 0)
            ((DropDownList)row.FindControl("ddlMenu")).SelectedValue = ((Label)row.FindControl("lblDietMenuID")).Text;
    }

    protected void grdPatientDiet_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (ViewState["DietType"] != null)
            {
                DataTable dt = (DataTable)ViewState["DietType"];
                ((DropDownList)e.Row.FindControl("ddlDietType")).DataSource = (DataTable)ViewState["DietType"];
                ((DropDownList)e.Row.FindControl("ddlDietType")).DataTextField = "DietName";
                ((DropDownList)e.Row.FindControl("ddlDietType")).DataValueField = "DietID";
                ((DropDownList)e.Row.FindControl("ddlDietType")).DataBind();
                ((DropDownList)e.Row.FindControl("ddlDietType")).Items.Insert(0, new ListItem("Select", "0"));
                if (!string.IsNullOrEmpty(((Label)e.Row.FindControl("lblDeitID")).Text))
                {
                    ((DropDownList)e.Row.FindControl("ddlDietType")).SelectedValue = ((Label)e.Row.FindControl("lblDeitID")).Text;
                    if (!string.IsNullOrEmpty(((Label)e.Row.FindControl("lblFix")).Text))
                    {
                        ((DropDownList)e.Row.FindControl("ddlSubDiet")).Enabled = false;
                    }
                    ddlDietType_SelectedIndexChanged(((DropDownList)e.Row.FindControl("ddlDietType")), e);
                }
                ((DropDownList)e.Row.FindControl("ddlSubDiet")).Items.Insert(0, new ListItem("Select", "0"));
                if (!string.IsNullOrEmpty(((Label)e.Row.FindControl("lblSubDietID")).Text))
                {
                    if (!string.IsNullOrEmpty(((Label)e.Row.FindControl("lblFix")).Text))
                    {
                        ((DropDownList)e.Row.FindControl("ddlDietType")).Enabled = false;
                    }
                    ((DropDownList)e.Row.FindControl("ddlSubDiet")).SelectedValue = ((Label)e.Row.FindControl("lblSubDietID")).Text;
                    e.Row.BackColor = System.Drawing.Color.Pink;
                    ddlSubDiet_SelectedIndexChanged(((DropDownList)e.Row.FindControl("ddlSubDiet")), e);
                }
                ((DropDownList)e.Row.FindControl("ddlMenu")).Items.Insert(0, new ListItem("Select", "0"));
            }
            if (!string.IsNullOrEmpty(((Label)e.Row.FindControl("lblFix")).Text))
            {
                e.Row.BackColor = System.Drawing.Color.LightCyan;
            }

            if (((Label)e.Row.FindControl("lblFreeze")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.LemonChiffon;
                ((DropDownList)e.Row.FindControl("ddlDietType")).Enabled = false;
                ((DropDownList)e.Row.FindControl("ddlSubDiet")).Enabled = false;
                ((DropDownList)e.Row.FindControl("ddlMenu")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtRemarks")).Enabled = false;
            }

            if (((Label)e.Row.FindControl("lblIssue")).Text == "1")
            {
                ((Button)e.Row.FindControl("btnReceive")).Enabled = true;
                e.Row.BackColor = System.Drawing.Color.YellowGreen;
            }
            else
                ((Button)e.Row.FindControl("btnReceive")).Enabled = false;

            if (((Label)e.Row.FindControl("lblReceive")).Text == "1")
            {
                ((Button)e.Row.FindControl("btnReceive")).Enabled = false;
                e.Row.BackColor = System.Drawing.Color.LightSeaGreen;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
            AllLoadData_IPD.bindCaseType(ddlWard, "Select", 0);
            AllLoadData_Diet.bindDietTime(ddlDietTiming, "Select");

            ucDate.Attributes.Add("readOnly", "readOnly");
            ucDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
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
            else if (Session["RoleID"].ToString() == "166")
            {
                ddlWard.SelectedValue = "LSHHI3";
                ddlWard.Enabled = false;
            }
            else if (Session["RoleID"].ToString() == "108")
            {
                ddlWard.SelectedValue = "LSHHI4";
                ddlWard.Enabled = false;
            }
        }
    }

    

    private void BindGrid()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pmh.PatientID,REPLACE(pip.TransactionID, 'ISHHI', '') AS IPDNo,pip.TransactionID,CONCAT(pm.Title, ' ', pm.PName) AS PName,dpdr.ID,IF(ISNULL(fpd.SubDietID),dpdr.SubDietID,fpd.SubDietID) AS SubDietID,IF(ISNULL(fpd.DietMenuID) OR fpd.DietMenuID=0,dpdr.DietMenuID,fpd.DietMenuID) AS DietMenuID,IF(ISNULL(fpd.Remarks),dpdr.Remarks,fpd.Remarks) AS Remarks,dpdr.IsFreeze,dpdr.IsIssued,dpdr.IsReceived,fpd.ID AS FixID,   IF(ISNULL(fpd.`DietID`),dpdr.DietID,fpd.DietID) AS DietID ");
        sb.Append(" ,pip.IPDCaseType_ID,pip.Room_ID");
        sb.Append(" FROM patient_ipd_profile pip ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID = pip.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append(" LEFT JOIN diet_fix_patient_diet fpd ON fpd.TransactionID = pip.TransactionID AND fpd.DietTimeID='" + ddlDietTiming.SelectedValue + "'");
        sb.Append(" LEFT JOIN diet_patient_diet_request dpdr ON dpdr.TransactionID=pip.TransactionID AND DATE(dpdr.Requestdate)='" + Util.GetDateTime(ucDate.Text).ToString("yyyy-MM-dd") + "' AND dpdr.DietTimeID='" + ddlDietTiming.SelectedValue + "'");
        sb.Append(" WHERE pip.Status='IN' ");
        if (ddlWard.SelectedIndex > 0)
            sb.Append("AND pip.IPDCaseType_ID='" + ddlWard.SelectedValue + "'");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        grdPatientDiet.DataSource = oDT;
        grdPatientDiet.DataBind();
    }

   
}