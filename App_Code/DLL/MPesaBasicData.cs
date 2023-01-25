using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for MPesaBasicData
/// </summary>
public class MPesaBasicData
{
    public static string TokenUrl = "oauth/v1/generate";
	public static string BaseUrl = "https://api.safaricom.co.ke"; //"https://sandbox.safaricom.co.ke/";
    public static string ConsumerKey = "yQQUCAf9htLLTpAK28oZ4d9niyM3uteA"; //"F6JZ3GwbCYGAieWeAKqNQN8euGuYDBNW";
    public static string SecrateKey = "AOavkYV1Qml85iYs";//"ABlGIqqc6Xqj8WUk";
    public static string Grant_Type = "client_credentials";
    public static string PayementProcessRequUrl = "/mpesa/stkpush/v1/processrequest";
    public static string CallBackUrl = "https://interface.tenwekhosp.org/Tenwek/Design/OPD/MPesaCallback.aspx";
    public static string BusinessShortCode = "605664";//"174379"; //"605664";
      public static string PassKey ="143babcfbac6032db763697e63ec604da5a81faac4c25789d23f8d0d724a7742";// "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919";
     
    public static string DbConnection = "server=localhost;user id=root;password=123456;port=3306;pooling=false;database=tenwek_150222; Respect Binary Flags=false;";


}