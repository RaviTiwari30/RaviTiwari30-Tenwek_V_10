using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using System.Data;
/// <summary>
/// Summary description for Common
/// </summary>
public class Common
{
	public Common()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public int checkemptydate(string value)
    {
        if (String.IsNullOrEmpty(value))
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }
   
    public void ClearControls(Control Container, Page WebForm)
    {
        foreach (Control ctrl in Container.Controls)
        {
            if (ctrl is Menu)
                continue;
            // ** Recursively call down into any containers 
            if (ctrl.Controls.Count > 0)
                ClearControls(ctrl, WebForm);

            if (ctrl is TextBox)
            {
                ((TextBox)ctrl).Text = "";
            }
            if (ctrl is ListControl)
            {
                if (((ListControl)ctrl).Items.Count > 0)
                {
                    ((ListControl)ctrl).SelectedIndex = 0;
                }
            }
            if (ctrl is DropDownList)
            {
                if (((DropDownList)ctrl).Items.Count > 0)
                {
                    ((DropDownList)ctrl).SelectedIndex = 0;
                }
            }
            if (ctrl is GridView)
            {
                ((GridView)ctrl).DataSource = null;
                ((GridView)ctrl).DataBind();

            }

            if (ctrl is CheckBox)
            {
                if (((CheckBox)ctrl).Checked == true)
                {
                    ((CheckBox)ctrl).Checked = false;
                }
            }

        }
    }
    public void DisableControls(Control Container, Page WebForm)
    {
        foreach (Control ctrl in Container.Controls)
        {
            if (ctrl is Menu)
                continue;
            // ** Recursively call down into any containers 
            if (ctrl.Controls.Count > 0)
                DisableControls(ctrl, WebForm);

            if (ctrl is TextBox)
            {
                ((TextBox)ctrl).Enabled = false;
            }
            if (ctrl is ListControl)
            {
                ((ListControl)ctrl).Enabled = false;
            }
            if (ctrl is CheckBox)
            {
                ((CheckBox)ctrl).Enabled = false;
            }

        }
    }
    public void EnableControls(Control Container, Page WebForm)
    {
        foreach (Control ctrl in Container.Controls)
        {
            if (ctrl is Menu)
                continue;
            // ** Recursively call down into any containers 
            if (ctrl.Controls.Count > 0)
                EnableControls(ctrl, WebForm);

            if (ctrl is TextBox)
            {
                ((TextBox)ctrl).Enabled = true;
            }
            if (ctrl is ListControl)
            {
                ((ListControl)ctrl).Enabled = true;
            }
            if (ctrl is CheckBox)
            {
                ((CheckBox)ctrl).Enabled = true;
            }
        }
    }

    public void InvisibleControls(Control Container, Page WebForm)
    {
        foreach (Control ctrl in Container.Controls)
        {
            if (ctrl is Menu)
                continue;
            // ** Recursively call down into any containers 
            if (ctrl.Controls.Count > 0)
                InvisibleControls(ctrl, WebForm);

            if (ctrl is TextBox)
            {
                ((TextBox)ctrl).Visible = false;
            }
            if (ctrl is ListControl)
            {
                ((ListControl)ctrl).Visible = false;
            }
            if (ctrl is CheckBox)
            {
                ((CheckBox)ctrl).Visible = false;
            }
            if (ctrl is Label)
            {
                ((Label)ctrl).Visible = false;
            }
            if (ctrl is DropDownList)
            {
                ((DropDownList)ctrl).Visible = false;
            }
        }
    }

    public void VisibleControls(Control Container, Page WebForm)
    {
        foreach (Control ctrl in Container.Controls)
        {
            if (ctrl is Menu)
                continue;
            // ** Recursively call down into any containers 
            if (ctrl.Controls.Count > 0)
                VisibleControls(ctrl, WebForm);

            if (ctrl is TextBox)
            {
                ((TextBox)ctrl).Visible = true;
            }
            if (ctrl is ListControl)
            {
                ((ListControl)ctrl).Visible = true;
            }
            if (ctrl is CheckBox)
            {
                ((CheckBox)ctrl).Visible = true;
            }
            if (ctrl is Label)
            {
                ((Label)ctrl).Visible = true;
            }
            if (ctrl is DropDownList)
            {
                ((DropDownList)ctrl).Visible = true;
            }
        }
    }

