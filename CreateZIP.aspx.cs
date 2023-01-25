using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ICSharpCode.SharpZipLib.Zip;
using System.Diagnostics;
using System.IO;
using System.Threading;
public partial class Design_EDP_CreateZIP : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
try	
{
        string MySqlPath = @"C:\ApolloUAT\offline_mac_data\";
        string txtTempPath = @"C:\ApolloUAT\offline_mac_data\";
        string maxid = Util.GetString(Request.QueryString["maxid"]);
        string centreid = Util.GetString(Request.QueryString["centreid"]);
        if (centreid.Trim() == "")
            return;

        //creating backup file
        Process p = new Process();
        //string ConStr = "server=" + txtSourceIP.Text + ";user id=" + txtSourceUsername.Text + "; password=" + txtSourcePwd.Text + ";database=" + txtSourceDB.Text + "; pooling=false;Respect Binary Flags=false;";
        p.StartInfo.FileName = MySqlPath + "mysqldump.exe";
            //<add key="ConnectionString" value="server=172.16.200.44;user id=ess;password=ebizframe@mscl42!0;port=4210;pooling=false;database=mscl; Respect Binary Flags=false; " />
            p.StartInfo.Arguments = String.Format("-h 172.16.200.44 -u ess -pebizframe@mscl42!0 -P 4210 mscl --tables mac_Data --where=\"id>{0} AND centreid={1} AND STATUS IN('Receive','Delete') AND `Reading`=''\" --result-file \"C:\\ApolloUAT\\offline_mac_data\\{1}.sql\"",

            maxid,
            centreid
            );



       p.StartInfo.UseShellExecute = false;
        p.StartInfo.CreateNoWindow =false;
p.StartInfo.RedirectStandardOutput = true;
    p.StartInfo.RedirectStandardError = true;
        p.Start();

//* Read the output (or the error)
    string output = p.StandardOutput.ReadToEnd();
    Response.Write(output);
    string err = p.StandardError.ReadToEnd();
    Response.Write(err);

        p.WaitForExit();
        p.Dispose();

   File.AppendAllText(String.Format("C:\\ApolloUAT\\offline_mac_data\\{0}.sql", centreid), File.ReadAllText("C:\\ApolloUAT\\offline_mac_data\\restore_script.sql"));


//return;
        //create zip
        FastZip obj = new FastZip();
        obj.CreateZip(txtTempPath + "" + centreid + ".zip", txtTempPath, true, centreid + ".sql");

        // delete .sql file
        if (File.Exists(txtTempPath + "" + centreid + ".sql"))
            File.Delete(txtTempPath + "" + centreid + ".sql");

        fileDownload(centreid + ".zip", txtTempPath + "" + centreid + ".zip");

        //// delete .zip file
        //if (File.Exists(txtTempPath + "" + tbName + ".zip"))
        //    File.Delete(txtTempPath + "" + tbName + ".zip");
}
catch(Exception ex)
{

throw(ex);

}

    }



    private void fileDownload(string fileName, string fileUrl)
    {
        Page.Response.Clear();
        bool success = ResponseFile(Page.Request, Page.Response, fileName, fileUrl, 1024000);
        if (!success)
            Response.Write("Downloading Error!");
        Page.Response.End();

    }
    public static bool ResponseFile(HttpRequest _Request, HttpResponse _Response, string _fileName, string _fullPath, long _speed)
    {
        try
        {
            FileStream myFile = new FileStream(_fullPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            BinaryReader br = new BinaryReader(myFile);
            try
            {
                _Response.AddHeader("Accept-Ranges", "bytes");
                _Response.Buffer = false;
                long fileLength = myFile.Length;
                long startBytes = 0;

                int pack = 10240; //10K bytes
                int sleep = (int)Math.Floor((double)(1000 * pack / _speed)) + 1;
                if (_Request.Headers["Range"] != null)
                {
                    _Response.StatusCode = 206;
                    string[] range = _Request.Headers["Range"].Split(new char[] { '=', '-' });
                    startBytes = Convert.ToInt64(range[1]);
                }
                _Response.AddHeader("Content-Length", (fileLength - startBytes).ToString());
                if (startBytes != 0)
                {
                    _Response.AddHeader("Content-Range", string.Format(" bytes {0}-{1}/{2}", startBytes, fileLength - 1, fileLength));
                }
                _Response.AddHeader("Connection", "Keep-Alive");
                _Response.ContentType = "application/octet-stream";
                _Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_fileName, System.Text.Encoding.UTF8));

                br.BaseStream.Seek(startBytes, SeekOrigin.Begin);
                int maxCount = (int)Math.Floor((double)((fileLength - startBytes) / pack)) + 1;

                for (int i = 0; i < maxCount; i++)
                {
                    if (_Response.IsClientConnected)
                    {
                        _Response.BinaryWrite(br.ReadBytes(pack));
                        Thread.Sleep(sleep);
                    }
                    else
                    {
                        i = maxCount;
                    }
                }
            }
            catch
            {
                return false;
            }
            finally
            {
                br.Close();
                myFile.Close();
            }
        }
        catch (Exception ex)
        {
            return false;
        }
        return true;
    }



}