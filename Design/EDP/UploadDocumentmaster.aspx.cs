using System;
using System.Data;
using System.Web;
using System.Web.Services;

public partial class Design_EDP_UploadDocumentmaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod(EnableSession = true)]
    public static string bindDocumentName(string Type)
    {
        DataTable dt;
        if (Type == "OPD")
        {
            dt = StockReports.GetDataTable("SELECT FormID as ID,FormNAME as NAME,IsActive,IF(isactive=0,'False','True')STATUS FROM research_master where IsResearch=0 ");
        }
        else
        {
            dt = StockReports.GetDataTable("SELECT ID,NAME,IsActive,IF(isactive=0,'False','True')STATUS FROM ot_document_master");
        }
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string SaveDocumentMaster(string DocumentName, string Status, string Type)
    {
        if (Type == "OPD")
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(FormName) from research_master where FormName='" + DocumentName + "'"));
            if (count == 0)
            {
                bool row = StockReports.ExecuteDML("insert into research_master(FormName,IsActive,UserID,IsResearch) values('" + DocumentName + "','" + Status + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + 0 + "')");
                if (row == true)
                {
                    string Name = StockReports.ExecuteScalar("Select FormID from research_master where FormName='" + DocumentName + "'");
                    bool map = StockReports.ExecuteDML("insert into research_master_detail(FormID,Name,IsActive) values('" + Name + "','" + DocumentName + "','" + Status + "')");
                    LoadCacheQuery.DropCentreWiseCache();//
                    return "1";
                }
                else
                    return "";
            }
            else
                return "2";
        }
        else
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(Name) from ot_document_master where Name='" + DocumentName + "'"));
            if (count == 0)
            {
                bool row = StockReports.ExecuteDML("insert into ot_document_master(NAME,IsActive,EnterBy) values('" + DocumentName + "','" + Status + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
                LoadCacheQuery.DropCentreWiseCache();//
                if (row == true)
                    return "1";
                else
                    return "";
            }
            else
                return "2";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateDocumentMaster(string DocumentName, string ID, string Status, string Type)
    {
        if (Type == "OPD")
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from research_master where FormID !='" + ID + "' And FormName='" + DocumentName + "'"));
            if (count == 0)
            {
                bool row = StockReports.ExecuteDML(" Update research_master rm inner join research_master_detail rmd ON rmd.FormID=rm.FormID  set rm.FormName='" + DocumentName + "',rm.IsActive='" + Status + "',rmd.Name='" + DocumentName + "' Where rm.FormID='" + ID + "' ");
                LoadCacheQuery.DropCentreWiseCache();//
                if (row == true)
                    return "1";
                else
                    return "";
            }
            else
                return "2";
        }
        else
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from ot_document_master where ID !='" + ID + "' And Name='" + DocumentName + "'"));
            if (count == 0)
            {
                bool row = StockReports.ExecuteDML(" Update ot_document_master set Name='" + DocumentName + "',IsActive='" + Status + "' Where ID='" + ID + "' ");
                LoadCacheQuery.DropCentreWiseCache();//
                if (row == true)
                    return "1";
                else
                    return "";
            }
            else
                return "2";
        }
    }
}