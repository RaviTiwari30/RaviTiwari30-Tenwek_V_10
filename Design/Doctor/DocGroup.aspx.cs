using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Doctor_DocGroup : System.Web.UI.Page
{
    public void BindGrid()
    {
        string sql = "select ID,DocType,IsActive FROM DoctorGroup ";

        grdLabSearch.DataSource = StockReports.GetDataTable(sql);
        grdLabSearch.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtDocType.Text != "")
        {
            lblMsg.Text = "";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string strdoctorgroup = "Insert into DoctorGroup(DocType,IsActive,IPAddress,CtratedBy)";
                strdoctorgroup += "values('" + txtDocType.Text.ToString() + "'," + rbtnActive.SelectedItem.Value + ",'"+All_LoadData.IpAddress()+"','"+Session["ID"].ToString()+"')";
                txtDocType.Text = "";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strdoctorgroup);

                Tranx.Commit();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
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
        else
        {
            lblMsg.Text = "Please Enter Doctor Type";
            return;
        }
    }

    protected void grdLabSearch_RowDataBound(object sender, GridViewRowEventArgs e)
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

    protected void grdLabSearch_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (((TextBox)grdLabSearch.SelectedRow.FindControl("txtDoctype")).Text.Trim() != "")
        {
            lblMsg.Text = "";
            string Active = "";
            string Name = ((TextBox)grdLabSearch.SelectedRow.FindControl("txtDoctype")).Text.Trim();
            string ID = ((Label)grdLabSearch.SelectedRow.FindControl("lblID")).Text.Trim();
            if (((RadioButtonList)grdLabSearch.SelectedRow.FindControl("rbtnActive2")).SelectedItem.Value == "YES")
                Active = "1";
            else
                Active = "0";

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                string sql = " update doctorgroup set DocType='" + Name + "',IsActive='" + Active + "' where ID='" + ID + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                tnx.Commit();

                BindGrid();
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

        else
        {
            lblMsg.Text = "Please Enter Doctor Type";
            ((TextBox)grdLabSearch.SelectedRow.FindControl("txtDoctype")).Focus();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDocType.Focus();
            MultiView1.ActiveViewIndex = 0;
            ViewState["UID"] = Session["ID"].ToString();
            
            BindGrid();
        }
        lblMsg.Text = "";
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
            BindGrid();
        }
    }
}