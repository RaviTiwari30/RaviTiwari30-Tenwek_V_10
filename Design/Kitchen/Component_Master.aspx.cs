using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Kitchen_Componenet_Master : System.Web.UI.Page
{
    protected void BindGrid()
    {
        DataTable dtdetail = StockReports.GetDataTable("Select ComponentID,Name,Description,IF(IsActive=1,'Yes','No')IsActive,Type,Unit,Calories,Protein,Sodium,SaturatedFat,T_Fat,Calcium,Iron,Zinc,itemID,Potassium from diet_Component_Master order by Name");
        if (dtdetail.Rows.Count > 0)
        {
            grdDetail.DataSource = dtdetail;
            grdDetail.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            grdDetail.DataSource = "";
            grdDetail.DataBind();
            pnlHide.Visible = false;

        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
        lblmsg.Text = "";
    }

    protected void btnSave_Click(object sender, EventArgs e)
        {
        lblmsg.Text = "";
        if (!Validation())
            {
            return;
            }
        int ChkNameforUpdate = Util.GetInt( StockReports.ExecuteScalar("Select COUNT(*) From diet_Component_Master where name='" + txtTypeName.Text.Trim() + "'"));
        if (ChkNameforUpdate >0)
            {
           // lblmsg.Text = "Component Name Already Exists";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Component Name Already Exists');", true);
            return;
            }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
            {
            string ItemID = "";
            if (Resources.Resource.IsDietCharged == "1")
                {
                if (Resources.Resource.DietSubcategoryID == "")
                    {
                    lblmsg.Text = "Please Create SubCategoryID";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Create SubCategoryID');", true);
                    return;
                    }
                ItemMaster objIMaster = new ItemMaster(Tranx);
                objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objIMaster.Type_ID = 0;
                objIMaster.TypeName = Util.GetString(txtTypeName.Text.Trim());
                objIMaster.Description = "";
                objIMaster.SubCategoryID = Util.GetString(Resources.Resource.DietSubcategoryID);
                objIMaster.IsEffectingInventory = "NO";
                objIMaster.IsExpirable = "No";
                objIMaster.BillingUnit = "";
                objIMaster.Pulse = "";
                objIMaster.IsTrigger = "YES";
                objIMaster.StartTime = DateTime.Now;
                objIMaster.EndTime = DateTime.Now;
                objIMaster.BufferTime = "0";
                objIMaster.IsActive = 1;
                objIMaster.QtyInHand = 0;
                objIMaster.IsAuthorised = 1;
                objIMaster.ItemCode = "";
                objIMaster.CreaterID = HttpContext.Current.Session["ID"].ToString();
                ItemID=  objIMaster.Insert().ToString();
                LoadCacheQuery.dropCache("OPDDiagnosisItems");
                }
            StringBuilder sb = new StringBuilder();
            sb.Append(" Insert Into diet_Component_Master(Name,Description,IsActive,Type,Unit,Calories,Protein,Sodium,SaturatedFat,T_Fat,Calcium,Iron,Zinc,ItemID,CreatedBy,Potassium)");
            sb.Append(" Values('" + txtTypeName.Text.Trim() + "','" + txtDescription.Text.Trim() + "'," + rblActive.SelectedItem.Value + ",'" + ddlType.SelectedItem.Text + "', ");
            sb.Append(" '" + ddlUnit.SelectedItem.Text + "','" + txtCalories.Text + "','" + txtProtein.Text + "','" + txtSodium.Text + "','" + txtSaturatedFat.Text + "','" + txtTFat.Text + "', ");
            sb.Append(" '" + txtCalcium.Text + "','" + txtIron.Text + "','" + txtZinc.Text + "','"+ItemID+"','"+Session["ID"].ToString()+"','"+ txtPotassium.Text.Trim() +"') ");

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

            Tranx.Commit();
            BindGrid();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
            Clear();
            }

        catch (Exception ex)
            {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            }
        finally
            {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            }

        }
        
      
    

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        if (!Validation())
        {
            return;
        }
        int ChkNameforUpdate = Util.GetInt(StockReports.ExecuteScalar("Select COUNT(*) From diet_Component_Master where name='" + txtTypeName.Text.Trim() + "' AND ComponentID !=" + lblID.Text+" "));
        if (ChkNameforUpdate > 0)
            {
            lblmsg.Text = "Component Name Already Exists";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Component Name Already Exists');", true);
            return;
            }
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
                {
                StringBuilder sb = new StringBuilder();
                sb.Append(" Update diet_Component_Master Set");
                sb.Append(" name='" + txtTypeName.Text.Trim() + "',Description='" + txtDescription.Text.Trim() + "',IsActive=" + rblActive.SelectedItem.Value + ",Type='" + ddlType.SelectedItem.Text + "',Unit='" + ddlUnit.SelectedItem.Text + "'");
                sb.Append(",Calories='" + txtCalories.Text + "',Protein='" + txtProtein.Text + "',Sodium='" + txtSodium.Text + "',SaturatedFat='" + txtSaturatedFat.Text + "',T_Fat='" + txtTFat.Text + "',Calcium='" + txtCalcium.Text + "',Iron='" + txtIron.Text + "',Zinc='" + txtZinc.Text + "', Potassium = '" + txtPotassium.Text + "' where ComponentID=" + lblID.Text);

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                if (Resources.Resource.IsDietCharged == "1")
                    {
                    sb.Clear();
                    sb.Append(" UPDATE f_itemmaster set TypeName='" + txtTypeName.Text.Trim() + "',IsActive=" + rblActive.SelectedItem.Value + ", ");
                    sb.Append(" IpAddress='" + HttpContext.Current.Request.UserHostAddress + "',UpdateDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', ");
                    sb.Append(" LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' Where ItemID = '" + lblItemID.Text + "' ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                    }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);
                tnx.Commit();
                BindGrid();
                Clear();
            
                }

            catch (Exception ex)
                {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                tnx.Rollback();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblmsg.ClientID + "');", true);
                }

            finally
                {
                tnx.Dispose();
                con.Close();
                con.Dispose();
                }
    }

    protected void Clear()
    {
        txtTypeName.Text = "";
        txtDescription.Text = "";
        lblID.Text = "";
        rblActive.SelectedItem.Value = "1";
        ddlType.SelectedIndex = 0;
        ddlUnit.SelectedIndex = 0;
        txtCalories.Text = "";
        txtProtein.Text = "";
        txtSodium.Text = "";
        txtSaturatedFat.Text = "";
        txtTFat.Text = "";
        txtCalcium.Text = "";
        txtIron.Text = "";
        txtZinc.Text = "";
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        txtPotassium.Text = "";
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
        ddlType.SelectedIndex = ddlType.Items.IndexOf(ddlType.Items.FindByText(s[4].ToString()));
        ddlUnit.SelectedIndex = ddlUnit.Items.IndexOf(ddlUnit.Items.FindByText(s[5].ToString()));
        txtCalories.Text = s[6];
        txtProtein.Text = s[7];
        txtSodium.Text = s[8];
        txtSaturatedFat.Text = s[9];
        txtTFat.Text = s[10];
        txtCalcium.Text = s[11];
        txtIron.Text = s[12];
        txtZinc.Text = s[13];
        lblItemID.Text = s[14];
        txtPotassium.Text = s[15];
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
            btnUpdate.Visible = false;
            btnSave.Visible = true;
        }
    }

    protected bool Validation()
    {
        if (txtTypeName.Text.Trim() == "")
        {
            lblmsg.Text = "Please Enter Component Name";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Enter Component Name');", true);
            return false;
        }
        else if (ddlType.SelectedItem.Text.ToUpper() == "SELECT")
        {
            lblmsg.Text = "Please Select Type";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Type');", true);
            return false;
        }
        else if (ddlUnit.SelectedItem.Text.ToUpper() == "SELECT")
        {
            lblmsg.Text = "Please Select Unit";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Unit');", true);
            return false;
        }
        //else if (txtCalories.Text.Trim() == "")
        //{
        //    lblmsg.Text = "Enter Component Calories";
        //    return false;
        //}
        //else if (txtProtein.Text.Trim() == "")
        //{
        //    lblmsg.Text = "Enter Component Protein";
        //    return false;
        //}
        //else if (txtSaturatedFat.Text.Trim() == "")
        //{
        //    lblmsg.Text = "Enter Component SaturatedFat";
        //    return false;
        //}
        //else if (txtSodium.Text.Trim() == "")
        //{
        //    lblmsg.Text = "Enter Component Sodium";
        //    return false;
        //}
        else
            return true;
    }
}