using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for CardBasicData
/// </summary>
public class CardBasicData
{
      public static string TokenUrl = "http://192.168.10.45:8500/"; //"https://data.smartapplicationsgroup.com/providerapi-dev/oauth/token";
    public static string BaseUrl = "http://192.168.10.45:8500/"; //"https://data.smartapplicationsgroup.com/providerapi-dev/";

    public static string UserName1 = "admin";//"Tenwek";
    public static string Password1 = "Passw0rd#";//"P@55W0rd";

    // Sent in Body 
    public static string grant_type = "password";
    public static string UserName2 = "icare"; //"SKSP_1067";
    public static string Password2 = "Passw0rd#"; //"P@55W0rd";

    //
}