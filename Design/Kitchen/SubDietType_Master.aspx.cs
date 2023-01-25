using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_Kitchen_SubDiteType_Master : System.Web.UI.Page
    {
    protected void BindGrid()
        {
        DataTable dtDetail = StockReports.GetDataTable("Select SubDietID,Name,Description,IF(IsActive=1,'Yes','No')IsActive from diet_subdiettype_master where isActive=1 order by Name");
        if (dtDetail.Rows.Count > 0)
            {
            grdDetail.DataSource = dtDetail;
            grdDetail.DataBind();
            pnlgrid.Visible = true;
            }
        else
            {
            grdDetail.DataSource = null;
            grdDetail.DataBind();
            pnlgrid.Visible = false;

            }
        btnUpdate.Visible = false;
        btnSave.Visible = true;
        }

    protected void btnMap_Click(object sender, EventArgs e)
        {
        string str = "SELECT DietID,NAME FROM diet_diettype_master WHERE isActive=1";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
            {
            ddlDietType.DataSource = dt;
            ddlDietType.DataTextField = "NAME";
            ddlDietType.DataValueField = "DietID";
            ddlDietType.DataBind();

            DataTable dtgrd = StockReports.GetDataTable("Select dsm.SubDietID,dsm.Name,dsm.Description,IF(dsm.isactive,'Yes','No')isActive,IF(IFNULL(dmts.DietID,'')='','false','true')checked from diet_subdiettype_master dsm left join diet_Map_Type_SubType dmts on dsm.SubDietID=dmts.SubDietID and  dmts.DietID='" + ddlDietType.SelectedValue.ToString() + "' where  dsm.isactive=1  order by dsm.Name");
            if (dtgrd.Rows.Count > 0)
                {
                grdsubDtl.DataSource = dtgrd;
                grdsubDtl.DataBind();
                }
            else
                {
                grdsubDtl.DataSource = null;
                grdsubDtl.DataBind();
                }
            pnlItem.Style.Add("display", "block");
           // mpeItems.Show(); 
          //  pnlItem.Style.Add("display", "block");  
            }
        else
            {
            lblmsg.Text = "No Record Found";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found');", true);
            }
        }

    protected void btnSavePOP_Click(object sender, EventArgs e)
        {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
            {
            int result = 0;

            string dietTypeID = ddlDietType.SelectedValue;
            string strdelete = "delete  from  diet_Map_Type_SubType where DietID='" + dietTypeID + "' ";
            result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strdelete);

            foreach (GridViewRow gr in grdsubDtl.Rows)
                {
                if (((CheckBox)gr.FindControl("chkselect")).Checked == true)
                    {
                    string subdietID = ((Label)gr.FindControl("lblrecord")).Text.ToString();

                    string str = "insert into diet_Map_Type_SubType (DietID,SubDietID,CreatedBy) values('" + dietTypeID + "','" + subdietID + "','" + Session["ID"].ToString() + "') ";
                    result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                    }
                }

            lblmsg.Text = "Record Saved Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
            tnx.Commit();

            }

        catch (Exception ex)
            {
            lblmsg.Text = "Error occurred, Please contact administrator";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
            tnx.Rollback();
           
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            }
        finally
            {
            tnx.Dispose();
            con.Close();
            con.Dispose();
            }
        }

    protected void Button_Command(object sender, System.Web.UI.WebControls.CommandEventArgs e)
        {
        switch (e.CommandName)
            {
            case "Save":
                Save();
                break;

            case "Update":
                Update();
                break;

            case "Clear":
                Clear();
                lblmsg.Text = "";
                break;
            }
        }

    protected void Clear()
        {
        txtTypeName.Text = "";
        txtDescription.Text = "";
        lblID.Text = "";
        rblActive.SelectedItem.Value = "1";
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        }

    protected void ddlDietType_SelectedIndexChanged(object sender, EventArgs e)
        {
        DataTable dtgrd = StockReports.GetDataTable("Select dsm.SubDietID,dsm.Name,dsm.Description,dsm.isactive,IF(IFNULL(dmts.DietID,'')='','false','true')checked from diet_subdiettype_master dsm left join diet_Map_Type_SubType dmts on dsm.SubDietID=dmts.SubDietID and  dmts.DietID='" + ddlDietType.SelectedValue.ToString() + "' where  dsm.isactive=1  order by dsm.Name");
        if (dtgrd.Rows.Count > 0)
            {
            grdsubDtl.DataSource = dtgrd;
            grdsubDtl.DataBind();
            }
        else
            {
            grdsubDtl.DataSource = null;
            grdsubDtl.DataBind();
            }
      //  mpeItems.Show();
        }

    protected void grdDetail_SelectedIndexChanged(object sender, EventArgs e)
        {
        lblmsg.Text = "";
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        string[] s = ((Label)grdDetail.SelectedRow.FindControl("lblRecord")).Text.Split('#');
        lblID.Text = s[0].ToString();
        txtTypeName.Text = s[1].ToString();
        txtDescription.Text = s[2].ToString();
        if (s[3].ToString() == "Yes")
            rblActive.SelectedIndex = 0;
        else
            rblActive.SelectedIndex = 1;
        }

    protected void Page_Load(object sender, EventArgs e)
        {
        if (!IsPostBack)
            {
            BindGrid();
            }
        }

    protected void Save()
        {
        try
            {
            lblmsg.Text = "";
            if (!Validation())
                {
                return;
                }
            StringBuilder sb = new StringBuilder();
            sb.Append(" Insert Into diet_subdiettype_master(Name,Description,IsActive,CreatedBy)");
            sb.Append(" Values('" + txtTypeName.Text.Trim() + "','" + txtDescription.Text.Trim() + "'," + rblActive.SelectedItem.Value + ",'" + Session["ID"].ToString() + "')");
            bool IsInsert = StockReports.ExecuteDML(sb.ToString());

            if (!IsInsert)
                {
                lblmsg.Text = "Error occurred, Please contact administrator";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
                return;
                }
            else
                {
                BindGrid();
                lblmsg.Text = "Record Saved Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
                Clear();
                }

            }

        catch (Exception ex)
            {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = "Error occurred, Please contact administrator";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);

            }
        }

    protected void Update()
        {
        try
            {
            lblmsg.Text = "";
            if (txtTypeName.Text.Trim() == "")
                {
                lblmsg.Text = "Enter Component Name";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Enter Component Name');", true);
                return;
                }
            int ChkNameforUpdate = Util.GetInt(StockReports.ExecuteScalar("Select COUNT(*) From diet_subdiettype_master where name='" + txtTypeName.Text.Trim() + "' AND SubDietID !=" + lblID.Text + ""));
            if (ChkNameforUpdate > 0)
                {
                lblmsg.Text = "Sub Diet Type Name Already Exists";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Sub Diet Type Name Already Exists');", true);
                return ;
                }
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update diet_subdiettype_master Set");
            sb.Append(" name='" + txtTypeName.Text.Trim() + "',Description='" + txtDescription.Text.Trim() + "',IsActive=" + rblActive.SelectedItem.Value + " where SubDietID=" + lblID.Text + "");
            bool IsUpdate = StockReports.ExecuteDML(sb.ToString());

            if (!IsUpdate)
                {
                lblmsg.Text = "Error occurred, Please contact administrator";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
                return;
                }
            else
                {
                BindGrid();
                lblmsg.Text = "Record Updated Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Updated Successfully');", true);
                Clear();
                }
            }
        catch (Exception ex)
            {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator');", true);
            lblmsg.Text = "Error occurred, Please contact administrator";

            }
        }

    protected bool Validation()
        {
        if (txtTypeName.Text.Trim() == "")
            {
            lblmsg.Text = "Please Enter Sub Diet Type";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Sub Diet Type');", true);
            return false;
            }
        int ChkNameforUpdate = Util.GetInt(StockReports.ExecuteScalar("Select  COUNT(*) From diet_subdiettype_master where name='" + txtTypeName.Text.Trim() + "'"));
        if (ChkNameforUpdate >0)
            {
            lblmsg.Text = "Sub Diet Type Name Already Exists";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Sub Diet Type Name Already Exists');", true);
            return false;
            }
        else
            return true;
        }
    }