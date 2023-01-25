using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Threading;
using System.Text;

using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;

using System.Collections.Generic;
using Newtonsoft.Json;
using SD = System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Linq;
using System.IO;
using System.Globalization;
using System.Threading;
using Resources;
using System.Xml;


public partial class Design_Lab_InvTemplate : System.Web.UI.Page
{
    All_LoadData ald = new All_LoadData();
    public string InvestigationID = "0";
  
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["invID"]))
                InvestigationID = Request.QueryString["invID"].ToString();
            //AllLoad_Data.bindSubCategory(ddlDepartment);
            DataTable dt = AllLoadData_OPD.BindLabRadioDepartment(Session["RoleID"].ToString());
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "Name";
            ddlDepartment.DataValueField = "ObservationType_ID";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("All", "0"));
            BindInvestigation();
           // btnSave.Visible = true;
           // BindLabObs();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindLabObs()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" Select LabObservation_ID,Name from labobservation_master ");
            string retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retr;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string FillTemplateDropDown(string InvestigationId)
    {
        string str = "SELECT it.`Template_ID`,it.`Temp_Head` FROM `investigation_template` it where Investigation_ID='" + InvestigationId + "'";
        //string str = "SELECT it.`Template_ID`,it.`Temp_Head` FROM `investigation_template` it ";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string FillUsers()
    {
        string str = "SELECT Id, Name 	FROM 	employee_master";
        //string str = "SELECT it.`Template_ID`,it.`Temp_Head` FROM `investigation_template` it ";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string FillMapping()
    {
        string str = "SELECT (SELECT im.NAME FROM investigation_master im WHERE im.Investigation_Id=itu.InvestigationId) AS IName, (SELECT it.Temp_Head FROM investigation_template it"+
            " WHERE it.Template_ID=itu.TemplateId) AS TNAME,  (SELECT em.NAME FROM employee_master  em WHERE em.ID=itu.UserId limit 1) AS UNAME  FROM tblInvestigationTemplateUser itu ";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string InsertMapping(string investigationid,string templateid,string userid)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string str = "INSERT INTO tblinvestigationtemplateuser (  `InvestigationId`,  `TemplateId`,  `UserId`)" +
    " VALUES (   '" + investigationid + "',    '" + templateid + "',    '" + userid + "'  );  ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();


            return "1";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0"; 
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();

        }
    }

    private void LoadObservationTypesLike(string investigationid, string templateid,string text)
    {
        string str = "SELECT Name,EmployeeID,(select count(*) from tblInvestigationTemplateUser where  InvestigationId='" + investigationid + "' and TemplateId='" +
            templateid + "' and UserId=EmployeeID) as Count   FROM employee_master where  Name like '%" + text + "%'  ";

        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);
        chkObservationType.DataSource = dt;
        chkObservationType.DataTextField = "Name";
        chkObservationType.DataValueField = "EmployeeID";
        chkObservationType.DataBind();

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                foreach (ListItem li in chkObservationType.Items)
                {
                    if (dr["EmployeeID"].ToString() == li.Value)
                    {
                        if (dr["Count"].ToString() == "0")
                            li.Selected = false;
                        else
                            li.Selected = true;

                        break;
                    }
                }
            }
        }
    }

    private void LoadObservationTypes(string investigationid,string templateid)

    {        
       /* string str = " SELECT  emp.Name,emp.EmployeeID,(SELECT COUNT(*) FROM tblInvestigationTemplateUser WHERE  InvestigationId='" + investigationid + "' and TemplateId='" +
               templateid + "'  AND UserId=emp.EmployeeID  AND IsActive=1)"+
            " AS COUNT    FROM employee_master  emp LEFT OUTER JOIN f_login fl ON emp.EmployeeID=fl.EmployeeID WHERE RoleID='104'"; */

         string str = " SELECT emp.Name,emp.EmployeeId, " +
         "  (SELECT COUNT(*) FROM tblInvestigationTemplateUser WHERE  InvestigationId='" + investigationid + "' AND TemplateId='" + templateid + "' AND UserId=emp.EmployeeID AND IsActive=1 ) AS COUNT " +
         "  FROM employee_master emp " +
         "  INNER JOIN f_login fl ON fl.EmployeeID = emp.EmployeeID " +
         "  WHERE fl.RoleID='104' AND fl.Active=1 AND fl.CentreId= '" + HttpContext.Current.Session["CentreID"].ToString() + "' ORDER BY NAME ";

        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);
        chkObservationType.DataSource = dt;
        chkObservationType.DataTextField = "Name";
        chkObservationType.DataValueField = "EmployeeID";
        chkObservationType.DataBind();

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                foreach (ListItem li in chkObservationType.Items)
                {
                    if (dr["EmployeeID"].ToString() == li.Value)
                    {
                        if(dr["Count"].ToString()=="0")
                        li.Selected = false;
                        else
                        li.Selected = true;
                        
                        break;
                    }
                }
            }
        }
    }
    
    private void BindInvestigation()
    {
        string str = "SELECT CONCAT(im.Name,' - ',Ifnull(im.TestCode,'')) as Name,im.Investigation_ID FROM  investigation_master im " +
        "   INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID AND it.IsActive=1 " +
        "   INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = it.SubCategoryID  " +
     //   "   INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.ConfigID='3'  " +
        "   INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.configID=3 " +
        "   INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID";
        if (ddlDepartment.SelectedValue != "0")
        {
            str = str + "  where iom.ObservationType_Id='" + ddlDepartment.SelectedValue + "'";
        }

        //if (Util.GetString(Session["RoleID"]) == "11")
        //    str = str + " and im.ReportType in (3) ";
        //else if (Util.GetString(Session["RoleID"]) == "15")
        //    str = str + " and im.ReportType in (5) ";
        //else
        //    str = str + " and im.ReportType in (3,5)";
        str = str + "   ORDER BY im.Name";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlInvestigation.DataSource = dt;
            ddlInvestigation.DataTextField = "Name";
            ddlInvestigation.DataValueField = "Investigation_Id";
            ddlInvestigation.DataBind();
            if (InvestigationID != "0")
            {
                ddlDepartment.Visible = false;
                ddlInvestigation.Items.FindByValue(InvestigationID).Selected = true;
                ddlInvestigation.Enabled = false;
                LoadTemplate();
                dtDept.Visible = false;
            }
            else
                ddlInvestigation.SelectedIndex = 0;
        }
        else
        {
            ddlInvestigation.Items.Clear();
        }

        LoadTemplate();
    }
    private void BindInvestigationModel()
    {
        string str = "SELECT CONCAT(im.Name,' - ',im.TestCode) as Name,im.Investigation_ID FROM  investigation_master im " +
        "   INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID AND it.IsActive=1 " +
        "   INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = it.SubCategoryID  " +
            //   "   INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.ConfigID='3'  " +
        "   INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.configID=3 " +
        "   INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID";
        if (ddlDepartment.SelectedValue != "0")
        {
            str = str + "  where iom.ObservationType_Id='" + ddlDepartment.SelectedValue + "'";
        }

        //if (Util.GetString(Session["RoleID"]) == "11")
        //    str = str + " and im.ReportType in (3) ";
        //else if (Util.GetString(Session["RoleID"]) == "15")
        //    str = str + " and im.ReportType in (5) ";
        //else
        //    str = str + " and im.ReportType in (3,5)";
        str = str + "   ORDER BY im.Name";
        DataTable dt = StockReports.GetDataTable(str);
        
        
    }
    private void BindTemplateModel()
    {
        

    }
    //protected void TextBox1_TextChanged(object sender, System.EventArgs e)
    //{
    //           LoadObservationTypesLike(txtInvestigationId.Value, txtTemplateId.Value, TextBox1.Text);
    //}
    private void LoadTemplate()
    {
        if (ddlInvestigation.SelectedIndex != -1)
        {
            string str = "Select Template_ID,Investigation_ID,Temp_Head,Template_Desc,(Select Name from " +
                  "Investigation_master where Investigation_ID='" + ddlInvestigation.SelectedValue + "')Investigation " +
                  "from investigation_template where Investigation_ID='" + ddlInvestigation.SelectedValue + "'";
                  //" and Template_ID in(Select TemplateId from tblInvestigationTemplateUser where UserId='" + Session["ID"].ToString() + 
                  //"' AND InvestigationId ='" + ddlInvestigation.SelectedValue + "' )";

            DataTable dt = StockReports.GetDataTable(str);

            if (dt != null && dt.Rows.Count > 0)
            {
                grdTemplate.DataSource = dt;
                grdTemplate.DataBind();
            }
            else
            {
                grdTemplate.DataSource = null;
                grdTemplate.DataBind();
            }
         //   ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "modelAlert(" + lblMsg.Text + ");", true);

        }
    }

    protected void ddlInvestigation_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadTemplate();
    }
    protected void ddlInvestigationModel_SelectedIndexChanged(object sender, EventArgs e)
    {
    }
    public bool validation()
    {
        if (ddlInvestigation.SelectedIndex == -1)
        {
         //   lblMsg.Text = "Please Select Investigation..!";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "myfunction('Please Select Investigation');", true);
            return false;
        }
        if (txtTemplate.Text == "")
        {
          //  lblMsg.Text = "Please Enter Template Name..!";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "myfunction('Please Enter Template Name');", true);
            return false;
        }
        if (txtLimit.Text == "")
        {
            //lblMsg.Text = "Please Enter Template Text..!";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "myfunction('Please Enter Template Text');", true);
            return false;
        }
        return true;
    }
   
    protected void btnSave_Click(object sender, EventArgs e)
    {
  

        if (ddlInvestigation.SelectedIndex == -1)
        {
            //lblMsg.Text = "Please Select Investigation..!";
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "modelAlert('Please Select Investigation');", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", ald.Alert("Please Select Investigation"));
            return;
        }
        if (txtTemplate.Text == "")
        {
            //lblMsg.Text = "Please Enter Template Name..!";
         //   ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "modelAlert('Please Enter Template Name');", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", ald.Alert("Please Enter Template Name"));
            return;
        }
        if (txtLimit.Text == "")
        {
            //lblMsg.Text = "Please Enter Template Text..!";
          //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key5", "modelAlert('Please Enter Template Text');", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", ald.Alert("Please Enter Template Text"));
            return;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string header = "";
        header = txtLimit.Text;
        header = header.Replace("\'", "");
        header = header.Replace("–", "-");
        header = header.Replace("'", "");
        header = header.Replace("µ", "&micro;");
        header = header.Replace("ᴼ", "&deg;");
        header = header.Replace("#aaaaaa 1px dashed", "none");
        header = header.Replace("dashed", "none");

        try
        {
            if (chkDefault.Checked)
            {
                string UpdateInves_Description = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update investigation_master set LabInves_Description='" + Util.GetString(header).Replace("'", "") + "' where Investigation_Id='" + ddlInvestigation.SelectedValue + "'"));
            }

            if (btnSave.Text != "Update")
            {
                string Head = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into investigation_template (Investigation_ID,Temp_Head,Template_Desc) values( '" + ddlInvestigation.SelectedValue + "','" + txtTemplate.Text.Trim() + "','" + header + "')"));
                DataTable dt = StockReports.GetDataTable(" SELECT (Template_ID+1) as Template_ID FROM investigation_template ORDER BY Template_ID DESC LIMIT 1 ");
                string templateid = dt.Rows[0]["Template_ID"].ToString();
                string str = "INSERT INTO tblinvestigationtemplateuser (  `InvestigationId`,  `TemplateId`,  `UserId`,`IsActive`)" +
                            " VALUES (   '" + ddlInvestigation.SelectedValue + "',    '" + templateid + "',    '" + Session["ID"].ToString() + "' ,1 );  ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                // lblMsg.Text = "Saved Successfully.";

                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", ald.Alert("Record Saved Successfully"));
              //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key6",  sb.ToString(), true);

            }
            else
            {
                string Head = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update investigation_template set Temp_Head = '" + txtTemplate.Text.Trim() + "',Template_Desc='" + header + "' Where Template_ID =" + ViewState["Template_ID"].ToString()));

                ViewState["Template_ID"] = "";
              //  message = "Record Updated Successfully";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key7", sb.ToString(), true);
                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", ald.Alert("Record Updated Successfully"));
                //   lblMsg.Text = "Updated Successfully.";
              

            }

            tnx.Commit();


            btnSave.Text = "Save";
            txtLimit.Text = "";
            txtTemplate.Text = "";
            chkDefault.Checked = false;
            LoadTemplate(); 
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert(" + ex.Message + ");", true);
            lblMsg.Text = ex.Message;
            tnx.Rollback();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    [WebMethod]
    public static string SaveUpdate(string Status, string InvID, string header, string DefaultTemplate, string TemplateName)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string header1 = "";
        header1 = header;
        header = header.Replace("\'", "");
        header = header.Replace("–", "-");
        header = header.Replace("'", "");
        header = header.Replace("µ", "&micro;");
        header = header.Replace("ᴼ", "&deg;");
        header = header.Replace("#aaaaaa 1px dashed", "none");
        header = header.Replace("dashed", "none");

        try
        {
            if (DefaultTemplate == "1")
            {
                string UpdateInves_Description = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update investigation_master set LabInves_Description='" + Util.GetString(header).Replace("'", "") + "' where Investigation_Id='" + InvID + "'"));
            }

            if (Status != "Update")
            {
                string Head = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into investigation_template (Investigation_ID,Temp_Head,Template_Desc) values( '" + InvID + "','" + TemplateName.Trim() + "','" + header + "')"));

            }
            else
            {
                //string Head = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update investigation_template set Temp_Head = '" + txtTemplate.Text.Trim() + "',Template_Desc='" + header + "' Where Template_ID =" + ViewState["Template_ID"].ToString()));

                //ViewState["Template_ID"] = "";
                // ScriptManager.RegisterStartupScript(this, this.GetType(), "key7", "myfunction('Record Updated Successfully');", true);
                //   lblMsg.Text = "Updated Successfully.";

            }

            tnx.Commit();


            //btnSave.Text = "Save";
            //txtLimit.Text = "";
            //txtTemplate.Text = "";
            //chkDefault.Checked = false;
            //LoadTemplate();

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "modelAlert(" + ex.Message + ");", true);
            //lblMsg.Text = ex.Message;
            tnx.Rollback();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        return "";
    }

    protected void grdTemplate_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            string Template_ID = e.CommandArgument.ToString();
            StockReports.ExecuteDML("Delete from investigation_template where Template_ID =" + Template_ID);
            lblMsg.Text = "Deleted Successfully";
          //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key9", "modelAlert('Record Deleted Successfully');", true);
           // ScriptManager.RegisterStartupScript(this, GetType(), "showalert", " myfunction('Record Deleted Successfully');", true);
            ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", ald.Alert("Record Deleted Successfully"));


            txtLimit.Text = "";
            txtTemplate.Text = "";
            LoadTemplate();
        }
        else if (e.CommandName == "vEdit")
        {
            string Template_ID = e.CommandArgument.ToString();

            DataTable dt = StockReports.GetDataTable("Select * from investigation_template where Template_ID =" + Template_ID);

            if (dt != null && dt.Rows.Count > 0)
            {
                txtTemplate.Text = dt.Rows[0]["Temp_Head"].ToString();
                txtLimit.Text = Server.HtmlDecode(Util.GetString(dt.Rows[0]["Template_Desc"]));
                btnSave.Text = "Update";
                ViewState["Template_ID"] = Template_ID;
            }
        }
        else if (e.CommandName == "addMapping")
        {
            string Template_ID = e.CommandArgument.ToString();

            DataTable dt = StockReports.GetDataTable("Select * from investigation_template where Template_ID =" + Template_ID);

            if (dt != null && dt.Rows.Count > 0)
            {
               string temphead = dt.Rows[0]["Temp_Head"].ToString();
                string investigationid = Server.HtmlDecode(Util.GetString(dt.Rows[0]["Investigation_ID"]));
                txtInvestigationId.Value = investigationid;
                txtTemplateId.Value = Template_ID;
                
                LoadObservationTypes(investigationid, Template_ID);
            }
            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", " $showOldPatientSearchModel();", true);
            
        }
    }
    public class Mapping
    {
        public string Value { get; set; }
        public string Check { get; set; }
    }
    [WebMethod(EnableSession = true, Description = "Save Intake")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveIntake(object Intake, string PID, string TID)
    {
        List<Mapping> mappings = new JavaScriptSerializer().ConvertToType<List<Mapping>>(Intake);
        if (mappings.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < mappings.Count; i++)
                {
                    /* DataTable dt = StockReports.GetDataTable(" Select Count(*)Count from tblinvestigationtemplateuser where InvestigationId='" + PID + "' and TemplateId='" + TID + "' and UserId='" + mappings[i].Value + "' ");
                     if (dt.Rows.Count <= 0)
                     {
                         if (mappings[i].Check == "Yes")
                         {
                             string str = "INSERT INTO tblinvestigationtemplateuser (  `InvestigationId`,  `TemplateId`,  `UserId`,`IsActive`)" +
                             " VALUES (   '" + PID + "',    '" + TID + "',    '" + mappings[i].Value + "' ,1 );  ";
                             MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                         }
                     }
                     else
                     {
                         if (mappings[i].Check == "No")
                         {
                             string str = "update `tblinvestigationtemplateuser` set IsActive=0  WHERE `Id` = '"+dt.Rows[0]["Id"].ToString()+"';";
                             MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);                        
                         }                    
                     }  */

                    if (mappings[i].Check == "Yes")
                    {
                        DataTable dt = StockReports.GetDataTable(" Select Isactive,Id from tblinvestigationtemplateuser where InvestigationId='" + PID + "' and TemplateId='" + TID + "' and UserId='" + mappings[i].Value + "' ORDER BY Id DESC LIMIT 1 ");
                        if (dt.Rows.Count > 0)
                        {
                            if (dt.Rows[0]["Isactive"].ToString() != "1" && dt.Rows.Count <= 0)
                            {
                                string str = "INSERT INTO tblinvestigationtemplateuser (  `InvestigationId`,  `TemplateId`,  `UserId`,`IsActive`)" +
                                  " VALUES (   '" + PID + "',    '" + TID + "',    '" + mappings[i].Value + "' ,1 );  ";
                                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                            }
                            else
                            {
                                string str = "update `tblinvestigationtemplateuser` set IsActive=1  WHERE Id = '" + dt.Rows[0]["Id"].ToString() + "';";
                                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                            }

                        }
                        else
                        {
                            string str = "INSERT INTO tblinvestigationtemplateuser ( `InvestigationId`,  `TemplateId`,  `UserId`,`IsActive`)" +
                                  " VALUES (   '" + PID + "',    '" + TID + "',    '" + mappings[i].Value + "' ,1 );  ";
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                        }
                    }
                    else
                    {                     
                        DataTable dt = StockReports.GetDataTable(" Select Isactive,Id from tblinvestigationtemplateuser where InvestigationId='" + PID + "' and TemplateId='" + TID + "' and UserId='" + mappings[i].Value + "' ORDER BY Id DESC LIMIT 1 ");
                        if (dt.Rows.Count > 0)
                        {
                            if (dt.Rows[0]["Isactive"].ToString() != "0")
                            {
                                string str = "update `tblinvestigationtemplateuser` set IsActive=0  WHERE Id = '" + dt.Rows[0]["Id"].ToString() + "';";
                                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
                            }
                        }
                    }

                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "";
        }
    }

    protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            BindInvestigation();
        }
    }
}