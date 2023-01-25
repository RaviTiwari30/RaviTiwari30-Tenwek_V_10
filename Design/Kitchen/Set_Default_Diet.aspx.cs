using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Kitchen_Set_Default_Diet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDietType(rblIsPanelApproved.SelectedValue);
            BindDataType();
            BindMenuDDL();
            BindMenuGrid();

            if (grdDietType.Rows.Count > 0)
            {
                string did = ((Label)grdDietType.Rows[0].FindControl("lblDietID")).Text;

                BindSubDietType(did);
                btnSave.Enabled = false;
            }
            if (grdMenuDetails.Rows.Count > 0)
            {
                btnSaveMenu.Enabled = false;
            }
        }
    }

    private void BindDietType(string IsPanelApproved)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT DietID,NAME FROM diet_DietType_master WHERE Isactive='1' ");
        if (IsPanelApproved == "0" || IsPanelApproved == "1")
        {
            sb.Append("AND  IsPanelApproved='" + IsPanelApproved + "'");
        }
        DataTable dtData = StockReports.GetDataTable(sb.ToString());
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlDietType.DataSource = dtData;
            ddlDietType.DataTextField = "NAME";
            ddlDietType.DataValueField = "DietID";
            ddlDietType.DataBind();

            ddlDietType.Items.Insert(0, new ListItem("--Select--"));
        }
        else
        {
            ddlDietType.DataSource = null;
            ddlDietType.DataBind();
        }

    }
    private void BindSubDietType(string diettype)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT dsm.SubDietID,dsm.NAME FROM diet_subdiettype_master dsm ");
        sb.Append(" INNER JOIN diet_Map_Type_SubType dmts ON dmts.SubDietID = dsm.SubDietID WHERE dsm.IsActive='1' ");
        if (diettype != "" && diettype != "0")
        {
            sb.Append(" AND dmts.DietID= '" + diettype + "' ");
        }

        DataTable dtData = StockReports.GetDataTable(sb.ToString());
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlSubDietType.DataSource = dtData;
            ddlSubDietType.DataTextField = "NAME";
            ddlSubDietType.DataValueField = "SubDietID";
            ddlSubDietType.DataBind();

            ddlSubDietType.Items.Insert(0, new ListItem("--Select--"));
        }
        else
        {
            ddlSubDietType.Items.Clear();     
            ddlSubDietType.DataSource = null;
            ddlSubDietType.DataBind();
            ddlSubDietType.Items.Insert(0, new ListItem("--Select--"));
        }
    }

    protected void ddlDietType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubDietType(ddlDietType.SelectedValue);
    }
    protected void rblIsPanelApproved_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDietType(rblIsPanelApproved.SelectedValue);
        BindSubDietType(ddlDietType.SelectedValue);
        BindDataType();       
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            if (rblIsPanelApproved.SelectedValue == "0")
            {
                var sqlCMD = " UPDATE diet_Map_Type_SubType SET IsDefault = 0, Dtype='' WHERE IsDefault = 1 AND Dtype='N' ";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                    });

                var sqlCMD1 = "UPDATE diet_Map_Type_SubType SET IsDefault = 1, Dtype='N', UpdatedBy='" + Session["ID"].ToString() + "', Updatedate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE DietId=@DietID AND SubDietID= @SubDietID ";
                excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
                    {
                        DietID = ddlDietType.SelectedValue,
                        SubDietID = ddlSubDietType.SelectedValue
                    });
            }
            else
            {
                var sqlCMD = " UPDATE diet_Map_Type_SubType SET IsDefault = 0, Dtype='' WHERE IsDefault = 1 AND Dtype='P' ";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                    {
                    });

                var sqlCMD1 = "UPDATE diet_Map_Type_SubType SET IsDefault = 1, Dtype='P', UpdatedBy='" + Session["ID"].ToString() + "', Updatedate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE DietId=@DietID AND SubDietID= @SubDietID ";
                excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
                {
                    DietID = ddlDietType.SelectedValue,
                    SubDietID = ddlSubDietType.SelectedValue
                });
            }

            tnx.Commit();
            lblmsg.Text = "Values Set Default Successfully.";

            BindDataType();
            btnSave.Text = "Save";                  
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = "Error occurred, Please contact administrator";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
        }
        finally {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void BindDataType()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IF(dmts.DType='N','Normal','Private')DType,dtm.Name,dsm.Name SubDiet,CONCAT(em.Title,' ',Em.Name)EntryBy, ");
        sb.Append(" CONCAT(DATE_FORMAT(dmts.UpdateDate,'%d-%b-%Y'),' ',TIME_FORMAT(dmts.UpdateDate,'%h:%i %p'))EntryDateTime,dmts.DietId,dmts.SubDietID ");
        sb.Append(" FROM diet_Map_Type_SubType dmts ");
        sb.Append(" INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID = dmts.SubDietID ");
        sb.Append(" INNER JOIN diet_DietType_master dtm ON dtm.DietId = dmts.DietId ");
        sb.Append(" INNER JOIN employee_master em ON em.employeeId = dmts.UpdatedBy ");
        sb.Append(" WHERE dmts.IsDefault=1 ");

        if (rblIsPanelApproved.SelectedValue == "0")
            sb.Append(" AND dmts.DType= 'N' ");
        else
            sb.Append(" AND dmts.DType= 'P' ");

        DataTable dtDetail = StockReports.GetDataTable(sb.ToString());

        if (dtDetail.Rows.Count > 0)
        {
            grdDietType.DataSource = dtDetail;
            grdDietType.DataBind();
            btnSave.Enabled = false;   
        }
        else
        {
            grdDietType.DataSource = "";
            grdDietType.DataBind();
            btnSave.Enabled = true;   
        }        
    }

    protected void grdDietType_SelectedIndexChanged(object sender, EventArgs e)
    {
        string did = ((Label)grdDietType.SelectedRow.FindControl("lblDietID")).Text;
        string subid = ((Label)grdDietType.SelectedRow.FindControl("lblSubDietID")).Text;
        string type = ((Label)grdDietType.SelectedRow.FindControl("lblType")).Text;
        if (type == "Normal")
        {
            rblIsPanelApproved.SelectedValue = "0";
            BindDietType("0");
            BindSubDietType(did);
        }
        else
        {
            rblIsPanelApproved.SelectedValue = "1";
            BindDietType("1");
            BindSubDietType(did);
        }
        ddlDietType.SelectedValue = did;
        ddlSubDietType.SelectedValue = subid;

        btnSave.Text = "Update";
        btnSave.Enabled = true;
    }


    private void BindMenuDDL()
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT DietMenuID,NAME FROM diet_Menu_master WHERE IsActive='1' ");

        DataTable dtData = StockReports.GetDataTable(sb.ToString());
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlMenu.DataSource = dtData;
            ddlMenu.DataTextField = "NAME";
            ddlMenu.DataValueField = "DietMenuID";
            ddlMenu.DataBind();

            ddlMenu.Items.Insert(0, new ListItem("--Select--"));
        }
        else
        {
            ddlMenu.DataSource = null;
            ddlMenu.DataBind();
        }
    }

    protected void btnSaveMenu_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            var sqlCMD = "update  diet_Menu_master set IsDefault='0' where IsDefault='1'";
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
            {
            });
            var sqlCMD1 = "update  diet_Menu_master set IsDefault='1' where DietMenuID=@DietMenuID";
            excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
            {
                DietMenuID = ddlMenu.SelectedValue
            });


            tnx.Commit();
            lblmsg.Text = "Default set successfully.";

            BindMenuGrid();
            btnSaveMenu.Text = "Save";
            btnSaveMenu.Enabled = false;
            if (grdMenuDetails.Rows.Count == 0)
            {
                btnSaveMenu.Enabled = true;
            }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = "Error occurred, Please contact administrator";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
        }

        finally {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        
        }
    }

    protected void BindMenuGrid()
    {
        DataTable dtdetail = StockReports.GetDataTable("Select DietMenuID,Name,(SELECT Name FROM employee_master  WHERE  EmployeeId=iu.CreatedBy LIMIT 0, 1) AS EntryBy,DATE_FORMAT(CreatedDate,'%d-%M-%Y %r') AS EntryDateTime from diet_Menu_master iu where IsActive='1' and IsDefault='1' order by Name");
        if (dtdetail.Rows.Count > 0)
        {
            grdMenuDetails.DataSource = dtdetail;
            grdMenuDetails.DataBind();
        }
        else
        {
            grdMenuDetails.DataSource = "";
            grdMenuDetails.DataBind();
        }
    }

    protected void grdMenuDetails_SelectedIndexChanged(object sender, EventArgs e)
    {
        string dietmenu = ((Label)grdMenuDetails.SelectedRow.FindControl("lblDietMenuID")).Text;
        ddlMenu.SelectedValue = dietmenu;

        btnSaveMenu.Text = "Update";

        btnSaveMenu.Enabled = true;

    }
}
