using System;
using System.Data;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class OnlineLab_Login : System.Web.UI.Page
{
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (txtUserName.Text.Trim() == "")
        {
            lblError.Text = "Please Enter User Name";
            txtUserName.Focus();
            return;
        }
        if (txtPassword.Text.Trim() == "")
        {
            lblError.Text = "Please Enter Password";
            txtPassword.Focus();
            return;
        }
        string sql = " CALL Login('1','" + txtUserName.Text.Trim() + "','" + txtPassword.Text.Trim() + "') ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows[0]["Authorize"].ToString() == "0")
        {
            lblError.Text = dt.Rows[0]["Message"].ToString();
            return;
        }
        else
        {
            Session["OnLineID"] = System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(txtUserName.Text.Trim()));
            string PID = HttpUtility.UrlEncode(Encrypt(txtUserName.Text.Trim()));
            string LedgerTransactionNo = HttpUtility.UrlEncode(Encrypt(dt.Rows[0]["LedgertransactionNo"].ToString()));
            string TID = TID = HttpUtility.UrlEncode(Encrypt(dt.Rows[0]["TID"].ToString()));
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "location.href('ViewOnlineReport.aspx?PID=" + PID + "&LedgerTransactionNo=" + LedgerTransactionNo + "&TID=" + TID + "');", true);
            Response.Redirect("ViewOnlineReport.aspx?PID=" + PID + "&LedgerTransactionNo=" + LedgerTransactionNo + "&TID=" + TID + " ");
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        Page.Header.DataBind();
        if (Request.ServerVariables["http_user_agent"].IndexOf
        ("Safari", StringComparison.CurrentCultureIgnoreCase) != -1)
        {
            Page.ClientTarget = "uplevel";
        }

        if (Request.ServerVariables["http_user_agent"].IndexOf
        ("chrome", StringComparison.CurrentCultureIgnoreCase) != -1)
        {
            Page.ClientTarget = "uplevel";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlUserType.Focus();
        }
    }

    private string Encrypt(string clearText)
    {
        string EncryptionKey = "MAKV2SPBNI99212";
        byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(clearBytes, 0, clearBytes.Length);
                    cs.Close();
                    cs.Dispose();
                }
                clearText = Convert.ToBase64String(ms.ToArray());
            }
        }
        return clearText;
    }
}