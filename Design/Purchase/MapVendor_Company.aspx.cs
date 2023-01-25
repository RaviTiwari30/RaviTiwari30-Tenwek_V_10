using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Purchase_MapVendor_Company : System.Web.UI.Page
    {
    protected void Page_Load(object sender, EventArgs e)
        {
        if (!IsPostBack)
            {
            BindVendor();
            AllLoadData_Store.bindManufacture(ddlmanufacture, "Select");
            }
        }

    private void BindGridData()
        {
        DataTable dtGrid = StockReports.GetDataTable("SELECT vsg.ID,(Select VendorName From f_vendormaster where Vendor_ID=vsg.VendorID)VendorName,(select Name From f_manufacture_master where MAnufactureID=vsg.ManufactureID)CompanyName FROM  f_Vendor_Company vsg where VendorID='" + ddlVendor.SelectedItem.Value + "'");
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
            string strDelete = "DELETE FROM f_Vendor_Company WHERE ID='" + ID + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strDelete);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
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

    protected void btnMapVendor_Click(object sender, EventArgs e)
        {
        lblMsg.Text = "";
        if (ddlVendor.SelectedItem.Text == "Select")
            {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM022','" + lblMsg.ClientID + "');", true);
            return;
            }
        if (ddlmanufacture.SelectedItem.Text == "Select")
            {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM245','" + lblMsg.ClientID + "');", true);
            return;
            }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
            {
            int dtChk = Util.GetInt(StockReports.ExecuteScalar("Select COUNT(*) from f_Vendor_Company where VendorID='" + ddlVendor.SelectedItem.Value + "' and ManufactureID='" + ddlmanufacture.SelectedItem.Value + "'"));
            if (dtChk > 0)
                {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM246','" + lblMsg.ClientID + "');", true);
                return;
                }

            string strQuery = "INSERT INTO f_Vendor_Company(VendorID,ManufactureID,DATE,userID)VALUES('" + ddlVendor.SelectedItem.Value + "','" + ddlmanufacture.SelectedItem.Value + "',NOW(),'" + Util.GetString(Session["ID"]) + "')";
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
    }