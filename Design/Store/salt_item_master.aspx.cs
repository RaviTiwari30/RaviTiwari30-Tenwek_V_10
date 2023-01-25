using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Store_salt_item_master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            BindUnit();
            bind_item();
            btnsave.Visible = false;
            lbl_item.Visible = false;
            BindGeneric();

        }
    }

    protected void BindUnit()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("select UnitName from f_unit_master order by UnitName");

        ddlUnit.DataSource = dt;
        ddlUnit.DataTextField = "UnitName";
        ddlUnit.DataValueField = "UnitName";
        ddlUnit.DataBind();
        ddlUnit.Items.Insert(0, "");
}
    private void bind_item()
    {
        StringBuilder sb=new StringBuilder();
        sb.Append("SELECT im.ItemID, im.typename AS itemname FROM f_configrelation cf ");
        sb.Append("INNER JOIN f_subcategorymaster sc ON cf.CategoryID = sc.CategoryID INNER JOIN f_itemmaster im ");
        sb.Append(" ON sc.SubCategoryID = im.SubCategoryID WHERE cf.ConfigID=11 order by  itemname  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            
            ddl_item.DataSource = dt;
            ddl_item.DataTextField = "itemName";
            ddl_item.DataValueField = "ItemID";
            ddl_item.DataBind();

            ddl_item.Items.Insert(0, "None");

        }
    }
    protected void BindLedgerNameGrd()
    {
        StringBuilder str = new StringBuilder();
        str.Append("SELECT itm.ItemID,itm.TypeName AS ItemName,sm.name AS saltname,sm.unit,slt.ID,ifnull(slt.Quantity,'')Strength,ifnull(slt.Unit,'')strengthUnit  ");
 
        str.Append("FROM f_itemmaster itm INNER JOIN f_item_salt slt ON itm.ItemID=slt.ItemID INNER JOIN f_salt_master sm ON ");
        str.Append("sm.SaltID=slt.SaltID WHERE itm.ItemID='" + ddl_item.SelectedValue.ToString() + "' and sm.IsActive=1 order by itm.TypeName");
        
        DataTable dt = StockReports.GetDataTable(str.ToString());
        if (dt.Rows.Count > 0)
        {

            grdLedgerName.DataSource = dt;
            grdLedgerName.DataBind();
            ddl_salt.SelectedValue = null;
            //lbl1.Visible = true;

            //lbl1.Text = "Existing Salt Details";

        }
        else
        {
            //lbl1.Text = "";
            grdLedgerName.DataSource = null;
            grdLedgerName.DataBind();
            //lblmsg.Text = "No Salt details found";
        }
    }
   
    protected bool Validation()
    {
        if (ddl_item.SelectedIndex < 1)
        {
            lblmsg.Text = "Select Item";
            ddl_item.Focus();
            return false;
        }
        if (ddl_salt.SelectedItem.Value.ToUpper() == "SELECT")
        {
            lblmsg.Text = "Select Generic";
            ddl_salt.Focus();
            return false;
        }
        if (txtstrength.Text.Trim() == "")
        {
            lblmsg.Text = "Select Strength";
            txtstrength.Focus();
            return false;
        }
        return true;
    }

    protected void grdLedgerName_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdLedgerName.PageIndex = e.NewPageIndex;
        BindLedgerNameGrd();
    }



    protected void btnSelect_Click(object sender, EventArgs e)
    {
        //lblmsg.Text = "";
        //BindLedgerNameGrd();
        //lbl_item.Visible = true;
        //lbl_item.Text = ddl_item.SelectedItem.Text;
        //bind_salt();
        //btnsave.Visible = true;

    }

    private void bind_salt()
    {
        string str = " SELECT SaltID as VALUE ,NAME as Name FROM  f_salt_master WHERE IsActive=1 ORDER BY NAME ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {

            ddl_salt.DataSource = dt;

            ddl_salt.DataTextField = "Name";
            ddl_salt.DataValueField = "Value";
            ddl_salt.DataBind();

            ddl_salt.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            ddl_salt.SelectedValue = null;

        }
    
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTrans = con.BeginTransaction();
        if (Validation())
        {
            try
            {

                foreach (ListItem li in ddl_salt.Items)
                {
                    if (li.Selected)
                    {

                        int salt_id = Convert.ToInt32(li.Value);
                        string sql = "select * from f_item_salt where itemid='"+ddl_item.SelectedValue.ToString()+"' and SaltID =" + salt_id + "";
                        DataTable dt = StockReports.GetDataTable(sql);
                        if (dt.Rows.Count == 0)
                        {
                            StringBuilder objSQL = new StringBuilder();
                            objSQL.Append("INSERT INTO f_item_salt(ItemID,SaltID,Quantity,Unit,UserID)");
                            objSQL.Append("VALUES('" + ddl_item.SelectedValue.ToString() + "'," + salt_id + ",'" + txtstrength.Text + "','" + ddlUnit.SelectedValue + "','" + Session["ID"].ToString() + "')");
                            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
                            cmd.CommandType = CommandType.Text;
                            int res = cmd.ExecuteNonQuery();

                        }
                        else
                        {
                            lblmsg.Text = "Item Already Mapped";
                            return;
                        }
                    }
                }

                txtstrength.Text = "";
                ddlUnit.SelectedIndex = 0;
                objTrans.Commit();
                con.Close();
                BindLedgerNameGrd();
                lblmsg.Text = "Record Save Successfully";

            }
            catch (Exception ex)
            {
                ClassLog c1 = new ClassLog();
                c1.errLog(ex);
                objTrans.Rollback();
                objTrans.Dispose();
                con.Close();
                con.Dispose();
                lblmsg.Text = "Error..";

            }
        }

    }

   

    private void delete_item(int saltid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTrans = con.BeginTransaction();
        
            try
            {
                string str = "delete from f_item_salt where itemid='"+ddl_item.SelectedValue+"' and  ID='" + saltid + "'";

                MySqlCommand cmd = new MySqlCommand(str, objTrans.Connection, objTrans);
                cmd.CommandType = CommandType.Text;

                int res = cmd.ExecuteNonQuery();
                if (res != 0)
                {
                    objTrans.Commit();
                    con.Close();

                   // lblmsg.Text = "Salt Item deleted Successfully..";
                    
                }

            }
            catch (Exception ex)
            {
                ClassLog c1 = new ClassLog();
                c1.errLog(ex);
                objTrans.Rollback();
                objTrans.Dispose();
                con.Close();
                con.Dispose();
               // lblmsg.Text = "Error..";

            }
        
 
    }




    protected void del(object sender, GridViewDeleteEventArgs e)
    {

        Label l1 = (Label)grdLedgerName.Rows[e.RowIndex].FindControl("lblVendorId");
        int id = Convert.ToInt32(l1.Text);
        delete_item(id);
        BindLedgerNameGrd();
    }




    protected void bindpage(object sender, EventArgs e)
    {
       // lblmsg.Text = "";
        BindLedgerNameGrd();
        lbl_item.Visible = true;
        lbl_item.Text = ddl_item.SelectedItem.Text;
        lblmsg.Text = "";
        bind_salt();
        btnsave.Visible = true;
    }


    protected void btnAddSalt_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTrans = con.BeginTransaction();

        try
        {
            if (txt_lab.Text == "")
            {
                lblmsg.Text = "Enter Generic Name";
                return;
            }
            string sql = "select * from f_salt_master where Name ='" + txt_lab.Text.Trim() + "' ";
            DataTable dt = StockReports.GetDataTable(sql);
            if (dt.Rows.Count > 0)
            {
                lblmsg.Text = "Generic Name Already Exist";
                return;
            }

            string IsActive = "1";




            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("INSERT INTO f_salt_master(NAME,IsActive,UserID)");

            objSQL.Append("VALUES('" + txt_lab.Text.Trim().ToString() + "','" + IsActive + "','" + ViewState["userID"] + "')");


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.Text;

            int res = cmd.ExecuteNonQuery();
            if (res != 0)
            {
                objTrans.Commit();
                con.Close();

                lblmsg.Text = "Generic Name Saved Successfully";
                txt_lab.Text = "";
                BindLedgerNameGrd();
                bind_salt();
                BindGeneric();
            }

        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            objTrans.Rollback();
            objTrans.Dispose();
            con.Close();
            con.Dispose();
            lblmsg.Text = "Error..";

        }
    }
    private void BindGeneric()
    {
        string str = " SELECT SaltID as VALUE ,NAME as Name FROM  f_salt_master order by NAME";
        DataTable dtGeneric = StockReports.GetDataTable(str);
        if (dtGeneric != null && dtGeneric.Rows.Count > 0)
        {

            ddlGenericForEdit.DataSource = dtGeneric;

            ddlGenericForEdit.DataTextField = "Name";
            ddlGenericForEdit.DataValueField = "Value";
            ddlGenericForEdit.DataBind();
            ddlGenericForEdit.Items.Insert(0, "Select");
        }
    }
    protected void ddlGenericForEdit_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlGenericForEdit.SelectedValue != null)
        {
            txtGenericEdit.Text = ddlGenericForEdit.SelectedItem.Text;
            string Active = StockReports.ExecuteScalar("select IsActive from f_salt_master where SaltID='" + ddlGenericForEdit.SelectedItem.Value + "'");
            if (Active == "1")
                rdbActive.SelectedIndex = 0;
            else
                rdbActive.SelectedIndex = 1;


        }
        else
        {
            txtGenericEdit.Text = "";
        }
    }
    protected void btnSaveEdit_Click(object sender, EventArgs e)
    {
        
        if (ddlGenericForEdit.SelectedItem.Text == "Select")
        {
            lblerrormsg.Text = "Select Generic Name";
            mpEditGeneric.Show();
            return;
           
            
        }
        if (txtGenericEdit.Text == "")
        {
            return;
        }
        //DataTable dt = StockReports.GetDataTable("select * from f_salt_master where Name ='" + txtGenericEdit.Text.Trim() + "'");
        //if (dt.Rows.Count > 0)
        //{
        //    lblmsg.Text = "Salt Name Already Exist... ";
        //    return;
        //}

        string IsActive = rdbActive.SelectedValue;

        bool Result = StockReports.ExecuteDML("update f_salt_master set Name ='" + txtGenericEdit.Text.Trim() + "',IsActive='" + rdbActive.SelectedValue + "' where SaltID='" + ddlGenericForEdit.SelectedItem.Value + "'");
        if (Result==true)
        {
            lblmsg.Text = "Generic Edited Successfully";
            BindLedgerNameGrd();
            bind_salt();
            BindGeneric();
            txtGenericEdit.Text = "";
            rdbActive.SelectedIndex=0;
        }
    }
    protected void btnReportPopup_Click(object sender, EventArgs e)
    {
        //string strRpt = " SELECT itm.TypeName AS ItemName,sm.name AS Genericname,sm.IsActive,ifnull(slt.Quantity,'')Strength,ifnull(slt.Unit,'')strengthUnit  FROM f_itemmaster itm INNER JOIN f_item_salt slt ON itm.ItemID=slt.ItemID INNER JOIN f_salt_master sm ON sm.SaltID=slt.SaltID WHERE sm.IsActive=1 ORDER BY itm.TypeName ";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT itm.TypeName AS ItemName,CAST(GROUP_CONCAT(sm.Name,' ',IFNULL(slt.Quantity,''),' ',IFNULL(slt.Unit,'') SEPARATOR ' + ')AS CHAR)Genericname");
        sb.Append(" FROM f_itemmaster itm INNER JOIN f_item_salt slt ON itm.ItemID=slt.ItemID ");
        sb.Append(" INNER JOIN f_salt_master sm ON sm.SaltID=slt.SaltID WHERE sm.IsActive=1 ");
        sb.Append(" GROUP BY itm.TypeName");

        DataTable dtRpt = StockReports.GetDataTable(sb.ToString());
        if (dtRpt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dtRpt.Copy());
            if (rdoReportFormat.SelectedValue == "1")
            {
                //ds.WriteXmlSchema(@"c:\GenericPdfRpt.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "GenericReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                Session["dtExport2Excel"] = dtRpt;
                Session["ReportName"] = "Generic Master Report";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);

            }

        }
        else
        {
            lblmsg.Text = "Record Not Found";

        }
    }
}