    public void ScriptMsg(string str, Page webpageinstance)
    {
       
        string strScript = "<script language=JavaScript runat=server> window.alert('" + str + "')</script>";
        if (!webpageinstance.ClientScript.IsStartupScriptRegistered("clientScript"))
        {
            webpageinstance.ClientScript.RegisterStartupScript(typeof(Page), "clientScript", strScript);
        }
    }

    public void ScriptMsgForAjax(string str, Page webpageinstance)
    {
        string strScript = "window.alert('" + str + "');";
        ScriptManager.RegisterStartupScript(webpageinstance, this.GetType(), "clientScript", strScript, true);
    }
    public static string Encrypt(string encryptText)
    {
        string EncryptionKey = "MAKV2SPBNI99212";
        byte[] clearBytes = Encoding.Unicode.GetBytes(encryptText);
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
                }
                encryptText = Convert.ToBase64String(ms.ToArray());
            }
        }
        return encryptText;
    }
    public static string Decrypt(string decryptText)
    {
        string EncryptionKey = "MAKV2SPBNI99212";
        byte[] cipherBytes = Convert.FromBase64String(decryptText);
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
                decryptText = Encoding.Unicode.GetString(ms.ToArray());
            }
        }
        return decryptText;
    }
    public static void CreateCache(string CacheName, DataSet ds)
    {
        HttpContext.Current.Cache.Remove(CacheName);
        HttpContext.Current.Cache.Insert(CacheName, ds, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddSeconds(Util.GetInt(Resources.Resource.ReportCacheTimeOutSec)), System.Web.Caching.Cache.NoSlidingExpiration);
    }
    public static void CreateCachedt(string CacheName, DataTable dt)
    {
        HttpContext.Current.Cache.Remove(CacheName);
        HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddSeconds(Util.GetInt(Resources.Resource.ReportCacheTimeOutSec)), System.Web.Caching.Cache.NoSlidingExpiration);
    }
    public static string CreateAgeingColumn(string AgeingDays, string FromAmount, string ReceivedAmount, string AgeingType, string AgeingWho, bool GroupBy)
    {
        DataTable dt = StockReports.GetDataTable("SELECT * FROM ageing_bucket WHERE Type='" + AgeingType + "' AND AgeingWho='" + AgeingWho + "' AND IsActive=1 Order By SequenceNo ");
        string str = string.Empty;
        if (dt.Rows.Count > 0)
        {

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (GroupBy == false)
                {
                    if (Util.GetInt(dt.Rows[i]["FromLimit"].ToString()) > Util.GetInt(dt.Rows[i]["ToLimit"].ToString()))
                    {
                        str += ",(IF(" + AgeingDays + " >= " + dt.Rows[i]["FromLimit"].ToString() + ", (" + FromAmount + "-" + ReceivedAmount + "), 0)) AS '>=" + dt.Rows[i]["FromLimit"].ToString() + " " + dt.Rows[i]["Type"] + "' ";
                    }
                    else if (dt.Rows[i]["FromLimit"].ToString() != dt.Rows[i]["ToLimit"].ToString())
                    {
                        str += ",(IF(" + AgeingDays + " BETWEEN " + dt.Rows[i]["FromLimit"].ToString() + " AND " + dt.Rows[i]["ToLimit"].ToString() + ", (" + FromAmount + "-" + ReceivedAmount + "), 0)) AS '" + dt.Rows[i]["FromLimit"].ToString() + "-" + dt.Rows[i]["ToLimit"].ToString() + " " + dt.Rows[i]["Type"] + "' ";
                    }
                    else if (dt.Rows[i]["FromLimit"].ToString() == dt.Rows[i]["ToLimit"].ToString())
                        str += ",(IF(" + AgeingDays + " = " + dt.Rows[i]["FromLimit"].ToString() + ", (" + FromAmount + "-" + ReceivedAmount + "), 0)) AS '" + dt.Rows[i]["FromLimit"].ToString() + " " + dt.Rows[i]["Type"] + "' ";
                }
                else
                {
                    if (Util.GetInt(dt.Rows[i]["FromLimit"].ToString()) > Util.GetInt(dt.Rows[i]["ToLimit"].ToString()))
                    {
                        str += ",SUM(IF(" + AgeingDays + " >= " + dt.Rows[i]["FromLimit"].ToString() + ", (" + FromAmount + "-" + ReceivedAmount + "), 0)) AS '>=" + dt.Rows[i]["FromLimit"].ToString() + " " + dt.Rows[i]["Type"] + "' ";
                    }
                    else if (dt.Rows[i]["FromLimit"].ToString() != dt.Rows[i]["ToLimit"].ToString())
                    {
                        str += ",SUM(IF(" + AgeingDays + " BETWEEN " + dt.Rows[i]["FromLimit"].ToString() + " AND " + dt.Rows[i]["ToLimit"].ToString() + ", (" + FromAmount + "-" + ReceivedAmount + "), 0)) AS '" + dt.Rows[i]["FromLimit"].ToString() + "-" + dt.Rows[i]["ToLimit"].ToString() + " " + dt.Rows[i]["Type"] + "' ";
                    }
                    else if (dt.Rows[i]["FromLimit"].ToString() == dt.Rows[i]["ToLimit"].ToString())
                        str += ",SUM(IF(" + AgeingDays + " = " + dt.Rows[i]["FromLimit"].ToString() + ", (" + FromAmount + "-" + ReceivedAmount + "), 0)) AS '" + dt.Rows[i]["FromLimit"].ToString() + " " + dt.Rows[i]["Type"] + "' ";
                }
            }
            return str;
        }
        else
            return str;
    }
    public static string CreateAgeingSummaryColumn(string AgeingType, string AgeingWho)
    {
        DataTable dt = StockReports.GetDataTable("SELECT * FROM ageing_bucket WHERE Type='" + AgeingType + "' AND AgeingWho='" + AgeingWho + "' AND IsActive=1 Order By SequenceNo ");
        string str = string.Empty;
        if (dt.Rows.Count > 0)
        {

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (Util.GetInt(dt.Rows[i]["FromLimit"].ToString()) > Util.GetInt(dt.Rows[i]["ToLimit"].ToString()))
                {
                    str += ",SUM(`>=" + dt.Rows[i]["FromLimit"].ToString() + " " + dt.Rows[i]["Type"] + "`)  AS `>=" + dt.Rows[i]["FromLimit"].ToString() + " " + dt.Rows[i]["Type"] + "` ";
                }
                else if (dt.Rows[i]["FromLimit"].ToString() != dt.Rows[i]["ToLimit"].ToString())
                {
                    str += ",SUM(`" + dt.Rows[i]["FromLimit"].ToString() + "-" + dt.Rows[i]["ToLimit"].ToString() + " " + dt.Rows[i]["Type"] + "`) AS `" + dt.Rows[i]["FromLimit"].ToString() + "-" + dt.Rows[i]["ToLimit"].ToString() + " " + dt.Rows[i]["Type"] + "` ";
                }
                else if (dt.Rows[i]["FromLimit"].ToString() == dt.Rows[i]["ToLimit"].ToString())
                    str += ",SUM(`" + dt.Rows[i]["FromLimit"].ToString() + " " + dt.Rows[i]["Type"] + "`) AS `" + dt.Rows[i]["FromLimit"].ToString() + " " + dt.Rows[i]["Type"] + "` ";
            }
            return str;
        }
        else
            return str;
    }
}