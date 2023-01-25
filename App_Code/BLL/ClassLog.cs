using System;
using System.IO;
using System.Net;
using System.Web;
using System.Management;
using System.Windows.Forms;
/// <summary>
/// Summary description for ClassLog
/// </summary>
public class ClassLog
{

    
	public ClassLog()
	{
        
       

	}

    public void GeneralLog(string exp)
    {

        FileStream fs;
        StreamWriter sw;

        if (System.IO.File.Exists("GeneralLog.txt"))
        {
            sw = File.AppendText("GeneralLog.txt");
            sw.WriteLine("  **********************************************  ");
            sw.WriteLine(" Date Time                : {0}", System.DateTime.Now.ToString());
            sw.WriteLine(" Message                  : {0}", exp);
            System.Net.IPHostEntry ip = Dns.GetHostEntry(System.Net.Dns.GetHostName());
            IPAddress[] addr = ip.AddressList;
            sw.WriteLine(" Message On Machine       : {0}", System.Net.Dns.GetHostName());
            sw.WriteLine(" Machine IP Address       : {0}", addr.GetValue(0).ToString());
            sw.Close();


        }
        else
        {
            fs = File.Create("GeneralLog.txt");
            sw = new StreamWriter(fs);
            sw.WriteLine("  **********************************************  ");
            sw.WriteLine(" Date Time                : {0}", System.DateTime.Now.ToString());
            sw.WriteLine(" Message                  : {0}", exp);
            System.Net.IPHostEntry ip = Dns.GetHostEntry(System.Net.Dns.GetHostName());
            IPAddress[] addr = ip.AddressList;
            sw.WriteLine(" Message On Machine       : {0}", System.Net.Dns.GetHostName());
            sw.WriteLine(" Machine IP Address       : {0}", addr.GetValue(0).ToString());
            sw.Close();
            fs.Close();

        }
    }

    public void errLog(Exception Ex)
    {
  

        FileStream fs;
        StreamWriter sw;
        string str = AppDomain.CurrentDomain.BaseDirectory + "ErrorLog\\" + System.DateTime.Now.ToString("dd-MMM-yyyy") + "\\";
        if (System.IO.File.Exists(str + "ErrorLog.txt"))
        {
            sw = File.AppendText(str + "ErrorLog.txt");
            sw.WriteLine("\n");
            sw.WriteLine("  **********************************************************  ");
            sw.WriteLine(" Page Name                : {0}", HttpContext.Current.Request.Url.AbsolutePath);
          
            sw.WriteLine(" Time Of Error            : {0}", System.DateTime.Now.ToString());
            sw.WriteLine(" Error Message            : {0}", Ex.Message);
            sw.WriteLine(" Error Place              : {0}", Ex.StackTrace.ToString());
            System.Net.IPHostEntry ip = Dns.GetHostEntry(System.Net.Dns.GetHostName());
            IPAddress[] addr = ip.AddressList;
            sw.WriteLine(" Error On Machine         : {0}", System.Net.Dns.GetHostName());
            sw.WriteLine(" Error Machine IP Address : {0}", addr.GetValue(0).ToString());
            sw.WriteLine(" Exception Type           : {0}", Ex.GetType().ToString());
            sw.WriteLine(" TargetSite               : {0}", Ex.TargetSite);
            if (Ex.InnerException != null)
            {
                sw.WriteLine(" Inner Exception Type     : {0}", Ex.InnerException.GetType().ToString());
                sw.WriteLine(" Inner Exception          : {0}", Ex.InnerException.Message);
                sw.WriteLine(" Inner Source             : {0}", Ex.InnerException.Source);
                if (Ex.InnerException.InnerException != null)
                {
                    sw.WriteLine(" Inner Inner Exception    : {0}", Ex.InnerException.InnerException.Message);
                    sw.WriteLine(" Inner Inner Source       : {0}", Ex.InnerException.InnerException.Source);
                }
                if (Ex.InnerException.StackTrace != null)
                {
                    sw.WriteLine(" Inner Stack Trace        : {0}", Ex.InnerException.StackTrace);
                }

            }

            sw.Close();

        }
        else
        {

            System.IO.Directory.CreateDirectory(str);
            fs = File.Create(str + "ErrorLog.txt");
            sw = new StreamWriter(fs);
            sw.WriteLine("  **********************************************************  ");
            sw.WriteLine(" Page Name                : {0}", HttpContext.Current.Request.Url.AbsolutePath);
            
            sw.WriteLine(" Time Of Error            : {0}", System.DateTime.Now.ToString());
            sw.WriteLine(" Error Message            : {0}", Ex.Message);
            sw.WriteLine(" Error Place              : {0}", Ex.StackTrace.ToString());
            System.Net.IPHostEntry ip = Dns.GetHostEntry(System.Net.Dns.GetHostName());
            IPAddress[] addr = ip.AddressList;
            sw.WriteLine(" Error On Machine         : {0}", System.Net.Dns.GetHostName());
            sw.WriteLine(" Error Machine IP Address : {0}", addr.GetValue(0).ToString());
            sw.WriteLine(" Exception Type               : {0}", Ex.GetType().ToString());
            sw.WriteLine(" TargetSite               : {0}", Ex.TargetSite);
            if (Ex.InnerException != null)
            {
                sw.WriteLine(" Inner Exception Type     : {0}", Ex.InnerException.GetType().ToString());
                sw.WriteLine(" Inner Exception          : {0}", Ex.InnerException.Message);
                sw.WriteLine(" Inner Source             : {0}", Ex.InnerException.Source);
                if (Ex.InnerException.InnerException != null)
                {
                    sw.WriteLine(" Inner Inner Exception    : {0}", Ex.InnerException.InnerException.Message);
                    sw.WriteLine(" Inner Inner Source       : {0}", Ex.InnerException.InnerException.Source);
                }
                if (Ex.InnerException.StackTrace != null)
                {
                    sw.WriteLine(" Inner Stack Trace        : {0}", Ex.InnerException.StackTrace);
                }

            }
            sw.Close();
            fs.Close();
        }

    }
}
