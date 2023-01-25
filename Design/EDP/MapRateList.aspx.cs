using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;

public partial class Design_EDP_MapRateList : System.Web.UI.Page
{
    public static string UserId;


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPanel();
            LoadScheduleCharges();

        }
        UserId = Session["ID"].ToString();

    }
    protected void ddlPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadScheduleCharges();
    }
    private void LoadPanel()
    {
        DataTable dt = CreateStockMaster.LoadPanelCompanyRefOPD();
        ddlPanel.DataSource = dt;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();
    }

    private void LoadScheduleCharges()
    {
        DataTable dtCharges = StockReports.GetDataTable("SELECT NAME,ScheduleChargeID FROM f_rate_schedulecharges WHERE panelID=" + ddlPanel.SelectedValue + " ");
        ddlScheduleCharges.DataSource = dtCharges;
        ddlScheduleCharges.DataTextField = "NAME";
        ddlScheduleCharges.DataValueField = "ScheduleChargeID";
        ddlScheduleCharges.DataBind();

    }
    [WebMethod]
    public static string ShowRecord(string Id, string Type, string Panel)
    {

        StringBuilder sb = new StringBuilder();
        if (Type != "Surgery")
            sb.Append("SELECT temp.*,IFNULL(im.TypeName,'') AS MappedItem from tmp_ratelist_upload_" + Panel + "_" + Type + " temp LEFT JOIN f_itemmaster im ON temp.itemid=im.ItemID  WHERE temp.PanelID=" + Id + " and temp.is_Mapped='0'");
        else
            sb.Append("SELECT temp.*,IFNULL(im.Name,'') AS MappedItem from tmp_ratelist_upload_" + Panel + "_" + Type + " temp LEFT JOIN f_surgery_master im ON temp.itemid=im.Surgery_ID  WHERE temp.PanelID=" + Id + " and temp.is_Mapped='0'");
        DataTable bank = StockReports.GetDataTable(sb.ToString());
        if (bank.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(bank);
        else
            return "";
    }
    [WebMethod]
    public static List<object> ShowMappingValue(string ItemName,string Type)
    {
        List<object> Emp = new List<object>();
      DataTable dt;
      if (Type == "Surgery")
        {
            dt = StockReports.GetDataTable("SELECT Surgery_ID AS ItemID,CONCAT(NAME,'(',Department,')') AS ItemName FROM f_surgery_master WHERE `IsActive`=1 AND NAME LIKE '%" + ItemName + "%' ORDER BY NAME");
            
        }
      else if (Type == "Invst") {
          dt = StockReports.GetDataTable("SELECT im.`ItemID`,CONCAT(im.`TypeName`,'(',sb.Name,')') AS ItemName FROM f_itemmaster im INNER JOIN f_subcategorymaster sb ON im.`SubCategoryID`=sb.`SubCategoryID` INNER JOIN f_configrelation cf ON cf.`CategoryID`=sb.`CategoryID` WHERE cf.`ConfigID`='3' AND im.`IsActive`=1 AND im.`TypeName` LIKE '%" + ItemName + "%' ORDER BY im.`TypeName`");
      }
      else if (Type == "Packages") {
          dt = StockReports.GetDataTable("SELECT im.`ItemID`,CONCAT(im.`TypeName`,'(',sb.Name,')') AS ItemName FROM f_itemmaster im INNER JOIN f_subcategorymaster sb ON im.`SubCategoryID`=sb.`SubCategoryID` INNER JOIN f_configrelation cf ON cf.`CategoryID`=sb.`CategoryID` WHERE cf.`ConfigID`='14' AND im.`IsActive`=1 AND im.`TypeName` LIKE '%" + ItemName + "%' ORDER BY im.`TypeName`");
      }
      else
      {
          dt = StockReports.GetDataTable("SELECT im.`ItemID`,CONCAT(im.`TypeName`,'(',sb.Name,')') AS ItemName FROM f_itemmaster im INNER JOIN f_subcategorymaster sb ON im.`SubCategoryID`=sb.`SubCategoryID` INNER JOIN f_configrelation cf ON cf.`CategoryID`=sb.`CategoryID` WHERE cf.`ConfigID` IN ('2','6','25','20','29','27','23') AND im.`IsActive`=1 AND im.`TypeName` LIKE '%" + ItemName + "%' ORDER BY im.`TypeName`");
      }

        foreach (DataRow row in dt.Rows)
        {
            Emp.Add(new
            {
                itemName = row["ItemName"].ToString(),
                itemID = row["ItemID"].ToString()
            });
        }
        return Emp;
        



    }
    [WebMethod]
    public static string FunctionForSaveValue(string ItemId, string Id, string ScheduleChargesValue, string Type, string Panel)
    {
        MySqlConnection con1 = Util.GetMySqlCon();
        con1.Open();
        MySqlTransaction Tnx = con1.BeginTransaction(IsolationLevel.Serializable);
        var Query = "";
        string status = string.Empty;
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT * from tmp_ratelist_upload_"+Panel+"_" + Type + "  WHERE itemid='" + ItemId + "'");

            DataTable bank = StockReports.GetDataTable(sb.ToString());
            if (bank.Rows.Count > 0)
            {
                status = "NotSelected";
            }
            else
            {
                Query = "update  tmp_ratelist_upload_" + Panel + "_" + Type + "  set itemid='" + ItemId + "', ScheduleChargeID=" + ScheduleChargesValue + " where Id=" + Id + "";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Query.ToString());
                status = "Success";
            }
            Tnx.Commit();

        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            status = "";
        }
        finally
        {
            Tnx.Dispose();
            con1.Close();
            con1.Dispose();
        }
        return status;
    }

    [WebMethod]
    public static string functionForUpdateDetail(string Type, string Panel)
    {
        MySqlConnection con1 = Util.GetMySqlCon();
        con1.Open();
        MySqlTransaction Tnx = con1.BeginTransaction(IsolationLevel.Serializable);
        string status = string.Empty;
        int IsOPD = 0;
        int IsIPD = 0;
        try
        {
            DataTable bank = StockReports.GetDataTable("SELECT * FROM tmp_ratelist_upload_" + Panel + "_" + Type + " WHERE is_Mapped='0' AND itemid<>''");
            for (int i = 0; i < bank.Rows.Count; i++)
            {
                foreach (DataColumn drIPD in bank.Columns)
                {


                    string Id = bank.Rows[i]["Id"].ToString();
                    string ITEMNAME = bank.Rows[i]["ITEMNAME"].ToString();
                    string ITEMCODE = bank.Rows[i]["ITEMCODE"].ToString();
                   

                    string PanelID = bank.Rows[i]["PanelID"].ToString();
                    string itemid = bank.Rows[i]["itemid"].ToString();
                    string ScheduleChargeID = bank.Rows[i]["ScheduleChargeID"].ToString();


                    if (Type != "Surgery")
                    {
                        if (drIPD.ColumnName == "OPD")
                        {
                            IsOPD = 1;
                           string getRate = bank.Rows[i]["OPD"].ToString();
                           string UpdateQuery = "update  f_ratelist  set IsCurrent='0',LastUpdatedBy='" + HttpContext.Current.Session["Id"] + "',Updatedate='"+Util.GetDateTime(DateTime.Now.ToString()).ToString("yyyy-MM-dd")+"' where ItemID='" + itemid + "' and PanelID=" + PanelID + " and ScheduleChargeID='" + ScheduleChargeID + "' and IsCurrent='1'";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, UpdateQuery);

                            string Query = "insert into f_ratelist(Location,HospCode,Rate,IsCurrent,ItemDisplayName,ItemCode,ItemID,PanelID,ScheduleChargeID,UserID) values('L','SHHI','" + getRate + "',1,'" + ITEMNAME + "','" + ITEMCODE + "','" + itemid + "'," + PanelID + ",'" + ScheduleChargeID + "','" + UserId + "')";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Query);
                        }
                        string IPDCaseType_ID = StockReports.ExecuteScalar("Select IPDCaseType_ID from IPD_Case_Type_Master where IsActive=1 and UCASE(Trim(Abbreviation))='" + drIPD.ColumnName.Trim().ToUpper() + "'");
                        if (IPDCaseType_ID != "")
                        {
                            IsIPD=1;
                            string getRate = StockReports.ExecuteScalar("select " + drIPD.ColumnName + " from tmp_ratelist_upload_" + Panel + "_" + Type + " where Id='" + Id + "'");

                            string UpdateQuery = "update f_ratelist_ipd  set IsCurrent='0', LastUpdatedBy='" + HttpContext.Current.Session["Id"] + "',Updatedate='" + Util.GetDateTime(DateTime.Now.ToString()).ToString("yyyy-MM-dd") + "' where ItemID='" + itemid + "' and PanelID=" + PanelID + " and ScheduleChargeID='" + ScheduleChargeID + "' and IsCurrent='1' and IPDCaseType_ID='" + IPDCaseType_ID + "'";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, UpdateQuery);

                            string Query = "insert into f_ratelist_ipd(Location,HospCode,Rate,IsCurrent,ItemDisplayName,ItemCode,ItemID,PanelID,ScheduleChargeID,UserID,IPDCaseType_ID) values('L','SHHI','" + getRate + "',1,'" + ITEMNAME + "','" + ITEMCODE + "','" + itemid + "'," + PanelID + ",'" + ScheduleChargeID + "','" + UserId + "','" + IPDCaseType_ID + "')";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Query);
                        }
                    }
                    else
                    {
                        string IPDCaseType_ID = StockReports.ExecuteScalar("Select IPDCaseType_ID from IPD_Case_Type_Master where IsActive=1 and UCASE(Trim(Abbreviation))='" + drIPD.ColumnName.Trim().ToUpper() + "'");
                        if (IPDCaseType_ID != "")
                        {

                            string getRate = StockReports.ExecuteScalar("select " + drIPD.ColumnName + " from tmp_ratelist_upload_" + Panel + "_" + Type + " where Id='" + Id + "'");

                            string UpdateQuery = "delete from f_surgery_rate_list where Surgery_ID='" + itemid + "' and PanelID=" + PanelID + " and ScheduleChargeID='" + ScheduleChargeID + "' and IsCurrent='1' and IPDCaseType_ID='" + IPDCaseType_ID + "'";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, UpdateQuery);

                            string Query = "insert into f_surgery_rate_list(Surgery_ID,PanelID,IPDCaseType_ID,Rate,PanelCode,IsCurrent,UserId,ScheduleChargeID,PanelDisplayName) values('" + itemid + "'," + PanelID + ",'" + IPDCaseType_ID + "','" + getRate + "','" + ITEMCODE + "','1','" + UserId + "','" + ScheduleChargeID + "','" + ITEMNAME + "')";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Query);

                        }
                    }
                }
               
                string Ids = bank.Rows[i]["Id"].ToString();

                if (IsOPD == 1)
                {
                    string IPDquery = "update f_ratelist set RatelistID = concat(location,hospcode,id) where RatelistID is null or RatelistID=''";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, IPDquery);
                    string idMasterQuery = "UPDATE id_master SET maxId=(SELECT MAX(id) FROM f_ratelist) WHERE groupname='f_ratelist'";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, idMasterQuery);

                }
                if (IsIPD == 1) {
                    string IPDquery = "update f_ratelist_ipd set RatelistID = concat(location,hospcode,id) where RatelistID is null or RatelistID=''";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, IPDquery);
                    string UpdateIdMasterQuery = "UPDATE id_master SET maxId=(SELECT MAX(id) FROM f_ratelist_ipd) WHERE groupname='f_ratelist_ipd'";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, UpdateIdMasterQuery);
                }

                var Querys = "update tmp_ratelist_upload_" + Panel + "_" + Type + "  set is_Mapped='1' where Id=" + Ids + " ";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Querys);
                status = "Success";
            }

            Tnx.Commit();
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            status = "";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tnx.Dispose();
            con1.Close();
            con1.Dispose();
        }
        return status;
    }


}