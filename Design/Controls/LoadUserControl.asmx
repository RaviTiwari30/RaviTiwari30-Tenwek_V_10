<%@ WebService Language="C#" Class="LoadUserControl" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Web.UI;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class LoadUserControl  : System.Web.Services.WebService {



    [WebMethod(EnableSession = true)]
    public string LoadControl(List<string> userControlNames,bool isControlHaveScriptManager)
    {
        using (System.Web.UI.Page objPage = new System.Web.UI.Page())
        {
            List<UserControl> userControls = new List<UserControl>();
            userControlNames.ForEach(i => {
                userControls.Add((System.Web.UI.UserControl)objPage.LoadControl("~/design/Controls/"+i.ToString()));
            });
            System.Web.UI.HtmlControls.HtmlForm form = new System.Web.UI.HtmlControls.HtmlForm();
            System.Web.UI.HtmlControls.HtmlHead head = new System.Web.UI.HtmlControls.HtmlHead();
            System.Web.UI.ScriptManager scriptManager = new System.Web.UI.ScriptManager();
            head.Attributes.Add("runat", "server");
            userControls.ForEach(i => {
                form.Controls.Add(i);
            });
            if (isControlHaveScriptManager)
                form.Controls.Add(scriptManager);
            objPage.Controls.Add(head);
            objPage.Controls.Add(form);
            using (System.IO.StringWriter sWriter = new System.IO.StringWriter())
            {
                HttpContext.Current.Server.Execute(objPage, sWriter, false);
                return sWriter.ToString();
            }
        }
    }

   
}