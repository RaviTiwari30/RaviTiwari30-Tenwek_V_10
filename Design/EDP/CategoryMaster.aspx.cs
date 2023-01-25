using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_CategoryMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindCategoryType();
            MultiView1.ActiveViewIndex = 0;
        }
    }

    public void bindCategoryType()
    {
       
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(ID, '#', ConfigHelp)AS id, NAME	 FROM f_configrelation_master WHERE IsActive='1' order by NAME");
       
        ddlCategoryType.DataSource = dt;
        ddlCategoryType.DataValueField = "id";
        ddlCategoryType.DataTextField = "Name";
        ddlCategoryType.DataBind();
        lblRemarks.Text = ddlCategoryType.SelectedItem.Value.Split('#')[1];

        ddlCategoryType1.DataSource = dt;
        ddlCategoryType1.DataValueField = "id";
        ddlCategoryType1.DataTextField = "Name";
        ddlCategoryType1.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            CategoryMaster objCategoryMaster = new CategoryMaster(Tranx);

            objCategoryMaster.Name = txtName.Text.Trim();
            if (rbtnActive.SelectedItem.Value == "1")
            {
                objCategoryMaster.Active = 1;
            }
            else if (rbtnActive.SelectedItem.Value == "0")
            {
                objCategoryMaster.Active = 0;
            }
            objCategoryMaster.Abbreviation = txtAbbreviation.Text.Trim();
            objCategoryMaster.UserID = Session["ID"].ToString();
            objCategoryMaster.IPAddress = All_LoadData.IpAddress();
            string CategoryID = objCategoryMaster.Insert();

            Insert_ConfigRelation objconfigRelation = new Insert_ConfigRelation(Tranx);
            objconfigRelation.ConfigID = Util.GetInt(ddlCategoryType.SelectedItem.Value.Split('#')[0]);
            objconfigRelation.CategoryID = CategoryID;
            objconfigRelation.Name = txtName.Text.Trim();
            objconfigRelation.Insert();
            Tranx.Commit();
            clear();
            LoadCacheQuery.dropCache("Category");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
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
    protected void ddlCategoryType_SelectedIndexChanged(object sender, EventArgs e)
    {

        lblRemarks.Text = ddlCategoryType.SelectedItem.Value.Split('#')[1];
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindReturn();
    }

    private void BindReturn()
    {
        DataTable dt = new DataTable();
        string str1 = "SELECT c.ConfigID,cm.CategoryID,cm.Active,cm.Name FROM f_configrelation c inner join f_categorymaster cm on c.CategoryID= cm.Categoryid where c.ConfigID='" + ddlCategoryType1.SelectedValue.Split('#')[0] + "'";
        dt = StockReports.GetDataTable(str1);
        grdSearch.DataSource = dt;
        grdSearch.DataBind();

    }

    protected void grdSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            row = (DataRowView)e.Row.DataItem;
            e.Row.Attributes.Add("onMouseOver", "SetNewColor(this);");
            e.Row.Attributes.Add("onMouseOut", "SetOldColor(this);");


            if (((Label)e.Row.FindControl("lblActive")).Text == "1")
                ((RadioButtonList)e.Row.FindControl("rbtnActive2")).SelectedIndex = 0;
            else
                ((RadioButtonList)e.Row.FindControl("rbtnActive2")).SelectedIndex = 1;
        }
    }
    protected void grdSearch_SelectedIndexChanged1(object sender, EventArgs e)
    {
        string Name = ((TextBox)grdSearch.SelectedRow.FindControl("txtName")).Text;
        string Active = "";
        string CategoryID = ((Label)grdSearch.SelectedRow.FindControl("lblCategoryID")).Text;
        if (((RadioButtonList)grdSearch.SelectedRow.FindControl("rbtnActive2")).SelectedItem.Text == "YES")
            Active = "1";
        else
            Active = "0";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {

            string sql = " update f_categorymaster set Name='" + Name + "',Active='" + Active + "' where CategoryID='" + CategoryID + "' ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);


            sql = " update f_configrelation set Name='" + Name + "',IsActive='" + Active + "' where CategoryID='" + CategoryID + "' ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            tnx.Commit();
            LoadCacheQuery.dropCache("Category");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);

        }
        catch (Exception ex)
        {
            tnx.Rollback();         
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnStatus.SelectedItem.Text == "NEW")
        {
            MultiView1.ActiveViewIndex = 0;
        }
        else
        {
            MultiView1.ActiveViewIndex = 1;
        }

    }
    private void clear()
    {
        txtAbbreviation.Text = "";
        txtName.Text = "";
        txtOrdeno.Text = "";
        ddlCategoryType.SelectedIndex = 0;
    }
}
