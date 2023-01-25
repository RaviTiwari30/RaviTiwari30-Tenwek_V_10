using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;

public partial class OnlineLab_ViewOnlineReport : System.Web.UI.Page
{
    public string PID = string.Empty, LedgerTransactionNo = string.Empty, TID = string.Empty;

    protected void lbLogOut_Click(object sender, EventArgs e)
    {
        Session.RemoveAll();
        Session.Abandon();
        // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "location.href('../OnlineLab/Login.aspx');", true);
        Response.Redirect("../OnlineLab/Login.aspx");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                if (Convert.ToString(Session["OnLineID"]) == "")
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "location.href('Login.aspx');", true);
                    Response.Redirect("Login.aspx");
                    return;
                }
                else
                {
                    PID = Decrypt(HttpUtility.UrlDecode(Request.QueryString["PID"]));
                    LedgerTransactionNo = Decrypt(HttpUtility.UrlDecode(Request.QueryString["LedgerTransactionNo"]));
                    TID = Decrypt(HttpUtility.UrlDecode(Request.QueryString["TID"]));
                    string OnLineID = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(Session["OnLineID"].ToString()));
                }
            }
        }
        catch (Exception ex)
        {
            if (ex.Message == "Invalid length for a Base-64 char array or string.")
            {
            }
            Response.Redirect("Login.aspx");

            // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.location.href('Login.aspx');", true);
            return;
        }
    }

    private string Decrypt(string cipherText)
    {
        string EncryptionKey = "MAKV2SPBNI99212";
        cipherText = cipherText.Replace(" ", "+");
        byte[] cipherBytes = Convert.FromBase64String(cipherText);
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(cipherBytes, 0, cipherBytes.Length);
                    cs.Close();
                }
                cipherText = Encoding.Unicode.GetString(ms.ToArray());
            }
        }
        return cipherText;
    }
}