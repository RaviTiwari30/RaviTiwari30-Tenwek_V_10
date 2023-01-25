using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;

public partial class Design_Laundry_LaundryCount : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                
                txtSearchFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtSearchToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                BindItem();
                BindDepartment();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
    }
    private void BindDepartment()
    {
            try
        {
        DataTable dtData = new DataTable();

        dtData = StockReports.GetDataTable("SELECT RoleName,DeptLedgerNo FROM f_rolemaster WHERE Active=1 AND DeptLedgerNo<>'' ORDER BY RoleName ");
            
        if (dtData.Rows.Count > 0)
        {

            ddlWard.DataSource = dtData;
            ddlWard.DataTextField = "RoleName";
            ddlWard.DataValueField = "DeptLedgerNo";
            ddlWard.DataBind();
            ddlWard.Items.Insert(0, "Select");
        }
        else
        {
            ddlWard.DataSource = null;
            ddlWard.DataBind();
        }
        }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        
    }

    private void BindItem()
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT ItemID,TypeName FROM `f_itemmaster` WHERE IsLaundry='1'");

            
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {

                ddlItem.DataSource = dt;
                ddlItem.DataTextField = "TypeName";
                ddlItem.DataValueField = "ItemID";
                ddlItem.DataBind();
                ddlItem.Items.Insert(0, "All");
            }
            else
            {
                ddlItem.DataSource = null;
                ddlItem.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    public void BindDetails(string item,string ward, string fromDate, string toDate)
    {
        try
        {
            if (ward == "Select")
            {
                lblMsg.Text = "Please Select Ward";
                return;
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT flm.LedgerName as Ward,ItemID,ItemName,SUM(WashingQty)WashingQty,SUM(DryerQty)DryerQty,SUM(IroningQty)IroningQty,");
            sb.Append(" (SUM(ReturnQty))Total FROM laundry_recieve_stock lrs inner join f_ledgermaster flm on flm.LedgerNumber=lrs.FromDept  ");
            sb.Append("  Where  DATE(ReturnDate) between '" + Util.GetDateTime(txtSearchFromDate.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("   AND '" + Util.GetDateTime(txtSearchToDate.Text).ToString("yyyy-MM-dd") + "' ");
            if (item != "All")
            {
                sb.Append(" AND ItemID='" + item + "' ");

            }
            if (ward != "Select")
            {
                sb.Append(" AND FromDept='" + ward + "' ");
            }
            sb.Append(" GROUP BY ItemID ,FromDept");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {               
                ViewState["dt"] = dt;
            }
            else
            {
                ViewState["dt"] = null;
                lblMsg.Text = "No Record Found.";                
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            lblMsg.Text = ex.Message;
        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        BindDetails(ddlItem.SelectedValue, ddlWard.SelectedValue, txtSearchFromDate.Text, txtSearchToDate.Text); 
    
        DataTable dt = new DataTable();

        dt = (DataTable)ViewState["dt"];
        if (dt != null)
        {
            DataColumn dc = new DataColumn();


            dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = " As From Date : " + Util.GetDateTime(txtSearchFromDate.Text).ToString("dd-MMM-yyyy") + " - " + " To Date : " + Util.GetDateTime(txtSearchToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            //dc.ColumnName = "UserName";
            //dc.DefaultValue = StockReports.GetUserName(Convert.ToString(HttpContext.Current.Session["ID"])).Rows[0][0];
            //dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            dt.TableName = "laundry Count";
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("D:/laundryCount.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "LaundryCount";
            string CacheName = HttpContext.Current.Session["ID"].ToString();
            Common.CreateCache(CacheName, ds);
            Response.Redirect("../Common/Commonreport.aspx?ReportName=LaundryCount");
        }
        else
        {
            lblMsg.Text = "No Record found.";
        }
                   
    }

    
    
}