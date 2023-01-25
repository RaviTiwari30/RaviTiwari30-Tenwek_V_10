using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_HelpDesk_ViewBreakDownRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindDepartment();
            BindAllError();
            errortype();
            dgGrid.Visible = false;
            lblMsg.Visible = false;
            ToDatecal.EndDate = DateTime.Now;
            Calendarextender1.EndDate = DateTime.Now;
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly","true");
        txtToDate.Attributes.Add("readOnly","true");
    }

    public void BindAllError()
    {
        DataTable dt = StockReports.GetDataTable("SELECT * FROM err_ErrorName");
        if (dt.Rows.Count > 0) 
        {
            ddlActualError.DataSource = dt;
            ddlActualError.DataTextField = "ErrorName";
            ddlActualError.DataValueField = "ErrorId";
            ddlActualError.DataBind();
            ddlActualError.Items.Insert(0, new ListItem("Select", "0"));

            ddlHODError.DataSource = dt;
            ddlHODError.DataTextField = "ErrorName";
            ddlHODError.DataValueField = "ErrorId";
            ddlHODError.DataBind();
            ddlHODError.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    public void BindDepartment()
    {
       // DataTable dt = StockReports.GetDataTable(" SELECT rm.ID, rm.RoleName FROM f_rolemaster rm INNER JOIN ticket_error_type et ON et.RoleID=rm.ID WHERE rm.Active=1 AND rm.ID!='" + ViewState["RoleID"] + "' GROUP BY rm.ID ORDER BY rm.RoleName ");
        DataTable dt = StockReports.GetDataTable("SELECT DISTINCT ID, RoleName FROM f_rolemaster rm INNER JOIN ticket_master tm ON tm.RoleId=rm.ID WHERE rm.ID!='" + Session["RoleID"] + "'");
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "RoleName";
            ddlDepartment.DataValueField = "ID";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void errortype()
    {
        DataTable dt = StockReports.GetDataTable("SELECT RoleID,error_id,error_type FROM  ticket_error_type WHERE  RoleID='" + Session["RoleID"] + "' AND IsActive=1 order by error_type ");
        if (dt.Rows.Count > 0)
        {
            ddlErrorType.DataSource = dt;
            ddlErrorType.DataTextField = "Error_type";
            ddlErrorType.DataValueField = "Error_id";
            ddlErrorType.DataBind();
           // ddlErrorType.Items.Insert(0, new ListItem("Select", "0"));
            ddlErrorType.Items.Insert(0, new ListItem("ALL", "0"));
        }
        else
        {
            ddlErrorType.DataSource = dt;
            ddlErrorType.DataBind();
            ddlErrorType.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataSet ds = new DataSet();
        int deptID = Convert.ToInt32(ddlDepartment.SelectedValue);
        string type = ddlErrorType.SelectedItem.Text;
        int status = Convert.ToInt32(ddlStatus.SelectedValue);
        string laststatus = "";
        if (status == 1)
        {
            laststatus = "Assigned";
        }
        else if (status == 2)
        {
            laststatus = "Viewed";
        }
        else if (status == 3)
        {
            laststatus = "Visited";
        }
        else if (status == 4) { laststatus = "Resolved"; }
        else if (status == 5) { laststatus = "Closed"; }
        else if (status == 6) { laststatus = "All"; }
        else if (status == 7) { laststatus = "Processed"; }
        string fDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");
        string tDate = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");

        ds = SearchBreakDownRequest(deptID, type, laststatus, fDate, tDate);
        int rowcount;
        rowcount = ds.Tables[0].Rows.Count;
        if (rowcount > 0)
        {
            dgGrid.DataSource = ds;
            dgGrid.DataBind();
            dgGrid.Visible = true;
            lblMsg.Visible = false;
        }
        else { dgGrid.Visible = false; lblMsg.Visible = true; lblMsg.Text = "Data not found"; }
    }

    public DataSet SearchBreakDownRequest(int deptid, string type, string status,string frmdt, string todate)
    {
        string currUser = Session["ID"].ToString();
        DataSet ds = new DataSet();
        MySqlDataAdapter Adp = new MySqlDataAdapter();
        StringBuilder sb = new StringBuilder();
        //MySqlConnection con = new MySqlConnection();
        //con = Util.GetMySqlCon();
        //con.Open();

        string query = "";

        //if (status == "All" && type == "ALL")
        //{
        //    query = "SELECT tm.TicketID,tm.AssignedBy,tet.`Error_type`, tm.Description,rm.RoleName,im.ItemName TypeName,tm.Date,em.Name,tet.EmployeeID,tm.Attachment_Name," +
        //            "tm.AssetName,tet.Error_id,tm.StockID,ab.lastStatus FROM ticket_master tm INNER JOIN f_rolemaster rm ON rm.ID=tm.RoleID INNER JOIN " +
        //            "f_stock im ON im.StockID=tm.StockID INNER JOIN ticket_error_type tet ON tet.Error_id=tm.ErrorTypeID LEFT JOIN employee_master em " +
        //            "ON em.EmployeeID=tet.EmployeeID INNER JOIN ass_breakdown ab ON ab.`TicketID`=tm.`TicketID` " +
        //            "WHERE CAST(tm.Date AS DATE) BETWEEN '" + frmdt + "' AND '" + todate + "' AND tm.ErrorDeptID='" + Session["RoleID"] + "' AND tm.RoleID=@RoleID AND AssignedBy IS NOT NULL "+
        //            "AND tm.Assigned_Engineer_ID=@Assigned_Engineer_ID";
        //}
        //else if (type == "ALL")
        //{
        //    query = "SELECT tm.TicketID,tm.AssignedBy,tet.`Error_type`, tm.Description,rm.RoleName,im.ItemName TypeName,tm.Date,em.Name,tet.EmployeeID,tm.Attachment_Name," +
        //        "tm.AssetName,tet.Error_id,tm.StockID,ab.lastStatus FROM ticket_master tm INNER JOIN f_rolemaster rm ON rm.ID=tm.RoleID INNER JOIN " +
        //        "f_stock im ON im.StockID=tm.StockID INNER JOIN ticket_error_type tet ON tet.Error_id=tm.ErrorTypeID LEFT JOIN employee_master em " +
        //        "ON em.EmployeeID=tet.EmployeeID INNER JOIN ass_breakdown ab ON ab.`TicketID`=tm.`TicketID` " +
        //        "WHERE CAST(tm.Date AS DATE) BETWEEN '" + frmdt + "' AND '" + todate + "' AND tm.ErrorDeptID='" + Session["RoleID"] + "' AND ab.lastStatus=@lastStatus AND tm.RoleID=@RoleID AND AssignedBy IS NOT NULL "+
        //        "AND tm.Assigned_Engineer_ID=@Assigned_Engineer_ID";
        //}
        //else if (status == "All")
        //{
        //    query = "SELECT tm.TicketID,tm.AssignedBy,tet.`Error_type`, tm.Description,rm.RoleName,im.ItemName TypeName,tm.Date,em.Name,tet.EmployeeID,tm.Attachment_Name," +
        //            "tm.AssetName,tet.Error_id,tm.StockID,ab.lastStatus FROM ticket_master tm INNER JOIN f_rolemaster rm ON rm.ID=tm.RoleID INNER JOIN " +
        //            "f_stock im ON im.StockID=tm.StockID INNER JOIN ticket_error_type tet ON tet.Error_id=tm.ErrorTypeID LEFT JOIN employee_master em " +
        //            "ON em.EmployeeID=tet.EmployeeID INNER JOIN ass_breakdown ab ON ab.`TicketID`=tm.`TicketID` " +
        //            "WHERE CAST(tm.Date AS DATE) BETWEEN '" + frmdt + "' AND '" + todate + "' AND tm.ErrorDeptID='" + Session["RoleID"] + "' AND tet.`Error_type`=@Error_type AND tm.RoleID=@RoleID AND AssignedBy IS NOT NULL "+
        //            "AND tm.Assigned_Engineer_ID=@Assigned_Engineer_ID";
        //}
        //else
        //{
        //    query = "SELECT tm.TicketID,tm.AssignedBy,tet.`Error_type`, tm.Description,rm.RoleName,im.ItemName TypeName,tm.Date,em.Name,tet.EmployeeID,tm.Attachment_Name," +
        //            "tm.AssetName,tet.Error_id,tm.StockID,ab.lastStatus FROM ticket_master tm INNER JOIN f_rolemaster rm ON rm.ID=tm.RoleID INNER JOIN " +
        //            "f_stock im ON im.StockID=tm.StockID INNER JOIN ticket_error_type tet ON tet.Error_id=tm.ErrorTypeID LEFT JOIN employee_master em " +
        //            "ON em.EmployeeID=tet.EmployeeID INNER JOIN ass_breakdown ab ON ab.`TicketID`=tm.`TicketID` " +
        //            "WHERE CAST(tm.Date AS DATE) BETWEEN '" + frmdt + "' AND '" + todate + "' AND tm.ErrorDeptID='" + Session["RoleID"] + "' AND tet.`Error_type`=@Error_type AND ab.lastStatus=@lastStatus AND tm.RoleID=@RoleID AND AssignedBy IS NOT NULL "+
        //            "AND tm.Assigned_Engineer_ID=@Assigned_Engineer_ID";
        //}

        sb.Append("SELECT tm.TicketID,tm.AssignedBy,tet.`Error_type`, tm.Description,rm.RoleName,im.ItemName TypeName,tm.Date,em.Name,tet.EmployeeID,tm.Attachment_Name,tm.AssetName,tet.Error_id,tm.StockID,ab.lastStatus,  ");
        sb.Append(" CASE WHEN ab.lastStatus='Assigned' THEN 'View' WHEN  ab.lastStatus='Viewed' THEN 'Visit' WHEN ab.lastStatus='Visited' THEN 'Process' WHEN ab.lastStatus='Processed' THEN 'Resolve' WHEN ab.lastStatus='Resolved' THEN 'Close' END 'btnText',IF(ab.lastStatus='Closed','Disabl','Enabl') 'Display'  ");
        sb.Append(" FROM ticket_master tm INNER JOIN f_rolemaster rm ON rm.ID=tm.RoleID INNER JOIN f_stock im ON im.StockID=tm.StockID INNER JOIN ticket_error_type tet ON tet.Error_id=tm.ErrorTypeID LEFT JOIN employee_master em ON em.EmployeeID=tet.EmployeeID ");
        sb.Append(" INNER JOIN ass_breakdown ab ON ab.`TicketID`=tm.`TicketID` WHERE DATE(tm.`Date`)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND  DATE(tm.`Date`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" AND tm.ErrorDeptID='" + Session["RoleID"] + "' AND tm.RoleID='" + deptid + "' AND AssignedBy IS NOT NULL AND tm.Assigned_Engineer_ID='"+currUser+"'  ");
        if (type != "ALL")
        {
            sb.Append(" AND tet.`Error_type`='" + type + "' ");
        }
        if (ddlStatus.SelectedItem.Text != "All")
        {
            sb.Append(" AND ab.lastStatus='" + ddlStatus.SelectedItem.Text + "' ");
        }
        if (ddlAssetName.SelectedIndex>0)
        {
            sb.Append(" AND tm.`AssetName`='" + ddlAssetName.SelectedItem.Text + "' ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ds.Tables.Add(dt.Copy());

        //using (MySqlCommand cmd = new MySqlCommand(query, con))
        //{
        //    cmd.CommandType = CommandType.Text;
        //    cmd.Parameters.AddWithValue("@RoleID", deptid);
        //    cmd.Parameters.AddWithValue("@Error_type", type);
        //    cmd.Parameters.AddWithValue("@Assigned_Engineer_ID", currUser);
        //    cmd.Parameters.AddWithValue("@lastStatus", status);

        //    Adp.SelectCommand = cmd;
        //    Adp.Fill(ds);
        //}

        return ds;
    }

    protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        //errortype();
    }
    protected void ddlErrorType_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dt;
        if (ddlErrorType.SelectedItem.Text == "ALL")
        {
            dt = StockReports.GetDataTable("SELECT AssetName FROM ticket_master WHERE ErrorDeptID='" + Session["RoleID"] + "'");
        }
        else
        {
            dt = StockReports.GetDataTable("SELECT AssetName FROM ticket_master WHERE ErrorTypeID='" + Convert.ToInt32(ddlErrorType.SelectedValue) + "' AND ErrorDeptID='" + Session["RoleID"] + "'");
        }
        
        if (dt.Rows.Count > 0)
        {
            ddlAssetName.DataSource = dt;
            ddlAssetName.DataTextField = "AssetName";
            ddlAssetName.DataValueField = "AssetName";
            ddlAssetName.DataBind();

            ddlAssetName.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    protected void dgGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string assignedby = e.CommandName.ToString();
        if (assignedby != "0")
        {
            int stock = Convert.ToInt32(e.CommandArgument.ToString());

            Button lbl = (Button)e.CommandSource;
            GridViewRow row = (GridViewRow)lbl.NamingContainer;
            int id = Convert.ToInt32(dgGrid.DataKeys[row.RowIndex].Value);

            string status = GetLastSataus(id);
            int statusID = 0;
            if (status == "Viewed")
            {
                statusID = 2;
            }
            else if (status == "Visited")
            {
                statusID = 3;
            }
            else if (status == "Resolved")
            {
                statusID = 4;
            }
            else if (status == "Processed")
            {
                statusID = 7;
            }
            else { statusID = 1; }

            //if (status != "Visited")
            //{
                ChangeStatus(id, statusID);
           // }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "script", "ShowAssetDetails('" + stock + "','" + id + "','" + assignedby + "')", true);
        }
    }

    protected void dgGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            object objTemp = dgGrid.DataKeys[e.Row.RowIndex].Value as object;
            if (objTemp != null)
            {
                int id = Convert.ToInt32(objTemp.ToString());
                string status = GetLastSataus(id);
                ((Label)e.Row.FindControl("lblLastStatus")).Text = status;
            }
            //if (id == "0")
            //{
            //    ((Label)e.Row.FindControl("lblStatus")).Text = "Pending";
            //    //  ((Button)e.Row.FindControl("ibmEdit")).Visible = true;
            //    // ((Button)e.Row.FindControl("ibmTransfer")).Visible = false;
            //}
            //else
            //{
            //    ((Label)e.Row.FindControl("lblStatus")).Text = "Assigned";
            //    //    ((Button)e.Row.FindControl("ibmTransfer")).Visible = true;
            //    //((Button)e.Row.FindControl("ibmEdit")).Visible = false;
            //}
        }
    }

    public string GetLastSataus(int ticketID)
    { 
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string status = "";
        int count = 0;

        string query = "SELECT DISTINCT lastStatus FROM ass_breakdown WHERE TicketID=@TicketID";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketID);
            status = cmd.ExecuteScalar().ToString();
            cmd.Parameters.Clear();
            con.Close();
        }

        if (status == "Visited" || status == "Resolved" || status == "Close")
        {
            IDstatus.Visible = true;
            IDstatus.Text = status;
        }
        return status;
    }

    [WebMethod(EnableSession = true)] // 
    public static string[] BindAssetDetails(int stockID)
    {
        DataSet ds = new DataSet();
        MySqlDataAdapter Adp = new MySqlDataAdapter();
        MySqlDataReader dr;

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "SELECT st.ItemName,st.StockID,ast.SerialNo," +
        "IF(EM.WarrantyTo<=CURDATE(),CONCAT('Expired(Before ',DATEDIFF(CURDATE(),EM.WarrantyTo),' Days)'),CONCAT('Available(Next ',DATEDIFF(EM.WarrantyTo,CURDATE()),' Days)'))WarrantyStatus," +
        "DATE_FORMAT(EM.WarrantyTo,'%d-%b-%Y')WarrantyDate,ast.WarrantyNo," +
        "(SELECT LM.LedgerName FROM f_stock s INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=s.VenLedgerNo WHERE s.StockID=ST.StockID)WarrantyVendor," +
        "'N/A' AMCStatus ,'N/A' AMCDate,'N/A' AMCNo,'N/A' AMCVendor,'N/A' CMCStatus ,'N/A' CMCDate,'N/A' CMCNo,'N/A' CMCTo,'N/A' AMCTo,'N/A' CMCVendor FROM f_stock st  " +
        "INNER JOIN ass_assetstock ast ON ast.GRNStockID=st.StockID INNER JOIN eq_asset_master em ON em.assetid=ast.assetid WHERE st.IsAsset=1 AND st.StockID=@StockID";

        string itemname, warentystatus, Wvendor, amcstatus, Avendor, Cstatus, Cvendor, Adt, CMCDt,cmcto,amcto,Wnum, all = "";
        int stockid, serial, Anum = 0, Cnum = 0;
        DateTime dt = DateTime.Now;
        DateTime Cdt = DateTime.Now;

        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@StockID", stockID);

            dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                itemname = dr["ItemName"].ToString();
                stockid = Convert.ToInt32(dr["StockID"]);
                serial = Convert.ToInt32(dr["SerialNo"]);
                warentystatus = dr["WarrantyStatus"].ToString();
                dt = Convert.ToDateTime(dr["WarrantyDate"]);
                Wvendor = dr["WarrantyVendor"].ToString();
                amcstatus = dr["AMCStatus"].ToString();
                Avendor = dr["AMCVendor"].ToString();
                Cstatus = dr["CMCStatus"].ToString();
                Cvendor = dr["CMCVendor"].ToString();
                Adt = dr["AMCDate"].ToString();
                Wnum = dr["WarrantyNo"].ToString();
                CMCDt = dr["CMCDate"].ToString();
                cmcto = dr["CMCTo"].ToString();
                amcto = dr["AMCTo"].ToString();

                all = itemname + "," + stockid + "," + serial + "," + warentystatus + "," + dt + "," + Wvendor + "," + amcstatus + "," + Avendor + "," + Cstatus + "," + Cvendor + "," + Adt + "," + Wnum + "," + Anum + "," + Cnum + "," + CMCDt + "," + cmcto + "," + amcto;
            }
        }

        string[] a = all.Split(',');

        con.Close();
        dr.Close();

        return a;
    }

    public void ChangeStatus(int ticketID, int status) // 
    {
        //MySqlConnection con = new MySqlConnection();
        //con = Util.GetMySqlCon();
        //con.Open();
        //string query = "";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        string query = "";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            if (status == 1)  // viewed
            {
                query = "UPDATE ass_breakdown SET lastStatus='Viewed' WHERE TicketID='" + ticketID + "'";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, query);
                //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update ticket_master set IsView=1 where TicketId=" + ticketID + "");
            }
            else if (status == 2) // visit 
            {
                query = "UPDATE ass_breakdown SET lastStatus='Visited' WHERE TicketID='" + ticketID + "'";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, query);
                //     MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update ticket_master set IsVisit=1, LastUpdate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where TicketId=" + ticketID + "");

        }
        else if (status == 3)  // resolved
        {
            query = "UPDATE ass_breakdown SET lastStatus='Resolved' WHERE TicketID='" + ticketID + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, query);
      //      MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update ticket_master set IsResolved=1 where TicketId=" + ticketID + "");

        }
        else if (status == 4) // closed
        {
            query = "UPDATE ass_breakdown SET lastStatus='Closed' WHERE TicketID='" + ticketID + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, query);
       //     MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update ticket_master set IsVisit=1 where TicketId=" + ticketID + "");

        }
        //else if (status == 7) // Process
        //{
        //    query = "UPDATE ass_breakdown SET lastStatus='Processed' WHERE TicketID='" + ticketID + "'";
        //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, query);
        //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update ticket_master set IsVisit=1 where TicketId=" + ticketID + "");

        //}

        Tranx.Commit();
        
        //using (MySqlCommand cmd = new MySqlCommand(query, con))
        //{
        //    cmd.CommandType = CommandType.Text;
        //    cmd.Parameters.AddWithValue("@TicketID", ticketID);
        //    cmd.ExecuteNonQuery();

        //    GetIDOfBreakDown(ticketID);
        //    SaveView(ticketID);
        //}

        GetIDOfBreakDown(ticketID);
        SaveView(ticketID);

        if (status == 2)
        {
            UpdateVisit(ticketID);
        }
        if (status == 3)
        {
            UpdateResolved(ticketID);
        }
        if (status == 4)
        {
            UpdateClose(ticketID);
        }
    }

    public void UpdateClose(int ticketid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "UPDATE ticket_master SET IsClose=1 WHERE TicketID=@TicketID";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketid);
            cmd.ExecuteNonQuery();
            cmd.Parameters.Clear();
            con.Close();
        }
    }

    public void SaveView(int ticketid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "UPDATE ticket_master SET IsView=1 WHERE TicketID=@TicketID";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketid);
            cmd.ExecuteNonQuery();
            cmd.Parameters.Clear();
            con.Close();
        }
    }

    public void GetIDOfBreakDown(int ticketid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int Id = 0;

        string query = "SELECT Id FROM ass_breakdown WHERE TicketID=@TicketID";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketid);
            Id = Convert.ToInt32(cmd.ExecuteScalar());

            int count = 0;
            count = CountViewdDetails(ticketid, Id);

            if (count == 0)
            {
                SaveBreakDownDetails(ticketid, Id);
            }
        }
    }

    public int CountViewdDetails(int ticketid, int assetticketid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int count = 0;
        string query = "SELECT COUNT(*) FROM ass_BreakDownDetails WHERE TicketID=@TicketID AND AssetTicketID=@AssetTicketID AND STATUS='Viewed'";

        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketid);
            cmd.Parameters.AddWithValue("@AssetTicketID", assetticketid);
            count = Convert.ToInt32(cmd.ExecuteScalar());
            cmd.Parameters.Clear();
            con.Close();
        }

        return count;
    }

    public int GetMaxIdOfBreakDownDetails()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int maxID = 0;

        string query = "SELECT IFNULL(MAX(Id),0)AS Id FROM ass_BreakDownDetails";
        using (MySqlCommand cmd = new MySqlCommand(query,con))
        {
            cmd.CommandType = CommandType.Text;
            maxID = Convert.ToInt32(cmd.ExecuteScalar());
            cmd.Parameters.Clear();
            con.Close();
        }

        return maxID;
    }

    public static int GetMaxIdBreakDownDetails()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int maxID = 0;

        string query = "SELECT IFNULL(MAX(Id),0)AS Id FROM ass_BreakDownDetails";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            maxID = Convert.ToInt32(cmd.ExecuteScalar());
            cmd.Parameters.Clear();
            con.Close();
        }

        return maxID;
    }

    public void SaveBreakDownDetails(int ticketId, int assetTicketId)
    {
        DataSet ds = new DataSet();
        MySqlDataAdapter Adp = new MySqlDataAdapter();

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query1 = "SELECT * FROM ass_BreakDownDetails WHERE TicketID=@TicketID AND AssetTicketID=@AssetTicketID";
        using (MySqlCommand cmd1 = new MySqlCommand(query1, con))
        {
            cmd1.CommandType = CommandType.Text;
            cmd1.Parameters.AddWithValue("@TicketID", ticketId);
            cmd1.Parameters.AddWithValue("@AssetTicketID", assetTicketId);

            Adp.SelectCommand = cmd1;
            Adp.Fill(ds);
        }

        string query2 = "";
        int rowcount;
        rowcount = ds.Tables[0].Rows.Count;
        if (rowcount > 0)
        {
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                int id = GetMaxIdOfBreakDownDetails();      //Convert.ToInt32(dr["Id"]);
                id++;
                string comment = dr["Comments"].ToString();
                string additionalcoment = dr["AdditionalComment"].ToString();
                string assignedto = dr["AssignedTo"].ToString();
                string status="Viewed";

                query2 = "INSERT INTO ass_BreakDownDetails(Id,AssetTicketID,TicketID,Comments,AdditionalComment,EntryBy,EntryDateTime,STATUS,AssignedTo) VALUES('" + id + "','" + assetTicketId + "','" + ticketId + "','" + comment + "','" + additionalcoment + "','" + HttpContext.Current.Session["ID"].ToString() + "',CURDATE(),'" + status + "','" + assignedto + "')";
                using (MySqlCommand cmd2 = new MySqlCommand(query2, con))
                {
                    cmd2.CommandType = CommandType.Text;
                    cmd2.ExecuteNonQuery();
                }
            }
        }
    }

    public static string GetMaxErrorID()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string maxId = "";

        string query = "SELECT IFNULL(MAX(ErrorId),0) FROM err_ErrorName";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            maxId = cmd.ExecuteScalar().ToString();
            con.Close();
        }

        return maxId;
    }

    [WebMethod(EnableSession = true)] // 
    public static string SaveNewError(string Error)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        using (MySqlTransaction tr = con.BeginTransaction())
        {
            try
            {
                string query = "INSERT INTO err_ErrorName(ErrorName) VALUES(@ErrorName)";
                using (MySqlCommand cmd = new MySqlCommand(query, con, tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@ErrorName", Error);
                    cmd.ExecuteNonQuery();
                    tr.Commit();
                    cmd.Parameters.Clear();
                    con.Close();
                }
            }
            catch { tr.Rollback(); }
        }

        string maxid = GetMaxErrorID();
        return Newtonsoft.Json.JsonConvert.SerializeObject(maxid);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string UpdateVisit(int ticketID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "UPDATE ticket_master SET IsVisit=1 WHERE TicketID=@TicketID";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketID);
            cmd.ExecuteNonQuery();
            cmd.Parameters.Clear();
        }

        string query2 = "UPDATE ass_breakdown SET lastStatus='Visited' WHERE TicketID=@TicketID";
        using (MySqlCommand cmd2 = new MySqlCommand(query2, con))
        {
            cmd2.CommandType = CommandType.Text;
            cmd2.Parameters.AddWithValue("@TicketID", ticketID);
            cmd2.ExecuteNonQuery();
            cmd2.Parameters.Clear();
            con.Close();
        }

        SaveBreakDownDetailsVisited(ticketID, 2);
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { Success = true });
    }

    public static int CountVisitedDetails(int ticketId, int Id)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int count = 0;

        string query = "SELECT COUNT(*) FROM ass_BreakDownDetails WHERE TicketID=@TicketID AND AssetTicketID=@AssetTicketID AND STATUS='Visited'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketId);
            cmd.Parameters.AddWithValue("@AssetTicketID", Id);
            count = Convert.ToInt32(cmd.ExecuteScalar());
            cmd.Parameters.Clear();
            con.Close();
        }

        return count;
    }
    public static void SaveBreakDownDetailsVisited(int ticketID, int statusid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int Id = 0;

        string query = "SELECT Id FROM ass_breakdown WHERE TicketID=@TicketID";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketID);
            Id = Convert.ToInt32(cmd.ExecuteScalar());

            int count = 0;
            if (statusid == 2)
            {
                count = CountVisitedDetails(ticketID, Id);
            }
            else if (statusid == 3)
            {
                count = CountResolvedDetails(ticketID, Id);
            }

            if (count == 0)
            {
                DataSet ds = new DataSet();
                MySqlDataAdapter Adp = new MySqlDataAdapter();

                string query1 = "SELECT * FROM ass_BreakDownDetails WHERE TicketID=@TicketID AND AssetTicketID=@AssetTicketID AND Status='Assigned'";
                using (MySqlCommand cmd1 = new MySqlCommand(query1, con))
                {
                    cmd1.CommandType = CommandType.Text;
                    cmd1.Parameters.AddWithValue("@TicketID", ticketID);
                    cmd1.Parameters.AddWithValue("@AssetTicketID", Id);

                    Adp.SelectCommand = cmd1;
                    Adp.Fill(ds);
                }

                int rowcount;
                rowcount = ds.Tables[0].Rows.Count;
                if (rowcount > 0)
                {
                    string query2 = "";
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        int id = GetMaxIdBreakDownDetails();         //Convert.ToInt32(dr["Id"]);
                        id++;
                        string comment = dr["Comments"].ToString();
                        string additionalcoment = dr["AdditionalComment"].ToString();
                        string assignedto = dr["AssignedTo"].ToString();
                        string status="";
                        if (statusid == 2)
                        {
                            status = "Visited";
                        }
                        else if (statusid == 3)
                        {
                            status = "Resolved";
                        }

                        using (MySqlTransaction tr = con.BeginTransaction())
                        {
                            try
                            {
                                query2 = "INSERT INTO ass_BreakDownDetails(Id,AssetTicketID,TicketID,Comments,AdditionalComment,EntryBy,EntryDateTime,STATUS,AssignedTo) VALUES('" + id + "','" + Id + "','" + ticketID + "','" + comment + "','" + additionalcoment + "','" + HttpContext.Current.Session["ID"].ToString() + "',CURDATE(),'" + status + "','" + assignedto + "')";
                                using (MySqlCommand cmd2 = new MySqlCommand(query2, con, tr))
                                {
                                    cmd2.CommandType = CommandType.Text;
                                    cmd2.ExecuteNonQuery();
                                    tr.Commit();
                                    cmd2.Parameters.Clear();
                                }
                            }
                            catch
                            {
                                tr.Rollback();
                            }
                        }
                    }
                }
            }
        }
    }

    public static void UpdateAssignName(string AssignId, string assignBy, int ticketid)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "UPDATE ticket_master SET Assigned_Engineer=@Assigned_Engineer, Assigned_Engineer_ID=@Assigned_Engineer_ID WHERE TicketID=@TicketID";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@Assigned_Engineer_ID", AssignId);
            cmd.Parameters.AddWithValue("@Assigned_Engineer", assignBy);
            cmd.Parameters.AddWithValue("@TicketID", ticketid);

            cmd.ExecuteNonQuery();
            cmd.Parameters.Clear();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)] // 
    public static string SaveHODErrorStatus(string errorname, int errorid, int ticketid, string errorstatus, string comments, string AssignId, string AssignBy)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        using (MySqlTransaction tr = con.BeginTransaction())
        {
            try
            {
                string query = "INSERT INTO err_ErrorStatus(ErrorName,ErrorId,TicketId,ErrorStatus,Comments) VALUES(@ErrorName,@ErrorId,@TicketId,@ErrorStatus,@Comments)";
                using (MySqlCommand cmd = new MySqlCommand(query, con, tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@ErrorName", errorname);
                    cmd.Parameters.AddWithValue("@ErrorId", errorid);
                    cmd.Parameters.AddWithValue("@TicketId", ticketid);
                    cmd.Parameters.AddWithValue("@ErrorStatus", errorstatus);
                    cmd.Parameters.AddWithValue("@Comments", comments);

                    cmd.ExecuteNonQuery();
                    tr.Commit();
                    cmd.Parameters.Clear();
                    con.Close();

                    UpdateAssignName(AssignId, AssignBy, ticketid);
                }
            }
            catch { tr.Rollback(); }
        }

        //ChangeStatus(ticketid, 3);
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { Success = true });
    }

    [WebMethod(EnableSession = true)] // 
    public static string SaveErrorStatus(string errorname, int errorid,int ticketid,string errorstatus,string comments)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        using (MySqlTransaction tr = con.BeginTransaction()) 
        {
            try
            {
                string query = "INSERT INTO err_ErrorStatus(ErrorName,ErrorId,TicketId,ErrorStatus,Comments) VALUES(@ErrorName,@ErrorId,@TicketId,@ErrorStatus,@Comments)";
                using (MySqlCommand cmd = new MySqlCommand(query, con, tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@ErrorName", errorname);
                    cmd.Parameters.AddWithValue("@ErrorId", errorid);
                    cmd.Parameters.AddWithValue("@TicketId", ticketid);
                    cmd.Parameters.AddWithValue("@ErrorStatus", errorstatus);
                    cmd.Parameters.AddWithValue("@Comments", comments);

                    cmd.ExecuteNonQuery();
                    tr.Commit();
                    cmd.Parameters.Clear();
                    con.Close();

                    UpdateResolved(ticketid);
                }
            }
            catch { tr.Rollback(); }
        }

        //ChangeStatus(ticketid, 3);
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { Success = true });
    }

    public static void UpdateResolved(int ticketID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "UPDATE ticket_master SET IsResolved=1 WHERE TicketID=@TicketID";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketID);
            cmd.ExecuteNonQuery();
            cmd.Parameters.Clear();
        }

        string query2 = "UPDATE ass_breakdown SET lastStatus='Resolved' WHERE TicketID=@TicketID";
        using (MySqlCommand cmd2 = new MySqlCommand(query2, con))
        {
            cmd2.CommandType = CommandType.Text;
            cmd2.Parameters.AddWithValue("@TicketID", ticketID);
            cmd2.ExecuteNonQuery();
            cmd2.Parameters.Clear();
            con.Close();
        }

        SaveBreakDownDetailsVisited(ticketID, 3);
    }

    public static int CountResolvedDetails(int ticketId, int Id)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int count = 0;

        string query = "SELECT COUNT(*) FROM ass_BreakDownDetails WHERE TicketID=@TicketID AND AssetTicketID=@AssetTicketID AND STATUS='Resolved'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketId);
            cmd.Parameters.AddWithValue("@AssetTicketID", Id);
            count = Convert.ToInt32(cmd.ExecuteScalar());
            cmd.Parameters.Clear();
            con.Close();
        }

        return count;
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string GetEmployeeNameByEmpID(string empID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string name = "";

        string query = "SELECT CONCAT(Title,NAME)AS NAME FROM Employee_master WHERE EmployeeID=@EmployeeID";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@EmployeeID", empID);
            name = cmd.ExecuteScalar().ToString();
            cmd.Parameters.Clear();
            con.Close();
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(name);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string CheckLastStatusVisited(int ticketId)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string count = "";

        string query = "SELECT COUNT(*) FROM ass_breakdown WHERE TicketID=@TicketID AND lastStatus='Visited'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketID", ticketId);

            count = cmd.ExecuteScalar().ToString();
            cmd.Parameters.Clear();
            con.Close();
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(count);
    }
}