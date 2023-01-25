using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_NewSurgeryType : System.Web.UI.Page
{
    public void search()
    {
        DataTable dt = new DataTable();
        string str1 = "select * from f_itemmaster where IsSurgery='1' and IsActive='1'";
        dt = StockReports.GetDataTable(str1);
        grdSearch.DataSource = dt;
        grdSearch.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtSurgeryTypeName.Text == "")
        {
            txtSurgeryTypeName.Focus();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM049','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (txtShareInTotalSurgery.Text == "")
        {
            txtShareInTotalSurgery.Focus();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM169','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (rbtnBindDoctor.SelectedValue != "0" && rbtnBindDoctor.SelectedValue != "1")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM170','" + lblMsg.ClientID + "');", true);
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            string str = "SELECT SubCategoryID FROM f_subcategorymaster sc INNER JOIN f_configrelation cf ON sc.CategoryID = cf.CategoryID WHERE cf.ConfigID=22 AND sc.Active=1";
            string abc = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));
            if (abc == "")
            {
                lblMsg.Text = "Please make Sub Category First";
                return;
            }
            ItemMaster im = new ItemMaster(tnx);

            im.SubCategoryID = abc;
            im.TypeName = txtSurgeryTypeName.Text;
            im.MinLimit = Util.GetInt(txtShareInTotalSurgery.Text);
            bool Type_ID = Check_IF_BaseItem();
            if (Type_ID)
            {
                if (rbtnBaseItem.SelectedValue == "1" && rbtnBindDoctor.SelectedValue == "1")
                {
                    rbtnBaseItem.Items[0].Enabled = false;
                    rbtnBaseItem.Items[1].Selected = true;

                    lblMsg.Text = "You CanNot Select BaseItem for Calculating Total Surgery Amount & IsThisDoctor both Yes Again!";
                    return;
                }
            }
            if (rbtnBaseItem.SelectedValue == "1" && rbtnBindDoctor.SelectedValue == "1")
            {
                im.Type_ID = 1;
            }
            else if (rbtnBaseItem.SelectedValue == "0" && rbtnBindDoctor.SelectedValue == "1")
            {
                im.Type_ID = 2;
            }
            else if (rbtnBaseItem.SelectedValue == "0" && rbtnBindDoctor.SelectedValue == "0")
            {
                txtNetShareDoc.Visible = false;
                im.Type_ID = 3;
            }
            im.Description = txtSequenceNumber.Text;
            im.IsActive = 1;
            im.IsSurgery = 1;
            im.IPAddress = All_LoadData.IpAddress();
            im.CreaterID = Session["ID"].ToString();
           string itemid= im.Insert();
                                 
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO f_surgery_calculator(SurgeryID,ItemID,Percentage) ");
            sb.Append(" SELECT sm.Surgery_ID,im.ItemID,im.MinLimit FROM f_itemmaster im INNER JOIN f_surgery_master sm WHERE ItemID='" + itemid + "'");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            tnx.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            search();
            txtSurgeryTypeName.Text = "";
            txtShareInTotalSurgery.Text = "";
            txtNetShareDoc.Text = "";
            txtSequenceNumber.Text = "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void grdSearch_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        grdSearch.EditIndex = -1;
        search();
    }

    protected void grdSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            row = (DataRowView)e.Row.DataItem;

            if (((Label)e.Row.FindControl("lblTypeIDforTS")).Text == "1" && ((Label)e.Row.FindControl("lblTypeIDdoc")).Text == "1")
            {
                ((RadioButtonList)e.Row.FindControl("rbtnBase")).SelectedValue = "1";
                ((RadioButtonList)e.Row.FindControl("rbtnBindDoc")).SelectedValue = "1";
            }
            else if (((Label)e.Row.FindControl("lblTypeIDforTS")).Text == "2" && ((Label)e.Row.FindControl("lblTypeIDdoc")).Text == "2")
            {
                ((RadioButtonList)e.Row.FindControl("rbtnBase")).SelectedValue = "0";
                ((RadioButtonList)e.Row.FindControl("rbtnBindDoc")).SelectedValue = "1";
            }
            else if (((Label)e.Row.FindControl("lblTypeIDforTS")).Text == "3" && ((Label)e.Row.FindControl("lblTypeIDdoc")).Text == "3")
            {
                ((RadioButtonList)e.Row.FindControl("rbtnBase")).SelectedValue = "0";
                ((RadioButtonList)e.Row.FindControl("rbtnBindDoc")).SelectedValue = "0";
            }

            if (((RadioButtonList)e.Row.FindControl("rbtnBase")).SelectedItem.Text == "YES" && ((RadioButtonList)e.Row.FindControl("rbtnBindDoc")).SelectedItem.Text == "YES")
            {
                ((RadioButtonList)e.Row.FindControl("rbtnBase")).Items[0].Enabled = false;
                ((RadioButtonList)e.Row.FindControl("rbtnBase")).Items[1].Enabled = false;
            }
            else if (((RadioButtonList)e.Row.FindControl("rbtnBase")).SelectedItem.Text == "NO" && ((RadioButtonList)e.Row.FindControl("rbtnBindDoc")).SelectedItem.Text == "YES")
            {
                ((RadioButtonList)e.Row.FindControl("rbtnBase")).Items[0].Enabled = false;
            }
            else if (((RadioButtonList)e.Row.FindControl("rbtnBase")).SelectedItem.Text == "NO" && ((RadioButtonList)e.Row.FindControl("rbtnBindDoc")).SelectedItem.Text == "NO")
            {
                ((RadioButtonList)e.Row.FindControl("rbtnBase")).Items[0].Enabled = false;
            }
        }
    }

    protected void grdSearch_RowEditing(object sender, GridViewEditEventArgs e)
    {
        grdSearch.EditIndex = e.NewEditIndex;
        search();
    }

    protected void grdSearch_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
    }

    protected void grdSearch_SelectedIndexChanged1(object sender, EventArgs e)
    {
        string TypeName = ((TextBox)grdSearch.SelectedRow.FindControl("txtName")).Text;

        string MinLimit = ((TextBox)grdSearch.SelectedRow.FindControl("txtMinLimit")).Text;
        string TypeID = "";
        bool Type_ID = Check_IF_BaseItem();
        if (Type_ID)
        {
            if (((RadioButtonList)grdSearch.SelectedRow.FindControl("rbtnBase")).SelectedItem.Text == "YES" && ((RadioButtonList)grdSearch.SelectedRow.FindControl("rbtnBindDoc")).SelectedItem.Text == "YES")
            {
                rbtnBaseItem.Items[0].Enabled = false;
                rbtnBaseItem.Items[1].Selected = true;

                lblMsg.Text = "SORRY! BaseItemForCalculatingTotalSurgeryAmount & IsThisDoctor both cannot be Yes Again!";
                return;
            }
        }

        if (((RadioButtonList)grdSearch.SelectedRow.FindControl("rbtnBase")).SelectedItem.Text == "YES" && ((RadioButtonList)grdSearch.SelectedRow.FindControl("rbtnBindDoc")).SelectedItem.Text == "YES")
        {
            TypeID = "1";
        }
        else if (((RadioButtonList)grdSearch.SelectedRow.FindControl("rbtnBase")).SelectedItem.Text == "NO" && ((RadioButtonList)grdSearch.SelectedRow.FindControl("rbtnBindDoc")).SelectedItem.Text == "YES")
        {
            TypeID = "2";
        }
        else if (((RadioButtonList)grdSearch.SelectedRow.FindControl("rbtnBase")).SelectedItem.Text == "NO" && ((RadioButtonList)grdSearch.SelectedRow.FindControl("rbtnBindDoc")).SelectedItem.Text == "NO")
        {
            TypeID = "3";
        }

        string SequenceNo = ((TextBox)grdSearch.SelectedRow.FindControl("txtSequenceNumber")).Text;

        string ItemID = ((Label)grdSearch.SelectedRow.FindControl("lblItemID")).Text;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            string str1 = "UPDATE f_itemmaster SET TypeName='" + TypeName + "', MinLimit='" + MinLimit + "', Type_ID='" + TypeID + "',  Description='" + SequenceNo + "',LastUpdatedBy='"+ Session["ID"].ToString() +"',UpdateDate=NOW(),IPAddress='"+ All_LoadData.IpAddress() +"' WHERE ItemID='" + ItemID + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str1);

            tnx.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='NewSurgeryType.aspx';", true);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bool Type_ID = Check_IF_BaseItem();

            if (Type_ID)
            {
                lblTotalShare.Visible = false;
                rbtnBaseItem.Visible = false;
            }
            search();
        }
    }

    protected void rbtnBindDoctorList_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnBindDoctor.SelectedValue == "0")
        {
            txtNetShareDoc.Visible = false;
            lblNetShareOfDoc.Visible = false;
        }
        else if (rbtnBindDoctor.SelectedValue == "1")
        {
            txtNetShareDoc.Visible = true;
            lblNetShareOfDoc.Visible = true;
        }
    }

    private bool Check_IF_BaseItem()
    {
        try
        {
            string Type_ID = StockReports.ExecuteScalar("select Type_ID from f_itemmaster where Type_ID = '1' and IsSurgery=1");

            if (Type_ID != string.Empty)
                return true;
            else
                return false;
        }
        catch (Exception edx)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(edx);
            return false;
        }
    }
}