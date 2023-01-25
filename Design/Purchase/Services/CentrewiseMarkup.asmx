<%@ WebService Language="C#" Class="CentrewiseMarkup" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft.Json;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Text.RegularExpressions;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CentrewiseMarkup : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    
    [WebMethod]
    public string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string SearchMarkupDetails(int centreID,string categoryID,string subcategoryID)
    {
        string SQL = "SELECT ID,FromRate,ToRate,MarkUpPercentage FROM f_centrewise_markup WHERE IsActive=1 AND CentreID=" + Util.GetInt(centreID) + " AND CategoryID='" + Util.GetString(categoryID) + "' AND SubCategoryID='" + Util.GetString(subcategoryID) + "' AND IFNULL(ItemID,'')='' ";
        DataTable dt = StockReports.GetDataTable(SQL);
        if (dt.Rows.Count == 0 || dt== null)
        {
            DataRow dr = dt.NewRow();

            dr["FromRate"] = Util.GetDecimal("0");
            dr["ToRate"] = Util.GetDecimal("1");
            dr["MarkUpPercentage"] = Util.GetDecimal("0");
            dr["ID"] = Util.GetInt("0");
            
            dt.Rows.Add(dr);
            dt.AcceptChanges();
        }
        
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod(EnableSession = true)]
    public string saveMarkup(System.Collections.Generic.List<CentrewiseMarup> MarkUpList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            for (int i = 0; i < MarkUpList.Count; i++)
            {
                var item = MarkUpList[i];
                item.EntryBy = HttpContext.Current.Session["ID"].ToString();

                if(i==0)
                excuteCMD.DML(tnx, "UPDATE f_centrewise_markup SET IsActive=0,UpdatedBy=@EntryBy,UpdatedDateTime=now() WHERE IsActive=1 AND CentreID=@CentreID AND CategoryID=@CategoryID AND SubCategoryID=@SubCategoryID ", CommandType.Text, item);

                var sqlCmd = new StringBuilder("INSERT INTO f_centrewise_markup(CentreID,CategoryID,SubCategoryID,FromRate,ToRate,MarkUpPercentage,CreatedBy,CreatedDatetme)");
                sqlCmd.Append("VALUES (@CentreID,@CategoryID,@SubCategoryID,@FromRate,@ToRate,@MarkupPer,@EntryBy,now())");
                excuteCMD.DML(tnx, sqlCmd.ToString(), CommandType.Text, item);
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error Occured. Please contact to Administrator", message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class CentrewiseMarup
    {
        public int CentreID { get; set; }
        public string SubCategoryID { get; set; }
        public string CategoryID { get; set; }
        public decimal FromRate { get; set; }
        public decimal ToRate { get; set; }
        public decimal MarkupPer { get; set; }
        public string EntryBy { get; set; }
   
    }
}