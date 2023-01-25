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

public partial class Design_HelpDesk_AssignTicket : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindStatus();
            BindDepartment();
            errortype();
            BindEmployee();
            ToDatecal.EndDate = DateTime.Now;
            Calendarextender1.EndDate = DateTime.Now;
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly","true");
        txtToDate.Attributes.Add("readOnly","true");
    }

    public void BindStatus()
    {
       // ddlStatus.Items.Insert(0, new ListItem("Pending", "1"));
      //  ddlStatus.Items.Insert(1, new ListItem("Resolved", "2"));
      //  ddlStatus.Items.Insert(2, new ListItem("Assigned", "3"));
    }

    public void BindDepartment()
    {
        //DataTable dt = StockReports.GetDataTable(" SELECT rm.ID, rm.RoleName FROM f_rolemaster rm INNER JOIN ticket_error_type et ON et.RoleID=rm.ID WHERE rm.Active=1 AND rm.ID!='" + ViewState["RoleID"] + "' GROUP BY rm.ID ORDER BY rm.RoleName ");
        DataTable dt = StockReports.GetDataTable("SELECT DISTINCT ID, RoleName FROM f_rolemaster rm INNER JOIN ticket_master tm ON tm.RoleID=rm.ID WHERE rm.ID!='" + Session["RoleID"] + "'");
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "RoleName";
            ddlDepartment.DataValueField = "ID";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("All", "0"));
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
            //ddlErrorType.Items.Insert(0, new ListItem("Select", "0"));
            ddlErrorType.Items.Insert(0, new ListItem("All", "0"));
        }
        else
        {
            ddlErrorType.DataSource = dt;
            ddlErrorType.DataBind();
            ddlErrorType.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
       // errortype();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataSet ds = new DataSet();

        string name = "";
        int num = 0;
      //  DropDownCheckBoxes ddl = ((DropDownCheckBoxes)grdSubCategory.SelectedRow.FindControl("ddlDepartment"));
        ////for (int i = 0; i < ddlStatus.Items.Count; i++)
        ////{
        ////    if (ddlStatus.Items[i].Selected)
        ////    {
        ////        name += ddlStatus.Items[i].Value + ",";
        ////    }
        ////}
        ////name = name.TrimEnd(',');
        
        ////string[] strarry = name.Split(',');
        ////int len = strarry.Length;
        ////for (int i = 0; i < strarry.Length; i++)
        ////{
        ////    num = Convert.ToInt32(strarry[i]);
        ////}

        //int deptID = Convert.ToInt32(ddlDepartment.SelectedValue);
        //int errorID = Convert.ToInt32(ddlErrorType.SelectedValue);
        //string fDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");
        //string tDate = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");

      //  ds = SearchAsset(fDate, tDate, deptID, errorID);
        ds = SearchAsset();
        
        int rowcount;
        rowcount = ds.Tables[0].Rows.Count;
        if (rowcount > 0)
        {
            dgGrid.DataSource = ds;
            dgGrid.DataBind();
        }
    }

    //public DataSet SearchAsset(string frmdate, string todate, int deptId, int errorid)   // int statusId
    public DataSet SearchAsset()
    {
        DataSet ds = new DataSet();
        DataTable dt = new DataTable();

       
        StringBuilder sb = new StringBuilder();
     

        sb.Append(" SELECT tm.TicketID, tm.Description,rm.RoleName,im.ItemName TypeName,tm.Date,em.Name,tet.EmployeeID,tm.Attachment_Name,tm.AssetName,tet.Error_id,tm.StockID,IF(IsAssign=0,'Enabl','Disabl') IsAssign,isAssign AS IsticketAssign FROM ticket_master tm INNER JOIN f_rolemaster rm ");
        sb.Append(" ON rm.ID=tm.RoleID  INNER JOIN eq_asset_master im ON im.ID=tm.StockID  INNER JOIN ticket_error_type tet ON tet.Error_id=tm.ErrorTypeID Left JOIN employee_master em ON em.EmployeeID=tet.EmployeeID WHERE ");
        sb.Append(" DATE(tm.Date)>='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' AND DATE(tm.Date)<='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ");//AND tm.RoleID='" + Session["RoleID"] + "'
        if(ddlDepartment.SelectedItem.Text!="All")
        {
            sb.Append(" AND tm.ErrorDeptID='" + ddlDepartment.SelectedValue + "' ");
        }
        if(ddlErrorType.SelectedItem.Text!="All")
        {
            sb.Append(" AND tet.Error_id='" + ddlErrorType.SelectedValue + "' ");
        }

        sb.Append(" ORDER BY tm.`Date` DESC ");

        dt = StockReports.GetDataTable(sb.ToString());
        ds.Tables.Add(dt.Copy());
        return ds;
    }
    protected void dgGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() != "btnView")
        {
            //    if (e.CommandArgument.ToString() != "0")
            //    {

            //string argument = e.CommandArgument.ToString();
            int ticketId = Convert.ToInt32(e.CommandName.ToString());
            int stock = Convert.ToInt32(e.CommandArgument.ToString());
            SaveLog(ticketId);
            //lblAssetName.Text = GetAssetName(argument);
            //lblSerial.Text = argument;

            //Label lbl = ((Label)dgGrid.FindControl("lblticketID")) as Label;
            // int ticketID = Convert.ToInt32(dgGrid.DataKeyNames);

            Button lbl = (Button)e.CommandSource;
            GridViewRow row = (GridViewRow)lbl.NamingContainer;
            string id = (string)dgGrid.DataKeys[row.RowIndex].Value;
            //BindEmployee();
            mpEdit.Show();
            //  ScriptManager.RegisterStartupScript(this, this.GetType(), "script", "BindEmployeeforAssign('" + id + "');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "script", "ShowDetails('" + stock + "','" + id + "','" + ticketId + "');", true);

            //    }
        }
        else 
        {
            int TickID = Convert.ToInt32(e.CommandArgument.ToString());
            //mpLog.Show();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "script", "ShowLog('" + TickID + "')", true);
        }
    }

    public void SaveLog(int ticketId)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int maxid=GetMaxViewID();
        maxid++;
        string type = getErrorType(ticketId);

        string query = "INSERT INTO err_ViewLog(ViewId,ViewdBy,ViewedDatetime,TicketId,ErrorType) VALUES('" + maxid + "','" + Session["ID"].ToString() + "',CURDATE(),'" + ticketId + "','" + type + "')";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }

    public string getErrorType(int ticketId)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string type = "";

        string query = "SELECT ErrorType FROM ticket_master WHERE TicketId=@TicketId";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketId", ticketId);
            type = cmd.ExecuteScalar().ToString();
        }
        return type;
    }

    public int GetMaxViewID()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int max = 0;

        string query = "SELECT IFNULL(MAX(ViewId),0) FROM err_ViewLog";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            max = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
        }
        return max;
    }

    public void BindEmployee()
    {
        DataTable dt = StockReports.GetDataTable("Select Name,EmployeeID from employee_master where ISActive=1 and isAssetServiceProvider=1 order by Name");//All_LoadData.LoadEmployee();
        if (dt.Rows.Count > 0)
        {
            ddlemployee.DataSource = dt;
            ddlemployee.DataTextField = "Name";
            ddlemployee.DataValueField = "EmployeeID";
            ddlemployee.DataBind();
            ddlemployee.Items.Insert(0, new ListItem("Select"));
        }
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string[] BindEmp(string empID)
    {
        string[] ID = empID.Split(',');
        int len = ID.Length;
        string enmpName, empid, concat = "";
        DataTable dt = new DataTable();
        MySqlDataAdapter Adp = new MySqlDataAdapter();
        MySqlDataReader dr;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        if (len > 1)
        {
            for (int i = 0; i < ID.Length; i++)
            {
                string query = "SELECT EmployeeID,Name FROM employee_master WHERE EmployeeID='" + ID[i] + "'";
                using (MySqlCommand cmd = new MySqlCommand(query, con))
                {
                    cmd.CommandType = CommandType.Text;
                    dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        enmpName = dr["Name"].ToString();
                        empid = dr["EmployeeID"].ToString();

                        concat += enmpName + "#" + empid + ",";
                    }
                    dr.Close();
                }
            }
        }
        else
        {
            string query = "SELECT EmployeeID,Name FROM employee_master WHERE EmployeeID='" + empID + "'";
            using (MySqlCommand cmd = new MySqlCommand(query, con))
            {
                cmd.CommandType = CommandType.Text;
                dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    enmpName = dr["Name"].ToString();
                    empid = dr["EmployeeID"].ToString();

                    concat = enmpName + "#" + empid;
                }
            }
        }

        concat = concat.TrimEnd(',');
        string[] a = concat.Split(',');
        return a;
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string[] ShowViewLog(int ticketID)
    {
        DataSet ds = new DataSet();
        MySqlDataReader dr;

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "SELECT * FROM err_ViewLog WHERE TicketId='" + ticketID + "'";

        string date = "", errortyp = "", all = "";
        using (MySqlCommand cmd = new MySqlCommand(query,con))
        {
            cmd.CommandType = CommandType.Text;
            dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                errortyp = dr["ErrorType"].ToString();
                date = dr["ViewedDatetime"].ToString();
            }

            all = errortyp + "," + date;
        }

        string[] a = all.Split(',');

        con.Close();
        dr.Close();

        return a;
    }

    [WebMethod(EnableSession = true)] // 
    public static string BindPopupByStatusID(int stockID)
    {
       // BindClass obj = new BindClass();
        DataSet ds = new DataSet();
        MySqlDataReader dr;
        MySqlDataAdapter Adp = new MySqlDataAdapter();

       

        //string query = "SELECT st.ItemName,st.StockID,ast.SerialNo," +
        //"IF(EM.WarrantyTo<=CURDATE(),CONCAT('Expired(Before ',DATEDIFF(CURDATE(),EM.WarrantyTo),' Days)'),CONCAT('Available(Next ',DATEDIFF(EM.WarrantyTo,CURDATE()),' Days)'))WarrantyStatus," +
        //"DATE_FORMAT(EM.WarrantyTo,'%d-%b-%Y')WarrantyDate,ast.WarrantyNo," +
        //"(SELECT LM.LedgerName FROM f_stock s INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=s.VenLedgerNo WHERE s.StockID=ST.StockID)WarrantyVendor," +
        //"'N/A' AMCStatus ,'N/A' AMCDate,'N/A' AMCNo,'N/A' AMCVendor,'N/A' CMCStatus ,'N/A' CMCDate,'N/A' CMCNo,'N/A' CMCVendor FROM f_stock st  " +
        //"INNER JOIN ass_assetstock ast ON ast.GRNStockID=st.StockID INNER JOIN eq_asset_master em ON em.assetid=ast.assetid WHERE st.IsAsset=1 AND st.StockID='" + stockID + "'";

        string query = @"SELECT ast.`ItemName`,ast.`ID` AS AssetID,asm.`SerialNo`,asm.`AssetNo`,asm.`ModelNo`,
DATE_FORMAT(ew.`WarrantyToDate`,'%d-%b-%Y')WarrantyToDate,(SELECT LM.LedgerName FROM  f_ledgermaster lm WHERE lm.LedgerNumber= ew.`SupplierID`)WarrantyVendor,
DATE_FORMAT(eam.`WarrantyToDate`,'%d-%b-%Y')as AMCToDate,(SELECT LM.LedgerName FROM  f_ledgermaster lm WHERE lm.LedgerNumber=eam.`SupplierID`)AMCVendor,IF(ew.`WarrantyToDate`<=CURDATE(),'0','1')WarrantyStatus,IF(eam.`WarrantyToDate`<=CURDATE(),'0','1')AMCStatus
FROM eq_asset_stock ast 
INNER JOIN eq_asset_master asm ON ast.`AssetID`= asm.`ID`
LEFT JOIN eq_assetwarrantydetail ew ON ew.`AssetID`= ast.`AssetID` AND ew.`IsActive`=1
LEFT JOIN eq_amc_detail eam ON eam.`AssetID`= ast.`AssetID` AND eam.isActive=1
WHERE asm.ID=" + stockID+" LIMIT 1";

        //string itemname, warentystatus,Wvendor,amcstatus,Avendor,Cstatus,Cvendor,Adt,CMCDt,serial,Wnum, all = "";
        //int stockid, Anum = 0, Cnum = 0;
        //DateTime dt = DateTime.Now;
        ////DateTime Adt = DateTime.Now;
        //DateTime Cdt = DateTime.Now;

        //using (MySqlCommand cmd = new MySqlCommand(query, con))
        //{
        //    cmd.CommandType = CommandType.Text;

        //    dr = cmd.ExecuteReader();

        //    if (dr.Read())
        //    {
        //        itemname = dr["ItemName"].ToString();
        //        stockid = Convert.ToInt32(dr["StockID"]);
        //        serial = dr["SerialNo"].ToString();
        //        warentystatus = dr["WarrantyStatus"].ToString();
        //        dt = Convert.ToDateTime(dr["WarrantyDate"]);
        //        Wvendor = dr["WarrantyVendor"].ToString();
        //        amcstatus = dr["AMCStatus"].ToString();
        //        Avendor = dr["AMCVendor"].ToString();
        //        Cstatus = dr["CMCStatus"].ToString();
        //        Cvendor = dr["CMCVendor"].ToString();
        //        Adt = dr["AMCDate"].ToString();
        //        Wnum = dr["WarrantyNo"].ToString();
        //        CMCDt = dr["CMCDate"].ToString();
        //       // Anum = Convert.ToInt32(dr["AMCNo"]);
        //      //  Cnum = Convert.ToInt32(dr["CMCNo"]);

        //        all = itemname + "," + stockid + "," + serial + "," + warentystatus + "," + dt + "," + Wvendor + "," + amcstatus + "," + Avendor + "," + Cstatus + "," + Cvendor + "," + Adt + "," + Wnum + "," + Anum + "," + Cnum + "," + CMCDt;
        //    }
        //}

        //string[] a = all.Split(',');
        
        //con.Close();
        //dr.Close();

        //return a;

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(query));
    }

    [WebMethod(EnableSession = true)] // 
    public static string GetAssetName(string itemId)
    {
        //MySqlConnection con = new MySqlConnection();
        //con = Util.GetMySqlCon();
        //con.Open();
        string typename = "";

        string query = "SELECT TypeName FROM f_itemmaster WHERE ItemID=@ItemID";
        //using (MySqlCommand cmd = new MySqlCommand(query, con))
        //{
        //    cmd.CommandType = CommandType.Text;
        //    cmd.Parameters.Add("@ItemID", itemId);
        //    typename = cmd.ExecuteScalar().ToString();
        //    con.Close();
        //}
        return Newtonsoft.Json.JsonConvert.SerializeObject(typename);
    }

    protected void dgGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string id = ((Label)e.Row.FindControl("lblEmployeeID")).Text;
            string isAssign = ((Label)e.Row.FindControl("lblIsAssign")).Text;
            if (isAssign == "0")
            {
                ((Label)e.Row.FindControl("lblStatus")).Text = "Pending";
              //  ((Button)e.Row.FindControl("ibmEdit")).Visible = true;
               // ((Button)e.Row.FindControl("ibmTransfer")).Visible = false;
            }
            else
            {
                ((Label)e.Row.FindControl("lblStatus")).Text = "Assigned";
            //    ((Button)e.Row.FindControl("ibmTransfer")).Visible = true;
                //((Button)e.Row.FindControl("ibmEdit")).Visible = false;
            }
        }
    }

    public class BindDropDownlst
    {
        public string DataValueField { get; set; }
        public string DataTextField { get; set; }
    }

    [WebMethod(EnableSession = true)] // 
    public static string AssignEmployee(string Engineer, int TicketID, string enginerID)
    {
        string res = "";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string query = "UPDATE ticket_master SET Assigned_Engineer='" + Engineer + "', AssignedDateTime=NOW(), AssignedBy='" + HttpContext.Current.Session["ID"].ToString() + "',Assigned_Engineer_ID='" + enginerID + "', IsAssign=1 WHERE TicketID='" + TicketID + "'";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.ExecuteNonQuery();
            con.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(res);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string SaveBreakDown(int ticketID,string department)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string status = "Assigned", res = "";
        int max = 0;
        max = GetMaxForBreakDown();
        max = max + 2;

        string query = "INSERT INTO ass_breakdown(Id,TicketID,EntryBy,EntryDateTime,FromDepartment,lastStatus) VALUES('" + max + "','" + ticketID + "','" + HttpContext.Current.Session["ID"].ToString() + "',CURDATE(),'" + department + "','" + status + "')";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.ExecuteNonQuery();
            con.Close();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(res);
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string SaveBreakDownDetails(string employee, int ticket)
    { 
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int max = GetMaxDetails();
        max++;
        int maxbreakdown = GetMaxForBreakDown();
        string additionalinfo = GetAdditionalComment(ticket);
        string comments = GetDescriptionByTicketID(ticket);
        string status="Assigned";
        string res = "";

        string query = "INSERT INTO ass_BreakDownDetails(Id,AssetTicketID,TicketID,Comments,AdditionalComment,EntryBy,EntryDateTime,STATUS,AssignedTo) VALUES('" + max + "','" + maxbreakdown + "','" + ticket + "','" + comments + "','" + additionalinfo + "','" + HttpContext.Current.Session["ID"].ToString() + "',CURDATE(),'" + status + "','" + employee + "')";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.ExecuteNonQuery();
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(new { Success = true });
    }

    public static string GetDescriptionByTicketID(int ticket)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string desc = "";

        string query = "SELECT Description FROM ticket_master WHERE TicketId=@TicketId";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketId", ticket);
            desc = cmd.ExecuteScalar().ToString();
            con.Close();
        }

        return desc;
    }

    public static string GetAdditionalComment(int TicketID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        DataSet ds = new DataSet();
        MySqlDataAdapter Adp = new MySqlDataAdapter();

        string query = "SELECT Content FROM ass_aditionalinfo_ticketmaster WHERE TicketId=@TicketId";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.AddWithValue("@TicketId", TicketID);
            Adp.SelectCommand = cmd;
            Adp.Fill(ds, "table1");
        }

        string content = "";
        int rowcount;
        rowcount = ds.Tables[0].Rows.Count;
        if (rowcount > 0)
        {
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                content += dr["Content"].ToString() + ",";
            }
        }

        content = content.TrimEnd(',');

        return content;
    }

    public static int GetMaxForBreakDown()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int max = 0;

        string query = "SELECT IFNULL(MAX(Id),0)AS MaxID FROM ass_breakdown";

        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            max = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
        }

        return max;
    }

    public static int GetMaxDetails()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int max = 0;

        string query = "SELECT IFNULL(MAX(Id),0)AS MaxID FROM ass_BreakDownDetails";

        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            max = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
        }

        return max;
    }


    //protected void btnEdit_Click(object sender, EventArgs e)
    //{
    //    MySqlConnection con = new MySqlConnection();
    //    con = Util.GetMySqlCon();
    //    con.Open();

    //    string engineername = ddlemployee.SelectedItem.Text;
    //    int ticketid = Convert.ToInt32(hfTicketId.Text);

    //    string query = "UPDATE ticket_master SET Assigned_Engineer='" + engineername + "', AssignedDateTime=CURDATE(), AssignedBy='" + Session["ID"].ToString() + "' WHERE TicketID='" + ticketid + "'";
    //    using (MySqlCommand cmd = new MySqlCommand(query,con))
    //    {
    //        cmd.CommandType = CommandType.Text;
    //        cmd.ExecuteNonQuery();
    //        con.Close();
    //    }
    //}
}