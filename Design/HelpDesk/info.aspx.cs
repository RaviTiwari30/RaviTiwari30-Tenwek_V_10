using System;
using System.Data;
using System.Text;
using System.IO;
using System.Web.UI;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using MySql.Data.MySqlClient;
public partial class Design_HelpDesk_info : System.Web.UI.Page
{
    protected void lbtnhome_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='Search.aspx';", true);
    }
    private void bindRepeater()
    { 
     StringBuilder sb=new StringBuilder();
        sb.Append("Select * from Section_Master where IsActive='1'");
        
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            rpFloor.DataSource = dt;
            rpFloor.DataBind();
            
        }
        else
        {
            rpFloor.DataSource = null;
            rpFloor.DataBind();
            
        }
        bindTicketDetail(Session["TicketID"].ToString());
        
    }
    public void bindTicketDetail(string TicketNo)
    {
        string query = "SELECT  DISTINCT IFNULL(stm.TicketNo,'')TicketNo,'Child' as SubTicket, stm.Section as Section,(SELECT sm.Section_Name FROM `section_master` sm WHERE sm.ID=stm.Section)Section_Name ,CONCAT(em.Title,' ',em.Name)CreatedBy,stm.TicketID,stm.Status,tmd.Priority,IF(tmd.IsReopen=1,'Yes','No')IsReopen, " +
 "DATE_FORMAT(stm.Date,'%d-%b-%Y %h:%i %p')CreatedDate," +
 "(SELECT CONCAT(emp.Title,' ',emp.Name) FROM `employee_Master` emp WHERE emp.EmployeeID=stm.Assigned_Engineer_ID)Assigned_Engineer," +
 "(SELECT rm.`RoleName` FROM f_rolemaster rm  " +
 "WHERE  rm.`ID`=tmd.ForwordToDepartment)ForwordToDepartment FROM  sub_ticket_master stm " +
  "INNER JOIN  ticket_master_description tmd  ON stm.TicketID=tmd.TicketId   " +
                         " INNER JOIN employee_Master em ON em.EmployeeID=tmd.CreatedBy  WHERE stm.TicketID='" + TicketNo + "' ";
        string isreopen = StockReports.ExecuteScalar(" SELECT IsReopen FROM  ticket_master_description WHERE TicketID='" + TicketNo + "' order by ID Desc limit 1 ");
        if (isreopen == "1")
        { 
          query+= " and  tmd.IsReopen='1'";
        }
        DataTable dt = StockReports.GetDataTable(query);
        Session["SubTicket"] = null;
        if (dt.Rows.Count > 0)
            Session["SubTicket"] = dt;
        else
           Session["SubTicket"]= null;
    }

    protected void rpFloor_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
     string subcount = StockReports.ExecuteScalar("SELECT count(*) FROM sub_ticket_master WHERE Section='" + ((Label)e.Item.FindControl("lblSection_ID")).Text + "' and TicketID='"+Session["TicketID"].ToString()+"' ");
        
            Repeater rpBD = (Repeater)e.Item.FindControl("rpBD");
            
            rpBD.DataSource = GetFloorRoomType1(((Label)e.Item.FindControl("lblSection_ID")).Text);
            rpBD.DataBind();
            if (subcount == "0")
            {
                (((Label)e.Item.FindControl("lblFloor"))).Visible = false;
                (((System.Web.UI.HtmlControls.HtmlTableRow)e.Item.FindControl("trRow"))).Visible = false;
                (((System.Web.UI.HtmlControls.HtmlTableRow)e.Item.FindControl("trSectionRow"))).Visible = false;
            }
            else
            {
                DropDownList ddlAssto = (((DropDownList)e.Item.FindControl("ddlAssignToSub")));
                ddlAssto.DataSource = bindAssignedTo();

                ddlAssto.DataTextField = "EmpName";
                ddlAssto.DataValueField = "Id";
                ddlAssto.DataBind();
                ddlAssto.Items.Insert(0, "Select");
            }
        
        }

    }
    
    private DataTable bindAssignedTo()
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Distinct em.`EmployeeID` Id,CONCAT(em.`Title`,'',em.`NAME`)EmpName ");
        sb.Append(" FROM employee_master em ");
        sb.Append(" INNER JOIN f_login fl ON fl.`EmployeeID`=em.`EmployeeID` AND fl.`RoleID`='" + Session["RoleID"].ToString() + "' ");
        sb.Append(" WHERE fl.`Active`=1 AND em.`IsActive`=1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return (dt);
    }
    protected void rpBD_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            }

    }
  
    private DataTable GetFloorRoomType1(string section)
    {
        //int a = 0;
        DataTable dtsub = null;
        DataTable dtsub1 = null;
        if (Session["SubTicket"] != null)
        {
            dtsub = (DataTable)Session["SubTicket"];
            DataRow[] rows = dtsub.Select("Section='" + section + "'");

            dtsub1 = null;
            if (rows.Length > 0)
            {
                dtsub1 = dtsub.Clone();
                foreach (DataRow dr in rows)
                    dtsub1.ImportRow(dr);
            }
            return dtsub1;

        }
        return null;
    }
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //Session["TicketID"] = null;
            
            Session["TicketID"] = Request.QueryString["TicketId"].ToString();
            string subcount = StockReports.ExecuteScalar("SELECT count(*) FROM sub_ticket_master WHERE TicketID='" + Session["TicketID"].ToString() + "' ");
            if (subcount == "0")
            {

                Session["SubTicket"] = null;
            }
        
            if (Resources.Resource.Ticketing == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
                return;
            }
            else
            {
                ddlStatus.Attributes.Add("OnChange", "CloseStatus();");
                txtCloseDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                txtCloseTime.Text = DateTime.Now.ToString("HH:mm tt");
                All_LoadData.bindPriority(ddlPriority);
                response_bind();
               }
            bind_Section();
            bindRepeater();
            bindTicketDetail(Session["TicketID"].ToString());
        }
       
    }
    private void bind_Section()
    {
       
        DataTable dt = new DataTable();

        string asd = "select ID,Section_Name from  Section_Master WHERE IsActive=1";
        dt = StockReports.GetDataTable(asd);
        ddlSection.DataSource = null;
        ddlSection.DataSource = dt;
        ddlSection.DataTextField = "Section_Name";
        ddlSection.DataValueField = "ID";
        ddlSection.DataBind();
        ddlSection.Items.Insert(0, "Select");
        string sectionid = StockReports.ExecuteScalar("SELECT Section FROM ticket_master_description WHERE TicketId='" + Session["TicketID"].ToString() + "'  order by ID DESC LIMIT 1");
        if (sectionid != "")
        {
            ddlSection.SelectedValue = sectionid;
            ddlSection.Enabled = false;
        }
    
    }
    private void response_bind()
    {
        DataTable dt = new DataTable();

        string asd = "select ID,TITLE from  ticket_premade_reply_master WHERE STATUS=1";
        dt = StockReports.GetDataTable(asd);
        ddlReplyRspnce.DataSource = dt;
        ddlReplyRspnce.DataTextField = "TITLE";
        ddlReplyRspnce.DataValueField = "ID";
        ddlReplyRspnce.DataBind();
        ddlReplyRspnce.Items.Insert(0, "Select");
    }
    protected void lnkbtnAttachment_Click(object sender, EventArgs e)
    {

        
        string url = string.Concat(Resources.Resource.DocumentDriveIPAddress, Resources.Resource.DocumentDriveName, "\\", Resources.Resource.DocumentFolderName, "\\HelpDesk\\SupportAttachment\\", txtAttachment.Text.Split('#')[0]);
        ViewFile(url,txtAttachment.Text.Split('#')[1]);

    }

    private void ViewFile(string url,string fileName)
    {
        string FilePath = url;
        if (FilePath != "")
        {
            FileInfo File = new FileInfo(FilePath);

            string FileName = fileName == "" ? File.Name : fileName; 
            if (File.Extension == ".pdf")
            {
                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                // Add the file size into the response header
                Response.AddHeader("Content-Length", File.Length.ToString());

                // Set the ContentType
                Response.ContentType = "application/pdf";

                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                Response.TransmitFile(File.FullName);

                // End the response
                Response.Flush();
            }
            else if (File.Extension == ".xlsx")
            {
                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                // Add the file size into the response header
                Response.AddHeader("Content-Length", File.Length.ToString());

                // Set the ContentType
                Response.ContentType = "application/vnd.xlsx";

                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                Response.TransmitFile(File.FullName);

                // End the response
                Response.Flush();
            }
            else if (File.Extension == ".jpg")
            {
                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                // Add the file size into the response header
                Response.AddHeader("Content-Length", File.Length.ToString());

                // Set the ContentType
                Response.ContentType = "image / jpeg";

                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                Response.TransmitFile(File.FullName);

                // End the response
                Response.Flush();
            }
            else if (File.Extension == ".txt")
            {
                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                // Add the file size into the response header
                Response.AddHeader("Content-Length", File.Length.ToString());

                // Set the ContentType
                Response.ContentType = "text/plain";

                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                Response.TransmitFile(File.FullName);

                // End the response
                Response.Flush();
            }
            else if (File.Extension == ".htm")
            {
                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                // Add the file size into the response header
                Response.AddHeader("Content-Length", File.Length.ToString());

                // Set the ContentType
                Response.ContentType = "text/html";

                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                Response.TransmitFile(File.FullName);

                // End the response
                Response.Flush();
            }
            else if (File.Extension == ".html")
            {
                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                // Add the file size into the response header
                Response.AddHeader("Content-Length", File.Length.ToString());

                // Set the ContentType
                Response.ContentType = "text/html";

                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                Response.TransmitFile(File.FullName);

                // End the response
                Response.Flush();
            }
            else if (File.Extension == ".doc")
            {
                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                // Add the file size into the response header
                Response.AddHeader("Content-Length", File.Length.ToString());

                // Set the ContentType
                Response.ContentType = "application/ms-word";

                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                Response.TransmitFile(File.FullName);

                // End the response
                Response.Flush();
            }
            else if (File.Extension == ".docx")
            {
                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                // Add the file size into the response header
                Response.AddHeader("Content-Length", File.Length.ToString());

                // Set the ContentType
                Response.ContentType = "application/ms-word";

                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                Response.TransmitFile(File.FullName);

                // End the response
                Response.Flush();
            }
            else if (File.Extension == ".csv")
            {
                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                // Add the file size into the response header
                Response.AddHeader("Content-Length", File.Length.ToString());

                // Set the ContentType
                Response.ContentType = "application/vnd.ms-excel";

                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                Response.TransmitFile(File.FullName);

                // End the response
                Response.Flush();
            }
            else if (File.Extension == ".gif")
            {
                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                // Add the file size into the response header
                Response.AddHeader("Content-Length", File.Length.ToString());

                // Set the ContentType
                Response.ContentType = "image/gif";

                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                Response.TransmitFile(File.FullName);

                // End the response
                Response.Flush();
            }
            else
            {
               // lblMsg.Text = "File Type Not Identified";
            }
        }
    }
    protected void rpFloor_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName=="update")
        {
             DropDownList ddlAssto = (((DropDownList)e.Item.FindControl("ddlAssignToSub")));
             DropDownList ddlStatus = (((DropDownList)e.Item.FindControl("ddlStatusSub")));
               string Section= ((Label)e.Item.FindControl("lblSection_ID")).Text;

               if (ddlAssto.SelectedValue != "Select")
               {
                   if (ddlStatus.SelectedValue == "3" || ddlStatus.SelectedValue == "4")
                   {
                       MySqlConnection con = Util.GetMySqlCon();
                       con.Open();
                       MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
                       try
                       {
                           string query = " SELECT  tm.TicketID,'Parent' as Ticket,sm.Section_Name,CONCAT(em.Title,' ',em.Name)CreatedBy,tm.TicketID,tmd.Status,tmd.Priority,if(tmd.IsReopen=1,'Yes','No')IsReopen, " +
                                      " DATE_FORMAT(tmd.CreatedDate,'%d-%b-%Y %h:%i %p')CreatedDate,IFNULL(tmd.ReopenReason,'')Reason,tmd.Assign_Engineer,(SELECT rm.`RoleName` FROM f_rolemaster rm  WHERE  rm.`ID`=tmd.ForwordToDepartment)ForwordToDepartment FROM ticket_master tm INNER JOIN  ticket_master_description tmd  ON tm.TicketID=tmd.TicketID " +
                                      " INNER JOIN employee_Master em ON em.EmployeeID=tmd.CreatedBy INNER JOIN Section_Master sm on sm.ID=tmd.Section WHERE tm.TicketID=" + Session["TicketID"].ToString() + "";

                           DataTable dt = StockReports.GetDataTable(query);

                           if (dt.Rows.Count > 0)
                           {
                               string duplicatesubAssign = StockReports.ExecuteScalar(" SELECT count(*) FROM sub_ticket_master WHERE TicketID='" + Session["TicketID"].ToString() + "' and Section='" + Section + "' and Assigned_Engineer_ID='" + ddlAssto.SelectedValue + "'  ");
                               if (duplicatesubAssign == "0")
                               {

                                   if (ddlStatus.SelectedValue == "4")
                                   {
                                       string srno = StockReports.ExecuteScalar(" SELECT TicketNo FROM sub_ticket_master stm  WHERE TicketID='" + Session["TicketID"].ToString() + "' and Section='"+Section+"' ");
                        
                                       StringBuilder sb = new StringBuilder();
                                       sb.Append("  INSERT INTO sub_ticket_master(TicketNo,EmployeeID,Priority,LastUpdate,Status,Active,IsClose,StockID,Date,TicketId,Section,Assigned_Engineer_ID,Assigned_Engineer) " +
                                                      " VALUES ('" + srno + "','" + Session["ID"].ToString() + "','Normal','" +
                                                      DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','Assigned','1','0','0','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + Session["TicketID"].ToString() + "','" +
                                                      Section + "','" + ddlAssto.SelectedValue + "','') ");
                                       MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                                   }
                                   else if (ddlStatus.SelectedValue == "3")
                                   {
                                       StringBuilder sb = new StringBuilder();
                                       sb.Append(" UPDATE sub_ticket_master SET Status='Resolved' ");
                                       sb.Append(" WHERE TicketID='" + Session["TicketID"].ToString() + "' and Section='" + Section + "'");
                                       MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                                       // MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ass_breakdown SET lastStatus='Resolved' WHERE TicketID=" + TicketId);

                                   }

                                   tranX.Commit();


                                   ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", "if (localStorage.getItem('x') == '0') {localStorage.setItem('x', '1');" +
                          " window.location.reload(); }", true);
                               }
                               else
                               {
                                   //ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", " localStorage.setItem('isdup', '0');", true);


                               }
                           }
                       }


                       catch (Exception ex)
                       {
                           tranX.Rollback();
                           ClassLog cl = new ClassLog();
                           cl.errLog(ex);

                       }
                       finally
                       {
                           // bindTicketDetail(Session["TicketID"].ToString());

                           bindRepeater();
                           tranX.Dispose();
                           con.Close();
                           con.Dispose();

                           bindRepeater();
                       }
                   }
                   else
                   {
                       ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", " alert('Select Status');", true);

                   }
               }
               else
               {
                   if (ddlStatus.SelectedValue == "3")
                   {

                       if (ddlStatus.SelectedValue == "3" || ddlStatus.SelectedValue == "4")
                       {
                           MySqlConnection con = Util.GetMySqlCon();
                           con.Open();
                           MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
                           try
                           {
                               string query = " SELECT  tm.TicketID,'Parent' as Ticket,sm.Section_Name,CONCAT(em.Title,' ',em.Name)CreatedBy,tm.TicketID,tmd.Status,tmd.Priority,if(tmd.IsReopen=1,'Yes','No')IsReopen, " +
                                          " DATE_FORMAT(tmd.CreatedDate,'%d-%b-%Y %h:%i %p')CreatedDate,IFNULL(tmd.ReopenReason,'')Reason,tmd.Assign_Engineer,(SELECT rm.`RoleName` FROM f_rolemaster rm  WHERE  rm.`ID`=tmd.ForwordToDepartment)ForwordToDepartment FROM ticket_master tm INNER JOIN  ticket_master_description tmd  ON tm.TicketID=tmd.TicketID " +
                                          " INNER JOIN employee_Master em ON em.EmployeeID=tmd.CreatedBy INNER JOIN Section_Master sm on sm.ID=tmd.Section WHERE tm.TicketID=" + Session["TicketID"].ToString() + "";

                               DataTable dt = StockReports.GetDataTable(query);

                               if (dt.Rows.Count > 0)
                               {
                                   if (ddlStatus.SelectedValue == "3")
                                   {
                                       StringBuilder sb = new StringBuilder();
                                       sb.Append(" UPDATE sub_ticket_master SET Status='Resolved' ");
                                       sb.Append(" WHERE TicketID='" + Session["TicketID"].ToString() + "' and Section='" + Section + "'");
                                       MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                                       // MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ass_breakdown SET lastStatus='Resolved' WHERE TicketID=" + TicketId);
                                       tranX.Commit();
                                       ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", "if (localStorage.getItem('x') == '0') {localStorage.setItem('x', '1');" +
                        " window.location.reload(); }", true);

                                   }
                               }

                           }



                           catch (Exception ex)
                           {
                               tranX.Rollback();
                               ClassLog cl = new ClassLog();
                               cl.errLog(ex);

                           }
                           finally
                           {
                               // bindTicketDetail(Session["TicketID"].ToString());

                               bindRepeater();
                               tranX.Dispose();
                               con.Close();
                               con.Dispose();

                               bindRepeater();
                           }
                       }
                       else
                       {
                           ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", " alert('Select Status');", true);

                       }

                   }
                   else
                   {
                       ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "alert", " alert('Select Assign To');", true);
                   }
               }
            

        }
    }
}

