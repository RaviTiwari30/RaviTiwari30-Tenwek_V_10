<%@ WebService Language="C#" Class="SetMaster" %>

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

[WebService(Namespace = "http://www.itdoseinfo.com/Cssd/SetMaster")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class SetMaster
{
    [WebMethod(EnableSession = true)]
    public string saveSet(string SetName, string Description)
    {
        return LaundrySet.SaveSet(SetName, Description);

    }
    [WebMethod(EnableSession = true)]
    public string bindSet()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(LaundrySet.loadLaundarySets());

    }
    [WebMethod(EnableSession = true)]
    public string SaveSetItem(string ItemData)
    {

        return LaundrySet.saveSetDetails(ItemData);

    }

    [WebMethod(EnableSession = true)]
    public string EditSetItemsDetails(string ItemData)
    {
        return LaundrySet.EditSetItemsDetails(ItemData);
    }
    [WebMethod(EnableSession = true)]
    public string LoadSetItems(string SetID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT SetName,SetID,ItemID,ItemName,Quantity FROM Laundry_set_itemdetail WHERE isactive=1 AND SetID='" + SetID + "' "));


    }
}
