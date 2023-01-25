using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.IO;
public partial class Design_Mortuary_CorpseDeposite : System.Web.UI.Page
{

    [WebMethod(EnableSession = true, Description = "Search Corpse")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchCorpse(string CorpseNo, string DepositeNo, string FirstName, string LastName, string FromDate, string ToDate, string Status,string CorpseID)
    {
        StringBuilder Query = new StringBuilder();
        Query.Append("SELECT *,(Select CONCAT(RackName,'-',rack_No,'/ShelfNo:',ShelfNo,'/RoomNo:',Room_No) from mortuary_freezer_master where RackID=CD.FreezerID)Freezer,DATE_FORMAT(InDate,'%d-%M-%Y %r') AS InDate1,DATE_FORMAT(DeathDate,'%d-%M-%Y') AS DeathDate1,TIME_FORMAT(DeathTime, '%h:%i %p') as DeathTime1,(SELECT Name 	FROM 	employee_master  WHERE  EmployeeId=CM.CreatedBy LIMIT 0, 1)AdmittedBy FROM mortuary_corpse_master CM INNER JOIN mortuary_corpse_deposite CD ON cm.`Corpse_ID`=CD.`CorpseID`  ");


        Query.Append(" where Date(DeathDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Date(DeathDate)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");

        if (CorpseID != "")
        {
            Query.Append(" and CorpseID like '%" + CorpseID + "%' ");
        }

        Query.Append("ORDER BY DATE(DeathDate) DESC ");

        DataTable dt = StockReports.GetDataTable(Query.ToString());

        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        return "0";
    }

    [WebMethod(EnableSession = true, Description = "Bind Employee")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string  bindEmployee()
    {

        DataTable dtEmployee = StockReports.GetDataTable("SELECT EmployeeID,NAME FROM `employee_master` WHERE IsActive='1' ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtEmployee);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDateofDeath.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromDate1.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate1.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calDateofDeath.EndDate = DateTime.Now;
            
            if (Request.QueryString["MRNo"] != null)
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key", "$('#txtBarcode').val('" + Request.QueryString["MRNo"].ToString() + "');", true);
        }

        txtDateofDeath.Attributes.Add("readonly", "readonly");
        txtFromDate.Attributes.Add("readonly", "readonly");
        txtToDate.Attributes.Add("readonly", "readonly");
    }
    [WebMethod]
    public static string getReligion()
    {
        DataTable dtReligion = StockReports.GetDataTable("SELECT * FROM patient_Religion");//loadReligion();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtReligion);
    }
    public static DataTable loadReligion()
    {
        DataTable dt = new DataTable();
        string CacheName = "Religion";
        if (HttpContext.Current.Cache[CacheName] != null)
        {
            dt = HttpContext.Current.Cache[CacheName] as DataTable;
        }
        else
        {
            string qstr = "SELECT Religion FROM master_Religion WHERE IsActive=1 ORDER By Religion";
            dt = StockReports.GetDataTable(qstr);

            File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
            File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
            HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CountryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        }
        return dt;
    }

    [WebMethod]
    public static string getLocality()
    {
        DataTable dtLocality = StockReports.GetDataTable("SELECT TalukaID,Taluka FROM Master_Taluka mt WHERE mt.`IsActive`=1  AND mt.`TalukaID`<>1");//loadLocality();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtLocality);
    }
    public static DataTable loadLocality()
    {
        DataTable dt = new DataTable();
        string CacheName = "Locality";
        if (HttpContext.Current.Cache[CacheName] != null)
        {
            dt = HttpContext.Current.Cache[CacheName] as DataTable;
        }
        else
        {
            string qstr = "SELECT Locality FROM master_locality WHERE IsActive=1 ORDER By Locality";
            dt = StockReports.GetDataTable(qstr);

            File.Create(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")).Close();
            File.WriteAllText(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt"), DateTime.Now.ToString());
            HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath("~/CacheDependency/" + CacheName + ".txt")), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CountryCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
        }
        return dt;
    }
}