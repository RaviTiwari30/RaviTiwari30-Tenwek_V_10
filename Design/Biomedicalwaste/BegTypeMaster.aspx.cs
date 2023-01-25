using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Biomedicalwaste_BegTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    //protected void btnsave_Click(object sender, EventArgs e)
    //{
    //    string str = string.Empty;
    //    System.IO.Stream fs = fileuploadmenu.PostedFile.InputStream;
    //    System.IO.BinaryReader br = new System.IO.BinaryReader(fs);
    //    Byte[] bytes = br.ReadBytes((Int32)fs.Length);
    //    string base64image = Convert.ToBase64String(bytes, 0, bytes.Length);
    //    //string base64image = this.PhotoBase64ImgSrc(fileuploadmenu.ToString());
    //     StockReports.ExecuteDML("CALL  GetIPDOPD_Bill_Report ('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(Todate).ToString("yyyy-MM-dd") + "','" + Type + "')");
    //    //str = "insert into  f_menumaster(MenuName,image) values('" + txtNMenu.Text.Trim() + "','" + string.Format("data:image/jpg;base64,{0}", base64image) + "')";
    //    //if (StockReports.ExecuteDML(str))
    //    //{
    //    //    lblMsg.Text = "Record Saved Successfully";
    //    //    BindMenu();
    //    //    txtNMenu.Text = string.Empty;
    //    //}
    //    //else
    //    //    lblMsg.Text = "Error...";
    //}
}