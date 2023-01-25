using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class IEdit_IEdit : System.Web.UI.UserControl
{

    public string Text
    {
        get { return txtIEdit.Text.Replace("\'", "\''"); }
        set { txtIEdit.Text = value; }
    }
}
