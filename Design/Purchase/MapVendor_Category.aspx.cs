using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Purchase_MapVendor_Category : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindVendor();
            BindCategory();
            ddlSubCategory.Enabled = false;
          
        }
    }
    protected void grdHeader_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        lblMsg.Text = "";
        int index = 0;
        index = Util.GetInt(e.CommandArgument);
        string ID = ((Label)grdHeader.Rows[index].FindControl("lblID")).Text;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            string strDelete = "DELETE FROM f_Vendor_SubCategory WHERE ID='" + ID + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strDelete);



            //lblMsg.Text = "Rejected Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
            Tranx.Commit();
           
            BindGridData();


        }
        catch (Exception ex)
        {
           // lblMsg.Text = "Record Not Saved.";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
            Tranx.Rollback();
           
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            BindGridData();
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    private void BindVendor()
    {
        DataTable dtVendorList = StockReports.GetDataTable("SELECT Vendor_ID,VendorName FROM f_vendormaster");
        if (dtVendorList.Rows.Count > 0)
        {
            ddlVendor.DataSource = dtVendorList;
            ddlVendor.DataValueField = "Vendor_ID";
            ddlVendor.DataTextField = "VendorName";
            ddlVendor.DataBind();
            ddlVendor.Items.Insert(0, "Select");
        }
    }
    private void BindCategory()
    {
        DataTable dtCategory = StockReports.GetDataTable("SELECT cat.Name,cat.CategoryID from f_categorymaster cat inner join f_configrelation conf on conf.CategoryID=cat.CategoryID where conf.ConfigID in (11,28)");
        if (dtCategory.Rows.Count > 0)
        {
            ddlCategory.DataSource = dtCategory;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, "Select");
        }
    }
    private void BindSubCategory()
    {

        DataTable dtCategory = StockReports.GetDataTable("Select concat(sc.Name,' ( ',cm.Name,' )')Name,sc.SubCategoryID from f_subcategorymaster sc inner join f_configrelation cf on sc.CategoryID = cf.CategoryID inner join f_categorymaster cm on cm.CategoryID = cf.CategoryID where cf.ConfigID IN (11,28) AND cm.Name='" + ddlCategory.SelectedItem.Text + "' order by cm.Name,sc.Name");
        if (dtCategory.Rows.Count > 0)
        {
            ddlSubCategory.DataSource = dtCategory;
            ddlSubCategory.DataTextField = "Name";
            ddlSubCategory.DataValueField = "SubCategoryID";
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Insert(0, "Select");
        }
    }
    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCategory.SelectedItem.Text != "Select")
        {
            ddlSubCategory.Enabled = true;
            BindSubCategory();
        }
    }
    protected void btnMapVendor_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (ddlVendor.SelectedItem.Text == "Select")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM022','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (ddlCategory.SelectedItem.Text == "Select")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM050','" + lblMsg.ClientID + "');", true);
            return;
        }
        if (ddlSubCategory.SelectedItem.Text == "Select")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM244','" + lblMsg.ClientID + "');", true);
            return;
        }


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            DataTable dtChk = StockReports.GetDataTable("Select * from f_Vendor_SubCategory where VendorID='" + ddlVendor.SelectedItem.Value + "' and SubCategoryID='" + ddlSubCategory.SelectedItem.Value + "'");
            if (dtChk.Rows.Count > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM026','" + lblMsg.ClientID + "');", true);
                return;
            }


            string strQuery = "INSERT INTO f_Vendor_SubCategory(VendorID,CategoryID,SubCategoryID,DATE,userID)VALUES('"+ddlVendor.SelectedItem.Value+"','"+ddlCategory.SelectedItem.Value+"','"+ddlSubCategory.SelectedItem.Value+"',NOW(),'"+Util.GetString(Session["ID"])+"')";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);



            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            Tranx.Commit();
          
            BindGridData();


        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
            Tranx.Rollback();
           
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            BindGridData();
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    private void BindGridData()
    {
        DataTable dtGrid = StockReports.GetDataTable("SELECT vsg.ID,(Select VendorName From f_vendormaster where Vendor_ID=vsg.VendorID)VendorName,(select Name From f_categorymaster where CategoryID=vsg.CategoryID)CategoryName,(Select Name from f_subcategorymaster where SubcategoryID=vsg.SubCategoryID)SubCategoryName FROM  f_Vendor_SubCategory vsg where VendorID='" + ddlVendor.SelectedItem.Value + "'");
        if (dtGrid.Rows.Count > 0)
        {
            grdHeader.DataSource = dtGrid;
            grdHeader.DataBind();
        }
        else
        {
            grdHeader.DataSource = null;
            grdHeader.DataBind();
        }
    }
    protected void ddlVendor_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGridData();
    }

}
