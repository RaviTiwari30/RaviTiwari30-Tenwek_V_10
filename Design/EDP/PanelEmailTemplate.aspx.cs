using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_EDP_PanelEmailTemplate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //All_LoadData.bindPanel(ddlPanel);
            //ddlPanel.Items.Insert(0, new ListItem("Select","0"));

        }
    }


    public class PanelMailTemplate
    {
        public int panelID { get; set; }
        public string mailSubject { get; set; }
        public string templateName { get; set; }
        public string template { get; set; }
        public string userID { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveTemplate(PanelMailTemplate panelMailTemplate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {

            ExcuteCMD excuteCMD = new ExcuteCMD();
            panelMailTemplate.userID = HttpContext.Current.Session["ID"].ToString();
            excuteCMD.DML(tnx, "UPDATE email_paneltemplate up SET up.IsActive=0 WHERE up.PanelID=@panelID", CommandType.Text, panelMailTemplate);

            excuteCMD.DML(tnx,"INSERT INTO email_paneltemplate (PanelID,TemplateName, EmailSubject, EmailBody, CreatedBy) VALUES (@panelID,@templateName,@mailSubject,@template,@userID)", CommandType.Text, panelMailTemplate);


            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }

    [WebMethod]
    public static string GetPanelEmailTemplate(string panelID, string templateID)
    {
                ExcuteCMD excuteCMD= new ExcuteCMD();
                StringBuilder sqlCMD = new StringBuilder("SELECT pt.EmailSubject,pt.EmailBody,pt.PanelID,pt.TemplateName,pt.ID FROM email_paneltemplate pt WHERE pt.IsActive=1 ");
                if (!string.IsNullOrEmpty(templateID))
                    sqlCMD.Append(" AND pt.ID=@templateID ");
                else
                    sqlCMD.Append(" AND pt.PanelID=@panelID ");

                var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
                {
                    panelID=panelID,
                    templateID = templateID
                });
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public static string GetPanelTemplateDynamicField() {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ed.DisplayField,ed.ValueField FROM email_paneltemplate_field ed "));
    }



}