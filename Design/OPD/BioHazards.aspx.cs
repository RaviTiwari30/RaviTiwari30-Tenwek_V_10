using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_BioHazards : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1)) == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                if (!IsPostBack)
                {
                    txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                    txtTimeIn.Text = System.DateTime.Now.ToString("hh:mm tt");
                    txtTimeOut.Text = System.DateTime.Now.ToString("hh:mm tt");
                    ucFromDate.Text = System.DateTime.Now.AddDays(-30).ToString("dd-MMM-yyyy");
                    ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                    BindGrid();
                }
                txtDate.Attributes.Add("readOnly", "true");
                ucFromDate.Attributes.Add("readOnly", "true");
                ucToDate.Attributes.Add("readOnly", "true");
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO BioHazards(DATE,VehicleNo,TimeIn,TimeOut,YellowCat,YellowCatbags,RedCat,RedCatBags,BlueCat,BlueCatBags,TakenBy,EntryBy) values ");
            sb.Append(" ('" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + txtVehicleNo.Text.Trim() + "','" + Util.GetDateTime(txtTimeIn.Text).ToString("hh:mm:ss") + "', ");
            sb.Append(" '" + Util.GetDateTime(txtTimeOut.Text).ToString("hh:mm:ss") + "','" + txtCatYellow.Text.Trim() + "','" + txtCatYellowBags.Text.Trim() + "','" + txtCatRed.Text.Trim() + "', ");
            sb.Append(" '" + txtCatRedBags.Text.Trim() + "','" + txtBlueCat.Text.Trim() + "','" + txtBlueCatBags.Text.Trim() + "','" + txtCollectedBy.Text.Trim() + "','" + Session["ID"].ToString() + "');");
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            if (result == 0)
            {
                tnx.Rollback();
                con.Close();
            }
            else
            {
                tnx.Commit();
                con.Close();
                clear();
                BindGrid();
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void clear()
    {
        txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        txtTimeIn.Text = DateTime.Now.ToString("hh:mm tt");
        txtTimeOut.Text = DateTime.Now.ToString("hh:mm tt");
        txtVehicleNo.Text = "";
        txtCollectedBy.Text = ""; txtCatYellowBags.Text = ""; txtCatYellow.Text = ""; txtCatRed.Text = ""; txtCatRedBags.Text = ""; txtBlueCatBags.Text = ""; txtBlueCat.Text = "";
    }

    private DataTable BindBiohazards()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,VehicleNo,DATE_FORMAT(TimeIn,'%h:%m %p')TimeIn,DATE_FORMAT(TimeOut,'%h:%m %p')TimeOut, ");
        sb.Append(" YellowCat,YellowCatbags,RedCat,RedCatBags,BlueCat,BlueCatBags,TakenBy,DATE_FORMAT(EntryDate,'%d-%b-%Y %h:%m %p')EntryDate,EntryBy as UserID, ");
        sb.Append(" (SELECT NAME FROM employee_master WHERE Employee_ID=EntryBy)EntryBy ");
        sb.Append(" FROM BioHazards WHERE Date(EntryDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND Date(EntryDate)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    private DataTable BiohazardsSummary()
    {
        DataTable dtsummary = StockReports.GetDataTable(" SELECT SUM(YellowCat) AS 'Total Yellow Cat(kg)',SUM(YellowCatBags)'Total Yellow Bags',SUM(RedCat)AS 'Total Red Cat(kg)',SUM(RedCatBags) AS 'Total Red Bags',SUM(BlueCat) AS'Total Blue Cat',SUM(BlueCatBags) 'Total Blue Bags(kg)' FROM BioHazards WHERE DATE(EntryDate)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(EntryDate)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' ");
        return dtsummary;
    }

    private void BindGrid()
    {
        DataTable dt = BindBiohazards();
        DataTable dtsummary = BiohazardsSummary();
        if (dt.Rows.Count > 0)
        {
            grdBioHazards.DataSource = dt;
            grdBioHazards.DataBind();
            lblsummary.Text = "Period From Date :" + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To Date :" + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            grdsummary.DataSource = dtsummary;
            grdsummary.DataBind();
        }
    }

    protected void grdBioHazards_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AEdit")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            lblID.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblID")).Text;
            if (((Label)grdBioHazards.Rows[id].FindControl("lblUserID")).Text != Session["ID"].ToString())
                ((ImageButton)grdBioHazards.Rows[id].FindControl("imgResult")).Enabled = false;
            else
                ((ImageButton)grdBioHazards.Rows[id].FindControl("imgResult")).Enabled = true;
            txtDate.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblDate")).Text;
            txtVehicleNo.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblVehicleNo")).Text;
            txtTimeIn.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblTimeIN")).Text;
            txtTimeOut.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblTimeOut")).Text;
            txtCatYellow.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblCatYellow")).Text;
            txtCatYellowBags.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblCatYellowBags")).Text;
            txtCatRed.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblCatRed")).Text;
            txtCatRedBags.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblCatRedBags")).Text;
            txtBlueCat.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblCatBlue")).Text;
            txtBlueCatBags.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblCatBlueBags")).Text;
            txtCollectedBy.Text = ((Label)grdBioHazards.Rows[id].FindControl("lblCollectedby")).Text;
            btnUpdate.Visible = true;
            btnSave.Visible = false;
            btnCancel.Visible = true;
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("UPDATE BioHazards SET DATE='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',VehicleNo='" + txtVehicleNo.Text.Trim() + "',TimeIn='" + Util.GetDateTime(txtTimeIn.Text).ToString("hh:mm:ss") + "', ");
            sb.Append("TimeOut='" + Util.GetDateTime(txtTimeOut.Text).ToString("hh:mm:ss") + "',YellowCat='" + txtCatYellow.Text.Trim() + "',YellowCatbags='" + txtCatYellowBags.Text.Trim() + "',RedCat='" + txtCatRed.Text.Trim() + "',RedCatBags='" + txtCatRedBags.Text.Trim() + "',BlueCat='" + txtBlueCat.Text.Trim() + "', ");
            sb.Append("BlueCatBags='" + txtBlueCatBags.Text.Trim() + "',TakenBy='" + txtCollectedBy.Text.Trim() + "',UpdateBy='" + Session["ID"].ToString() + "',updateDate=Now() ");
            sb.Append("WHERE ID='" + lblID.Text.Trim() + "' ");
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            if (result == 0)
            {
                tnx.Rollback();
                con.Close();
            }
            else
            {
                tnx.Commit();
                con.Close();
                clear();
                BindGrid();
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindGrid();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        clear();
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        btnCancel.Visible = false;
        BindGrid();
    }
}