using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Result : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

       //
        string content = (new StreamReader(Request.InputStream)).ReadToEnd();
        string json = "";
        List<Mac_Observation> Order = JsonConvert.DeserializeObject<List<Mac_Observation>>(content);
        


        if (Order == null)
            return;

        if (Order.Count == 0)
            return;


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        
        string objSQL = "INSERT INTO machost_mscl.mac_observation(`LabNo`,`Machine_Id`,`Machine_ParamID`,`Reading`,`dtEntry`) VALUES (@LabNo,@Machine_Id,@Machine_ParamID,@Reading,@dtEntry)";

        if (Util.GetString(Request.QueryString["cmd"]).ToLower() == "vitek")
            objSQL = "INSERT INTO `machost_mscl`.`mac_observation_vitek`(`LabNo`,`Machine_Id`,`Machine_ParamID`,`Reading`,`dtEntry`,`isActive`,`PatientName`,`PatientId`,`dtRun`,`isSync`,`GroupId`,`UpdateReason`,`UpdateBy`,`Type`,`ParamName`,`Interpretation`,`ObservationName`) " +
                "values (@LabNo,@Machine_Id,@Machine_ParamID,@Reading,@dtEntry,@isActive,@PatientName,@PatientId,@dtRun,@isSync,@GroupId,@UpdateReason,@UpdateBy,@Type,@ParamName,@Interpretation,@ObservationName); ";
        
        MySqlCommand cmd = new MySqlCommand(objSQL, con,tnx);
        cmd.CommandType = CommandType.Text;

        try
        {


            foreach (Mac_Observation item in Order)
            {
                cmd.Parameters.Add(new MySqlParameter("@LabNo", item.LabNo));
                cmd.Parameters.Add(new MySqlParameter("@Machine_Id", item.Machine_Id));
                cmd.Parameters.Add(new MySqlParameter("@Machine_ParamID", item.Machine_ParamID));
                cmd.Parameters.Add(new MySqlParameter("@Reading", item.Reading));
                cmd.Parameters.Add(new MySqlParameter("@dtEntry", item.dtEntry));
                cmd.Parameters.Add(new MySqlParameter("@isActive", item.isActive));
                cmd.Parameters.Add(new MySqlParameter("@PatientName", item.PatientName));
                cmd.Parameters.Add(new MySqlParameter("@PatientId", item.PatientId));
                cmd.Parameters.Add(new MySqlParameter("@dtRun", item.dtRun));
                cmd.Parameters.Add(new MySqlParameter("@isSync", item.isSync));
                cmd.Parameters.Add(new MySqlParameter("@GroupId", item.GroupId));
                cmd.Parameters.Add(new MySqlParameter("@UpdateReason", item.UpdateReason));
                cmd.Parameters.Add(new MySqlParameter("@UpdateBy", item.UpdateBy));
                cmd.Parameters.Add(new MySqlParameter("@Type", item.Type));
                cmd.Parameters.Add(new MySqlParameter("@ParamName", item.ParamName));
                cmd.Parameters.Add(new MySqlParameter("@Interpretation", item.Interpretation));
                cmd.Parameters.Add(new MySqlParameter("@ObservationName", item.ObservationName));

        

                cmd.ExecuteNonQuery();
                cmd.Parameters.Clear();
            }



            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            json = "success";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            json = ex.ToString();
        }




        //Response.Write("deepak");
        //Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject("deepak"));
        
        Response.Clear();
        Response.ContentType = "application/json; charset=utf-8";
        Response.Write(json);
        Response.End();
    }


    string getHMACSHA1(string message, string key)
    {

        System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
        byte[] keyByte = encoding.GetBytes(key);

        HMACMD5 hmacmd5 = new HMACMD5(keyByte);
        HMACSHA1 hmacsha1 = new HMACSHA1(keyByte);

        byte[] messageBytes = encoding.GetBytes(message);
        //byte[] hashmessage = hmacmd5.ComputeHash(messageBytes);
        //this.hmac1.Text = ByteToString(hashmessage);

        byte[] hashmessage = hmacsha1.ComputeHash(messageBytes);
        return ByteToString(hashmessage);



    }

    public static string ByteToString(byte[] buff)
    {
        string sbinary = "";

        for (int i = 0; i < buff.Length; i++)
        {
            sbinary += buff[i].ToString("X2"); // hex format
        }
        return (sbinary);
    }
}