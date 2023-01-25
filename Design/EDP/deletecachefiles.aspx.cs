using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_DeleteCacheFiles : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        try
        {
            var path = Server.MapPath("~/CacheDependency");
            System.IO.DirectoryInfo di = new System.IO.DirectoryInfo(path);

            foreach (System.IO.FileInfo file in di.GetFiles())
            {
                file.Delete();
            }
            foreach (System.IO.DirectoryInfo dir in di.GetDirectories())
            {
                dir.Delete(true);
            }
            lblMsg.Text = "Successfully Deleted All Files.";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            lblMsg.Text = "Can not Delete Files.";
        }
    }
}