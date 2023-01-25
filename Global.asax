<%@ Application Language="C#" %>
<%@ Import Namespace="HiQPdf" %>
<script RunAt="server">
   

    void Application_PreRequestHandlerExecute(Object sender, EventArgs e)
    {

        if (Context.Handler is IRequiresSessionState || Context.Handler is IReadOnlySessionState)
        {
            try
            {
                var page = (Context.Handler as System.Web.UI.Page);
                var pageName = System.IO.Path.GetFileName(Request.Url.AbsolutePath);
                if (pageName != "Default.aspx" && pageName != "Welcome.aspx" && pageName.ToLower() != "labreportmicro.aspx" && pageName.ToLower() != "labreportnewhisto.aspx" && pageName.ToLower() != "printlabreport_pdf.aspx" && pageName.ToLower() != "createzip.aspx" && pageName.ToLower() != "result.aspx" && pageName.ToLower() != "getmodalityworklist")
                {
                    if (Session["ID"] == null)
                        this.Context.Response.Redirect("~/Default.aspx?sessionTimeOut=true");

                }
            }
            catch (Exception)
            {
                
            }

        }

    }


    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup
        HtmlToPdf.MaxParallelConversions = 20; 
        //if CacheDirectory not Exist then Create it
        if (!System.IO.Directory.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency")))
        {
            System.IO.Directory.CreateDirectory(HttpContext.Current.Server.MapPath("~/CacheDependency"));
        }
        string status = Util.checkDB_Conn();
        if (status.Split('#')[0] == "0")
        {
            this.Context.Response.Redirect("~/Default.aspx?sessionTimeOut=true");
        }
        else
        {
            LoadCacheQuery.dropAllCache();
            All_LoadData.bindCentreCache();
            LoadCacheQuery.loadAllDataonCache();
        }
        System.Web.Optimization.BundleTable.Bundles.Add(new System.Web.Optimization.ScriptBundle("~/bundle/js")
       .Include("~/Scripts/jquery-1.7.1.min.js",
                    "~/Scripts/toastr.min.js",
                    "~/Scripts/chosen.jquery.js",
                    "~/Scripts/jquery-ui.js",
                    "~/Scripts/shortcut.js",
                    "~/Scripts/jquery.slimscroll.min.js",
                    "~/Scripts/MarcTooltips.js",
                     "~/Scripts/Common.js",
                    "~/Scripts/Master-Js/Master.js",
                    "~/Scripts/class2context.js",
                    "~/Scripts/html2canvas.js",
                    "~/Scripts/json2.js",
                    "~/Scripts/blockui.js",
                    "~/Scripts/jquery.multiple.select.js"
       ));

        System.Web.Optimization.BundleTable.Bundles.Add(new System.Web.Optimization.StyleBundle("~/bundle/css")
        .Include("~/Styles/PurchaseStyle.css",
                    "~/Styles/toastrsample.css",
                    "~/Styles/grid24.css",
                    "~/Styles/CustomStyle.css",
                    "~/Styles/chosen.css",
                    "~/Styles/jquery-ui.css",
                    "~/Styles/RoleDesign/style.css",
                    "~/Styles/Newcss/opa-icons.css",
                    "~/Styles/Newcss/charisma-app.css",
                    "~/Styles/MarcTooltips.css", "~/Styles/multiple-select.css"
       ));

        System.Web.Optimization.BundleTable.Bundles.Add(new System.Web.Optimization.ScriptBundle("~/bundle/folderjs")
      .Include("~/Scripts/jquery-1.7.1.min.js",
                   "~/Scripts/jquery.easyui.min.js",
                    "~/Scripts/MarcTooltips.js",
                   "~/Scripts/Common.js",
                   "~/Scripts/jquery.slimscroll.min.js",
                    "~/Scripts/blockui.js",
                    "~/Scripts/jquery.multiple.select.js"

      ));

        System.Web.Optimization.BundleTable.Bundles.Add(new System.Web.Optimization.StyleBundle("~/bundle/foldercss")
     .Include("~/Styles/easyui.css",
                    "~/Styles/grid24.css",
                    "~/Styles/PurchaseStyle.css",
                    "~/Styles/CustomStyle.css",
                    "~/Styles/ModuleFolder.css",
                     "~/Styles/MarcTooltips.css", "~/Styles/multiple-select.css"

     ));

                System.Web.Optimization.BundleTable.Bundles.Add(new System.Web.Optimization.ScriptBundle("~/bundle/folderinjs")
        .Include("~/Scripts/jquery-1.7.1.min.js",
                    "~/Scripts/chosen.jquery.js",
                    "~/Scripts/MarcTooltips.js",
                   "~/Scripts/Common.js",
                   "~/Scripts/jquery.slimscroll.min.js",
                   "~/Scripts/jquery-ui.js",
                   "~/Scripts/searchableDroplist.JS",
                    "~/Scripts/blockui.js",
                    "~/Scripts/jquery.multiple.select.js"

        ));

                System.Web.Optimization.BundleTable.Bundles.Add(new System.Web.Optimization.StyleBundle("~/bundle/folderincss")
             .Include("~/Styles/jquery-ui.css",
                            "~/Styles/grid24.css",
                             "~/Styles/chosen.css",
                             "~/Styles/framestyle.css",
                             "~/Styles/CustomStyle.css",
                             "~/Styles/MarcTooltips.css",
                             "~/Styles/Newcss/opa-icons.css",
                             "~/Styles/Newcss/charisma-app.css", "~/Styles/multiple-select.css"

             ));
        
        
    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started
        // var sessionDepartment = Session["DeptLedgerNo"].ToString();
    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.
       // HttpContext.Current.Session.Abandon();
       // this.Context.Response.Redirect("~/Default.aspx?sessionTimeOut=true");
    }
   
</script>
