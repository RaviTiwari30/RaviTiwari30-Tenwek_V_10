<%@ WebService Language="C#" Class="Diet" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.ComponentModel.ToolboxItem(false)]
 [System.Web.Script.Services.ScriptService]
public class Diet  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    [WebMethod]
    public string getDietSpecification(string DietTypeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select dsm.SubDietID,dsm.Name FROM diet_subdiettype_master dsm inner join diet_Map_Type_SubType dmts ON dsm.SubDietID=dmts.SubDietID AND  dmts.DietID='" + DietTypeID + "'  where  dsm.IsActive=1 order by dsm.name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public string bindMenu1()
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT DietMenuID,NAME,IsDefault FROM diet_Menu_master WHERE IsActive='1' ");

        DataTable dtData = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
    }

    
    [WebMethod]
    public string bindSubDietType1(string DietType)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT dsm.SubDietID,dsm.NAME,(SELECT SubDietID FROM diet_Map_Type_SubType WHERE IsDefault='1' AND Dtype='P')SubDietIDDefaultP,(SELECT SubDietID FROM diet_Map_Type_SubType WHERE IsDefault='1' AND Dtype='N')SubDietIDDefaultN FROM diet_subdiettype_master dsm ");
        sb.Append(" INNER JOIN diet_Map_Type_SubType dmts ON dmts.SubDietID = dsm.SubDietID WHERE dsm.IsActive='1' ");
        if (DietType != "" && DietType != "0")
        {
            sb.Append(" AND dmts.DietID= '" + DietType + "' ");
        }

        DataTable dtData = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
    }

    
    [WebMethod]
    public string bindDietType1(string IsPrivate)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT DietID,NAME,(SELECT DietID FROM diet_Map_Type_SubType WHERE IsDefault='1' AND Dtype='P')DietIDDefaultP,(SELECT DietID FROM diet_Map_Type_SubType WHERE IsDefault='1' AND Dtype='N')DietIDDefaultN FROM diet_DietType_master WHERE Isactive='1' ");
        if (IsPrivate == "0" || IsPrivate == "1")
        {
            sb.Append("AND  IsPanelApproved='" + IsPrivate + "'");
        }
        DataTable dtData = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtData);
    }

    
    [WebMethod]
    public string bindDietType(string dietTiming)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ddm.DietID,ddm.Name As DietName,dsm.SubdietID,dsm.Name as SubDietName,ddm.IsPanelApproved,ddm.IsDefault FROM diet_map_diet_component dmdc");
        sb.Append(" INNER JOIN diet_diettype_master ddm ON ddm.DietID=dmdc.DietID ");
        sb.Append(" INNER JOIN diet_Subdiettype_master dsm ON dsm.SubDietID=dmdc.SubDietID ");
        sb.Append(" INNER JOIN diet_timing dt ON dt.ID=dmdc.DietTimeID WHERE dt.ID='" + dietTiming + "'  GROUP BY ddm.DietID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public string bindSubDietType(string dietTiming, string DietID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT dsm.SubDietID,dsm.Name AS SubDietName,'1' IsDefault FROM diet_map_diet_component dmdc ");
        sb.Append("INNER JOIN diet_diettype_master ddm ON ddm.DietID=dmdc.DietID ");
        sb.Append(" INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID = dmdc.SubDietID ");
        sb.Append(" INNER JOIN diet_timing dt ON dt.ID = dmdc.DietTimeID ");
        sb.Append("  WHERE dt.ID = '" + dietTiming + "' AND ddm.DietID='" + DietID + "' GROUP BY dsm.SubDietID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    public string bindMenu(string dietTiming, string dietID, string subDietID, string date)
    {
        string days = Util.GetDateTime(date).ToString("ddd");
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT dmm.DietMenuID,dmm.Name,dmm.IsDefault FROM diet_map_diet_component dmdc INNER JOIN diet_menu_master dmm ON dmm.DietMenuID=dmdc.DietMenuID ");
        sb.Append(" WHERE dmdc.SubDietID='" + subDietID + "' AND dmdc.DietID='" + dietID + "' ");
        sb.Append(" AND dmdc.DietTimeID='" + dietTiming + "' AND dmm.days LIKE '%" + days + "%' GROUP BY dmm.DietMenuID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public string bindComponent(string dietTiming, string dietMenuID, string subDietID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT dmdc.ComponentName,dmdc.ComponentID FROM diet_map_diet_component dmdc ");
        sb.Append("  INNER JOIN diet_menu_master dmm ON dmm.DietMenuID=dmdc.DietMenuID INNER JOIN diet_subdiettype_master dsm ON dsm.SubDietID=dmdc.SubDietID ");
        sb.Append("  INNER JOIN diet_timing dt ON dt.ID=dmdc.DietTimeID INNER JOIN diet_component_master dcm ON dcm.ComponentID=dmdc.ComponentID ");
        sb.Append("  WHERE dmdc.DietMenuID='" + dietMenuID + "'  AND dmdc.SubDietID='" + subDietID + "'  AND dmdc.DietTimeID='" + dietTiming + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public string getPatientComDetail(string dietTimeID, string subDietID, string menuID, string TID,string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IFNULL(dpd.ID,0)PatComDetail,dmdc.ComponentName,IFNULL(dpd.Rate,0)Rate,IFNULL(dpd.RateListID,0)RateListID,dcm.ItemID,dcm.ComponentID,dpd.Quantity Qty,dcm.Type,IFNULL(dcm.Unit,'')Unit,IFNULL(dcm.Calories,'')Calories,IFNULL(dcm.Protein,'')Protein,IFNULL(dcm.Sodium,'')Sodium,IFNULL(dcm.SaturatedFat,'')SaturatedFat, ");
        sb.Append(" IFNULL(dcm.T_Fat,'')T_Fat,IFNULL(Calcium,'')Calcium,IFNULL(Iron,'')Iron,IFNULL(zinc,'')zinc ");
        sb.Append("  FROM diet_map_diet_component dmdc ");
        sb.Append(" INNER JOIN diet_component_master dcm ON dcm.ComponentID=dmdc.ComponentID ");
        sb.Append(" INNER JOIN diet_patient_Component_Detail dpd ON dpd.ComponentID=dcm.ComponentID AND dpd.TransactionID='" + TID + "' AND dpd.IsActive=1 ");
        sb.Append(" WHERE dmdc.DietMenuID='" + menuID + "' AND dmdc.SubDietID='" + subDietID + "' AND dmdc.DietTimeID='" + dietTimeID + "' AND  DATE(dpd.CreatedDate)='"+ Util.GetDateTime(ToDate).ToString("yyyy-MM-dd")+"' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
}