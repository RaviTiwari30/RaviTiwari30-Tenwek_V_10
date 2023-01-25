using System;
using System.Data;
using System.Text;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.IO;


public partial class Design_Circular_ViewCircular : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindMessage("0");
        }
    }

    private void bindMessage(string Status)
    {
        StringBuilder sb = new StringBuilder();
        if (Status == "0" || Status == "1")
        {
            sb.Append(" SELECT * FROM ( ");
        }
        sb.Append(" SELECT ci.ID,ci.Sub,rm1.RoleName AS FromDept,rm2.RoleName AS ToDept,em1.Name AS FromEmp, ");
        sb.Append(" em2.Name AS ToEmp,DATE_FORMAT(ci.Circular_date,'%d-%b-%Y %h:%i %p') AS DATE,ci.IsView,cm.`URL`,");
        sb.Append("(SELECT count(*) FROM reply_circular WHERE message_id=cm.`id` AND IsRead=0 AND To_Id='" + Util.GetString(Session["id"]) + "')Reply  FROM circular_inbox ci  ");
        sb.Append(" INNER JOIN circular_master cm ON cm.`id`=ci.`message`");
        sb.Append(" INNER JOIN f_rolemaster rm1 ON rm1.ID=ci.from_dept  ");
        sb.Append(" LEFT JOIN  f_rolemaster rm2 ON rm2.ID=ci.to_dept  ");
        sb.Append(" INNER JOIN employee_master em1 ON em1.EmployeeID=ci.from_id  ");
        sb.Append(" INNER JOIN employee_master em2 ON em2.EmployeeID=ci.to_id AND (ci.to_id='" + Util.GetString(Session["id"]) + "' OR ci.from_id='" + Util.GetString(Session["id"]) + "') ");
        //if (Status != "")
        //    sb.Append(" AND ci.IsView=" + Status + " ");
     
        sb.Append(" WHERE cm.CentreID=" + Util.GetString(Session["CentreID"]) + " group by ci.message Order by ci.Circular_date Desc");
        if (Status == "0")
        {
            sb.Append(" )t WHERE reply<>0 or IsView=0");
        }
        else if (Status == "1")
            sb.Append(" )t WHERE reply<>0 or IsView=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            circilarMessage.Visible = false;
            grdCircular.DataSource = dt;
            grdCircular.DataBind();
        }
        else
        {
            grdCircular.DataSource = null;
            grdCircular.DataBind();
            circilarMessage.Text = "No Message";
            circilarMessage.Visible = true;
        }
    }

    protected void lbtnUnread_Click(object sender, EventArgs e)
    {
        bindMessage("0");
    }

    protected void lbtnReaded_Click(object sender, EventArgs e)
    {
        bindMessage("1");
    }

    protected void grdCircular_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex >= 0)
        {
            Repeater rpt = new Repeater();

            if ((((Label)e.Item.FindControl("lblIsView")).Text == "0"))
            {
                ((HtmlTableRow)e.Item.FindControl("trHead")).BgColor = "LightGreen";
            }
            if (((ImageButton)e.Item.FindControl("imgbtnAttachment")).AlternateText == string.Empty)
            {
                ((ImageButton)e.Item.FindControl("imgbtnAttachment")).Visible = false;
            }
            else {
                ((ImageButton)e.Item.FindControl("imgbtnAttachment")).Visible = true;
            }
            if (((HtmlGenericControl)e.Item.FindControl("Reply_Count")).InnerHtml == "0")
            {
                ((HtmlGenericControl)e.Item.FindControl("Reply_Count")).Visible = false; 
            }
        }
    }


    protected void lbtnAll_Click(object sender, EventArgs e)
    {
        bindMessage("");
    }
   
    protected void grdCircular_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Attchment")
        {
            string FilePath = Util.GetString(e.CommandArgument);
            if (FilePath != "")
            {
                FileInfo File = new FileInfo(FilePath);
                string FileName = File.Name;

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
                    lblMsg.Text = "File Type Not Identified";
                }
            }
        }
    }
}
