using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

public partial class Design_BloodBank_BloodBankComponmentMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Search();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(ComponentName) FROM bb_component_master WHERE ComponentName='" + txtComponmentName.Text.Trim() + "'"));
            if (count == 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO bb_component_master (ComponentName,AliasName,Active,isComponent,dtExpiry,Amount,isCrosschargesapply,CrossmatchValidity,EntryBy) ");
                sb.Append("VALUES ('" + txtComponmentName.Text.Trim() + "','" + txtComponentAlias.Text.Trim() + "','" + rdbActive.SelectedValue + "','" + rdbiscomponent.SelectedValue + "','" + Util.GetInt(txtExpiryDays.Text.Trim()) + "','" + Util.GetDecimal(txtrate.Text.Trim()) + "','" + rdbcrossmatch.SelectedValue + "','"+ Util.GetInt(txtCrossMatchValiditydays.Text)+"','" + Session["ID"].ToString() + "') ");
                int result = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                if (result == 1)
                {
                    tranX.Commit();
                    lblMsg.Text = "Record Save Successfully";
                    clear();
                    Search();
                }
                else
                {
                    tranX.Rollback();
                }
            }
            else
            {
                lblMsg.Text = "This Componment Name Already Exist";
                tranX.Rollback();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tranX.Rollback();
        }
        finally
        {
            tranX.Dispose();
            con.Close();    
            con.Dispose();
        }
    }
    private void clear()
    {
        txtComponmentName.Text = "";
        txtComponentAlias.Text = "";
        txtExpiryDays.Text = "";
        txtrate.Text = "";
        rdbActive.SelectedIndex = 0;
        rdbcrossmatch.SelectedIndex = 0;
        rdbiscomponent.SelectedIndex = 0;
        txtCrossMatchValiditydays.Text = "";
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        lblComponentID.Text = "";
    }
    private void Search()
    {
        StringBuilder sb= new StringBuilder();
        sb.Append("SELECT bcm.ID,bcm.ComponentName,bcm.AliasName,bcm.Amount,bcm.dtExpiry,if(bcm.Active='1','Yes','No')Active,IF(bcm.isComponent='1','Yes','No')isComponent, ");
        sb.Append("if(bcm.isCrosschargesapply='1','Yes','No')isCrosschargesapply,date_format(bcm.EntryDate,'%d-%b-%y')EntryDate,CONCAT(em.Title,'',em.Name)EmployeeName,bcm.CrossmatchValidity ");
        sb.Append("FROM bb_component_master bcm INNER JOIN employee_master em ON em.EmployeeID=bcm.EntryBy ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdbbComponment.DataSource = dt;
            grdbbComponment.DataBind();
        }
    }
    protected void grdbbComponment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            int index1 = Convert.ToInt32(e.CommandArgument);
            txtComponmentName.Text = ((Label)grdbbComponment.Rows[index1].FindControl("lblComponmentName")).Text;
            txtComponentAlias.Text = ((Label)grdbbComponment.Rows[index1].FindControl("lblComponentalias")).Text;
            txtCrossMatchValiditydays.Text = ((Label)grdbbComponment.Rows[index1].FindControl("lblCrossMatchValidityDays")).Text;
            txtExpiryDays.Text = ((Label)grdbbComponment.Rows[index1].FindControl("lblExpiryDays")).Text;
            txtrate.Text = ((Label)grdbbComponment.Rows[index1].FindControl("lblAmount")).Text;
            if (((Label)grdbbComponment.Rows[index1].FindControl("lblIsCrossMatchApply")).Text == "Yes")
                rdbcrossmatch.SelectedIndex = 0;
            else
                rdbcrossmatch.SelectedIndex = 1;

            if (((Label)grdbbComponment.Rows[index1].FindControl("lbliscomponent")).Text == "Yes")
                rdbiscomponent.SelectedIndex = 0;
            else
                rdbiscomponent.SelectedIndex = 1;

            if (((Label)grdbbComponment.Rows[index1].FindControl("lblActive")).Text == "Yes")
                rdbActive.SelectedIndex = 0;
            else
                rdbActive.SelectedIndex = 1;
            btnUpdate.Visible = true;
            btnSave.Visible = false;
            lblComponentID.Text = ((Label)grdbbComponment.Rows[index1].FindControl("lblID")).Text;
        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (lblComponentID.Text != "")
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" UPDATE bb_component_master SET ComponentName = '"+txtComponmentName.Text.Trim()+"',AliasName = '"+txtComponentAlias.Text.Trim()+"',Active = '"+rdbActive.SelectedValue+"', ");
                    sb.Append(" isComponent = '"+rdbiscomponent.SelectedValue+"',dtExpiry = '"+Util.GetInt(txtExpiryDays.Text.Trim())+"',Amount = '"+Util.GetDecimal(txtrate.Text.Trim())+"',isCrosschargesapply = '"+rdbcrossmatch.SelectedValue+"', ");
                    sb.Append(" CrossmatchValidity = '" + Util.GetInt(txtCrossMatchValiditydays.Text.Trim()) + "', UpdateBy='" + Session["ID"].ToString() + "' ");
                    sb.Append(" WHERE Id = '"+lblComponentID.Text+"' ");
                    int result = MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                    if (result == 1)
                    {
                        tranX.Commit();
                        lblMsg.Text = "Record Update Successfully";
                        clear();
                        Search();
                    }
                    else
                    {
                        tranX.Rollback();
                    }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                tranX.Rollback();
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }
}