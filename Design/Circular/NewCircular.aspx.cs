using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;
using System.IO;

public partial class Design_Circular_NewCircular : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void rblTo_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        if (rblTo.SelectedIndex == 0)
        {
            lbToList.DataSource = getUserList();
            lbToList.DataTextField = "Name";
            lbToList.DataValueField = "EmployeeID";
        }
        else
        {
            lbToList.DataSource = getDepartmentList();
            lbToList.DataTextField = "RoleName";
            lbToList.DataValueField = "ID";
        }
        lbToList.DataBind();
    }

    private DataTable getDepartmentList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT rm.ID,UPPER(rm.RoleName) AS RoleName FROM f_rolemaster rm INNER JOIN f_centre_role cr ON cr.RoleID=rm.ID WHERE rm.Active=1 AND cr.isActive=1 AND cr.CentreID="+ Session["CentreID"].ToString() +" ORDER BY rm.RoleName ");
        return StockReports.GetDataTable(sb.ToString());
    }

    private DataTable getUserList()
    {
        return StockReports.GetDataTable("SELECT DISTINCT(em.EmployeeID),em.Name FROM employee_master em  INNER JOIN f_login fl ON fl.EmployeeID=em.EmployeeID WHERE fl.Active=1 And fl.CentreID=1 AND em.IsActive=1 AND em.EmployeeID<>'EMP001'  ORDER BY em.name;");
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        try
        {
            if (rblTo.SelectedIndex == -1)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "modelAlert('Please select Type  first.');", true);
                lblmsg.Text = "Please select Type  first.";
                return;
            }
            if (txtsub.Text == string.Empty)
            {
                lblmsg.Text = "Please Enter Subject.";
                return;
            }
            if (txtmsg.Text==string.Empty)
            {
                lblmsg.Text = "Please Enter Message.";
                return;
            }
           // bool itemSelect = false;
            //foreach (ListItem lin in lbToList.Items)
            //{
                //    if (lin.Selected)
            //    {
            //        itemSelect = true;
            //    }
            //}

            //if (!itemSelect)
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "alert('Please select " + rblTo.SelectedItem.Text + " first.');", true);
            //    return;
            //}
            if (lblUserOrDeptList.Value != string.Empty)
            {
                 string status ="";
                 if (rblTo.SelectedIndex == 0)
                 {
                     status = savebyUser();
                     if (status == "0")
                     {
                         lblmsg.Text = "Error occurred, Please contact administrator ";
                         return;
                     }
                     if (status == "1")
                     {
                         lblmsg.Text = "Wrong File Extension of Selected Document ";
                         return;
                     }
                 }

                 else
                 {
                   status = savebyDepartment();
                     if (status == "0")
                     {
                         lblmsg.Text = "Error occurred, Please contact administrator ";
                         return;
                     }
                     if (status == "1")
                     {
                         lblmsg.Text = "Wrong File Extension of Selected Document ";
                         return;
                     }
                 }
            }
            else {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "modelAlert('Please select " + rblTo.SelectedItem.Text + "  first from list.');", true);
                   return;
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "modelAlert('Circular sent successfully.');window.location='" + Request.RawUrl + "';", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = "Error";
        }
    }

    private string savebyDepartment()
    {
        try
        {
            string DeptId = "";
            string[] DepartmentId = lblUserOrDeptList.Value.Split(',');
            for (int i = 0; i < DepartmentId.Length; i++)
            {
                
                    if (DeptId == "")
                        DeptId = "'" + Util.GetString(DepartmentId[i]) + "'";
                    else
                        DeptId = DeptId + ",'" + Util.GetString(DepartmentId[i]) + "'";
                
            }
            string Url = "";
            string ImgName = "";
            if (fuAttechment.HasFile)
            {
                var pathname = All_LoadData.createDocumentFolder("CircularDocuments", DateTime.Today.ToString("dd/MMM/yyy"));
                if (pathname == null)
                {
                    lblmsg.Text = "Error occurred, Please contact administrator ";
                    return "0";
                }

                string name = txtsub.Text;

                string Exte = System.IO.Path.GetExtension(fuAttechment.PostedFile.FileName);
                if (Exte != "")
                {
                    if (Exte != ".pdf" && Exte != ".jpg" && Exte != ".jpeg" && Exte != ".doc" && Exte != ".docx" && Exte != ".gif" && Exte != ".xlsx" && Exte != ".xls")
                    {
                        lblmsg.Text = "Wrong File Extension of Selected Document " + name;
                        return "1";
                    }
                }
                ImgName = fuAttechment.PostedFile.FileName;

                string fileName = txtsub.Text;

                string newFile = Guid.NewGuid().ToString() + Exte;
                Url = System.IO.Path.Combine(pathname + "\\" + ImgName);

                //if (!File.Exists(Url))
                //{
                //    File.Delete(Url);


                    fuAttechment.PostedFile.SaveAs(Url);
                    Url = Url.Replace("\\", "''");
                    Url = Url.Replace("'", "\\");

               // }

            }
            DataTable dt = StockReports.GetDataTable("SELECT fl.EmployeeID,fl.RoleID FROM f_login fl WHERE fl.roleid IN (" + DeptId + ") AND CentreID=" + Session["CentreID"] + " and fl.Active=1 AND fl.EmployeeID<>'EMP001' ");
            if (dt != null && dt.Rows.Count > 0)
            {
                StockReports.ExecuteDML("INSERT INTO Circular_Master(Message,FromId,FromDept,Sub,DocumentNo,URL,OldFileName,Centreid) values('" + txtmsg.Text + "','" + Util.GetString(Session["id"]) + "','" + Util.GetString(Session["RoleId"]) + "','" + txtsub.Text + "','" + txtDocNo.Text + "','" + Url + "','" + ImgName + "',"+ Session["CentreID"].ToString() +")");
                string message = StockReports.ExecuteScalar("select max(id) from circular_master");
                foreach (DataRow dr in dt.Rows)
                {
                    insertCircular(Util.GetString(Session["RoleId"]),
                                        Util.GetString(dr["RoleID"]), Util.GetString(Session["id"]), Util.GetString(dr["EmployeeID"]), txtsub.Text, message, "RoleWise");
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        return "";
    }

    private string savebyUser()
    {
        string text = txtmsg.Text;
        text = text.Replace("\'", "\''");
        text = text.Replace("–", "-");
        text = text.Replace("'", "'");
        text = text.Replace("µ", "&micro;");
       string Url="";
       string ImgName = "";
        if (fuAttechment.HasFile)
        {
            var pathname = All_LoadData.createDocumentFolder("CircularDocuments", DateTime.Today.ToString("dd/MMM/yyy"));
            if (pathname == null)
            {
               
                return "0";
            }
           
                string name = txtsub.Text;
               
                string Exte = System.IO.Path.GetExtension(fuAttechment.PostedFile.FileName);
                if (Exte != "")
                {
                    if (Exte != ".pdf" && Exte != ".jpg" && Exte != ".jpeg" && Exte != ".doc" && Exte != ".docx" && Exte != ".gif" && Exte != ".xlsx" && Exte != ".xls")
                    {
                       
                        return "1";
                    }
                }
                ImgName = fuAttechment.PostedFile.FileName;

                string fileName = txtsub.Text;

                string newFile = Guid.NewGuid().ToString() + Exte;
                Url = System.IO.Path.Combine(pathname + "\\" + fileName + Exte);

               // if (!File.Exists(Url))
              //  {
               //     File.Delete(Url);
                   
                    
                    fuAttechment.PostedFile.SaveAs(Url);
                    Url = Url.Replace("\\", "''");
                    Url = Url.Replace("'", "\\");
                    //return "2";
              //  }
            
        }
        StockReports.ExecuteDML("INSERT INTO Circular_Master(Message,FromId,FromDept,Sub,DocumentNo,URL,OldFileName,Centreid) values('" + text + "','" + Util.GetString(Session["id"]) + "','" + Util.GetString(Session["RoleId"]) + "','" + txtsub.Text + "','" + txtDocNo.Text + "','" + Url + "','" + ImgName + "'," + Session["CentreID"].ToString() + ")");
        string message = StockReports.ExecuteScalar("select max(id) from circular_master");
        string[] UserId = lblUserOrDeptList.Value.Split(',');
        for (int i = 0; i < UserId.Length; i++)
        {
            if (UserId[i] != "")
            {
                insertCircular(Util.GetString(Session["RoleId"]),
                    "", Util.GetString(Session["id"]), UserId[i], txtsub.Text, message, "UserWise");
            }
        }
        return "2";
    }

    private void insertCircular(string from_dept, string to_dept, string from_id, string to_id, string sub, string message, string type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("insert into circular_inbox(from_dept,to_dept,from_id,message,sub,to_id,CentreID) values('" + from_dept + "',");
        sb.Append(" '" + to_dept + "', ");
        sb.Append(" '" + from_id + "','" + message + "','" + sub + "', ");
        sb.Append(" '" + to_id + "'," + Session["CentreID"].ToString() + ")");
        StockReports.ExecuteDML(sb.ToString());
        if (to_dept == "")
            to_dept = "0";

        string ID = StockReports.ExecuteScalar("SELECT MAX(ID) FROM circular_inbox ");
        Notification_Insert.notificationInsert(14, ID, null, "", "", 0, DateTime.Now.ToString("yyyy-MM-dd"), to_id);
    }
}