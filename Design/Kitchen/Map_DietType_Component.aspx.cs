using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Kitchen_Map_DiteType_Control : System.Web.UI.Page
{
    protected void BindDiet()
    {
        ddlDietType.DataSource = StockReports.GetDataTable("Select DietID,Name From diet_DietType_master where IsActive=1 order By Name");
        ddlDietType.DataTextField = "Name";
        ddlDietType.DataValueField = "DietID";
        ddlDietType.DataBind();
        ddlDietType.Items.Insert(0, "Select");
    }

    protected void BindSubMenu()
    {
        if (ddlDietType.SelectedIndex > 0)
        {
            DataTable dtDetail = StockReports.GetDataTable("select dsm.SubDietID,dsm.Name FROM diet_subdiettype_master dsm inner join diet_Map_Type_SubType dmts ON dsm.SubDietID=dmts.SubDietID AND  dmts.DietID='" + ddlDietType.SelectedItem.Value + "'  where  dsm.IsActive=1 order by dsm.name ");
            if (dtDetail.Rows.Count > 0)
            {
                ddlSubDietType.DataSource = dtDetail;
                ddlSubDietType.DataTextField = "Name";
                ddlSubDietType.DataValueField = "SubDietID";
                ddlSubDietType.DataBind();
                ddlSubDietType.Items.Insert(0, "Select");
            }
        }
        else
        {
            lblmsg.Text = "Select Diet Type";
            ddlSubDietType.DataSource = null;
            ddlSubDietType.DataBind();
            ddlSubDietType.Items.Insert(0, "Select");
            btnSave.Visible = false;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddltiming.SelectedItem.Text != "Select")
        {
            if (ddlmenu.SelectedItem.Text != "Select")
            {
                string str = "";
                int a = 0;
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete From Diet_Map_Diet_Component where  DietmenuID='" + lblMenuID.Text + "' and DietTimeID='" + ddltiming.SelectedItem.Value + "' and DietID='" + ddlDietType.SelectedItem.Value + "'AND  SubDietID='" + ddlSubDietType.SelectedItem.Value + "'");

                    for (int i = 0; i < grdDetail.Rows.Count; i++)
                    {
                        if (((CheckBox)grdDetail.Rows[i].FindControl("chk")).Checked == true)
                        {
                            if (((TextBox)grdDetail.Rows[i].FindControl("txtQty")).Text == "" || ((TextBox)grdDetail.Rows[i].FindControl("txtQty")).Text == "0")
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                lblmsg.Text = "Please Enter Qty. or UnCheck It";

                                ((TextBox)grdDetail.Rows[i].FindControl("txtQty")).BackColor = System.Drawing.Color.LightPink;
                                return;
                            }
                            str = "";
                            str = "Insert Into Diet_Map_Diet_Component(DietID,SubDietID,ComponentID,SubDietName,ComponentName,Qty,DietTimeID,DietmenuID,CreatedBy)Values('" + ddlDietType.SelectedItem.Value + "','" + ddlSubDietType.SelectedItem.Value + "','" + ((Label)grdDetail.Rows[i].FindControl("lblCompID")).Text + "','" + ddlSubDietType.SelectedItem.Text + "','" + ((Label)grdDetail.Rows[i].FindControl("lblName")).Text + "','" + ((TextBox)grdDetail.Rows[i].FindControl("txtQty")).Text + "','" + ddltiming.SelectedItem.Value + "','" + ddlmenu.SelectedItem.Value + "','"+Session["ID"].ToString()+"')";
                            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                            if (a == 0)
                            {
                                Tranx.Rollback();
                                Tranx.Dispose();
                                con.Close();
                                con.Dispose();
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                                return;
                            }
                            a = 0;
                        }
                    }
                    Tranx.Commit();

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                    grdDetail.DataSource = "";
                    grdDetail.DataBind();
                    btnSave.Visible = false;
                }
                catch (Exception ex)
                {
                    Tranx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                    return;
                }
                finally
                {
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
            else
            {
                lblmsg.Text = "Please Select Menu Name";
            }
        }
        else
        {
            lblmsg.Text = "Please Select Diet Timing";
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        search();
    }

    protected void CheckDropDownValue()
    {
        int a = 0;
        for (int i = 0; i < grdDetail.Rows.Count; i++)
        {
            if (((CheckBox)grdDetail.Rows[i].FindControl("chk")).Checked == true)
            {
                a = a + 1;
            }
        }
        if (a < 0)
        {
            grdDetail.DataSource = "";
            grdDetail.DataBind();
        }
    }

    protected void ddlDietType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubMenu();
        CheckDropDownValue();
    }

    protected void ddlmenu_SelectedIndexChanged(object sender, EventArgs e)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM Diet_Map_Diet_Component WHERE DietmenuID='" + ddlmenu.SelectedValue + "'"));
        if (count > 0)
        {
            DataTable dt = StockReports.GetDataTable("SELECT DietID,SubDietID,DietTimeID FROM Diet_Map_Diet_Component WHERE DietmenuID='" + ddlmenu.SelectedValue + "' LIMIT 1");
            if (dt.Rows.Count > 0)
            {
              //  ddlDietType.SelectedIndex = ddlDietType.Items.IndexOf(ddlDietType.Items.FindByValue(dt.Rows[0]["DietID"].ToString()));
             //   BindSubMenu();
            //    ddlSubDietType.SelectedIndex = ddlSubDietType.Items.IndexOf(ddlSubDietType.Items.FindByValue(dt.Rows[0]["SubDietID"].ToString()));
            //    ddltiming.SelectedIndex = ddltiming.Items.IndexOf(ddltiming.Items.FindByValue(dt.Rows[0]["DietTimeID"].ToString()));
            }
          //  search();
        }
        else
            CheckDropDownValue();
    }

    protected void ddlSubDietType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlmenu.SelectedIndex == 0)
        {
            ddlmenu.SelectedIndex = -1;
        }
        ddlmenu.Enabled = true;
        CheckDropDownValue();
    }

    protected void ddltiming_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlmenu.SelectedIndex == 0)
        {
            ddlmenu.SelectedIndex = -1;
        }
        CheckDropDownValue();
    }

    protected void grdDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex >= 0)
        {
            if (((Label)e.Row.FindControl("lblDietID")).Text != "0")
            {
                ((CheckBox)e.Row.FindControl("chk")).Checked = true;
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            }
            else
            {
                ((CheckBox)e.Row.FindControl("chk")).Checked = false;
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDiet();
            diettiming();
            menuName();
            lblmsg.Text = "";
        }
    }

    private void diettiming()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(" SELECT * FROM diet_timing WHERE isactive=1 ");
        ddltiming.DataSource = dt;
        ddltiming.DataTextField = "Name";
        ddltiming.DataValueField = "id";
        ddltiming.DataBind();
        ddltiming.Items.Insert(0, "Select");
    }

    private void menuName()
    {
        ddlmenu.DataSource = StockReports.GetDataTable(" select * from diet_Menu_master where isactive=1 order by name");
        ddlmenu.DataTextField = "Name";
        ddlmenu.DataValueField = "DietMenuid";
        ddlmenu.DataBind();
        ddlmenu.Items.Insert(0, "Select");
    }

    private void search()
    {
        try
        {
            if (ddltiming.SelectedIndex <= 0)
            {
                lblmsg.Text = "Please Select Diet Timing ";
                ddltiming.Focus();
                return;
            }
            if (ddlDietType.SelectedIndex <= 0)
            {
                lblmsg.Text = "Please Select Diet Type";
                ddlDietType.Focus();
                return;
            }
            if (ddlmenu.SelectedIndex <= 0)
            {
                lblmsg.Text = "Please Select Menu Name ";
                ddlmenu.Focus();
                return;
            }
            if (ddlSubDietType.SelectedIndex <= 0)
            {
                lblmsg.Text = "Please Select Diet Specification";
                ddlSubDietType.Focus();
                return;
            }

           
            DataTable dtDetail = StockReports.GetDataTable("SELECT T_Fat,Calcium,Iron,Zinc,IFNULL(mdc.SubDietID,0)SubDietID,t1.ComponentID,t1.Name, " +
                " t1.Type,t1.Unit,IFNULL(mdc.Qty,0)Qty,t1.Calories,t1.Protein,t1.Sodium,t1.SaturatedFat,t1.Potassium FROM diet_Component_Master t1 " +
                " left JOIN Diet_Map_Diet_Component mdc ON t1.ComponentID=mdc.ComponentID AND mdc.SubDietID='" + ddlSubDietType.SelectedItem.Value + "' " +
                " and mdc.dietID='" + ddlDietType.SelectedItem.Value + "' and mdc.DietTimeID='" + ddltiming.SelectedItem.Value + "' " +
                " and mdc.DietmenuID='" + ddlmenu.SelectedItem.Value + "'  WHERE t1.IsActive=1  ORDER BY mdc.Qty DESC,t1.Name ");
            if (dtDetail.Rows.Count > 0)
            {
                grdDetail.DataSource = dtDetail;
                grdDetail.DataBind();
                lblMenuID.Text = ddlmenu.SelectedItem.Value;
                btnSave.Visible = true;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
                grdDetail.DataSource = null;
                grdDetail.DataBind();
                btnSave.Visible = false;
                lblMenuID.Text = "";
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
        }
    }
}