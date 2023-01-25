<%@ WebService Language="C#" Class="StoreItems" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;


/// <summary>
/// Summary description for SetItems
/// </summary>
[WebService(Namespace = "http://www.itdoseinfo.com/CSSD/Items1")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class StoreItems : System.Web.Services.WebService
{

    public StoreItems()
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }
    

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindItems(string ItemName)
    {
        //ItemName = "VP  HP SHUNT HIGH";
        Items st = new Items();
        DataTable dt = st.LoadItems(ItemName);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
    }
     [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string BindSets()
    {
        //ItemName = "VP  HP SHUNT HIGH";
        Items st = new Items();
        DataTable dt = st.LoadSets();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        
    }

}