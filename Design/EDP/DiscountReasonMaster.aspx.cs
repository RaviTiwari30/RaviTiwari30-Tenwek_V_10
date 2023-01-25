using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_DiscountReasonMaster : System.Web.UI.Page
{
   
    public void BindGrid()
    {
        string sql = " SELECT ID,DiscountReason,TYPE,if(Active=0,'No','Yes')Active FROM discount_reason where Type='" + ddlType2.SelectedValue + "' ";
        grdSubCategory.DataSource = StockReports.GetDataTable(sql);
        grdSubCategory.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {           
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into  discount_reason(DiscountReason,Type,CreatedBy) values('"+txtDiscountReason.Text.Trim()+"','"+ddlType.SelectedValue+"','"+Util.GetString(ViewState["UID"])+"')");           
            Tranx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            txtDiscountReason.Text = ""; ddlType.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click1(object sender, EventArgs e)
    {
        BindGrid();
    }

  
    protected void grdSubCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        string DiscountReason = "", ID = ""; int Active = 0;

        DiscountReason = ((TextBox)grdSubCategory.SelectedRow.FindControl("txtDiscountReason")).Text.Trim();
        ID = ((Label)grdSubCategory.SelectedRow.FindControl("lblID")).Text.Trim();
        if (((RadioButtonList)grdSubCategory.SelectedRow.FindControl("rbtnActive2")).SelectedItem.Value == "YES")
            Active = 1;
        else
            Active = 0;

        if (DiscountReason.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM049','" + lblMsg.ClientID + "');", true);
            ((TextBox)grdSubCategory.SelectedRow.FindControl("txtDiscountReason")).Focus();
            return;
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            string sql = " update discount_reason set DiscountReason='" + DiscountReason + "', Active='" + Active + "',UpdatedBy='" + Util.GetString(ViewState["UID"]) + "',UpdateDate=now() where ID='" + ID + "' ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);

            BindGrid();
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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            MultiView1.ActiveViewIndex = 0;
            ViewState["UID"] = Session["ID"].ToString();
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

}