using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_EDP_SurgeryGrouping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindPanel();
        }
    }

    private void bindPanel()
    {
        ddlPanel.DataSource = CreateStockMaster.LoadPanelCompanyRef();
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();
        ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByText(AllGlobalFunction.Panel.ToString()));

    }
        [WebMethod]
    public static string searchSurgeryItem(string groupID,string panelID)
    {
      //  DataTable dt = StockReports.GetDataTable("SELECT IFNULL(sg.ID,'0')ID,im.TypeName,im.Type_ID,im.ItemID,sg.ScaleOfCost,IFNULL(round(sg.Rate/sg.ScaleOfCost,4),'0.00')Rate,IFNULL(sg.Rate,'0.00')FinalRate FROM f_itemmaster im LEFT JOIN f_surgery_group sg ON im.ItemID=sg.ItemID AND sg.IsActive=1 AND sg.GroupID='" + groupID + "' AND sg.PanelID='" + panelID + "' WHERE  im.IsActive=1 AND im.IsSurgery=1  ORDER BY TypeName ");
        DataTable dt = StockReports.GetDataTable("SELECT IFNULL(sg.ID,'0')ID,im.TypeName,im.Type_ID,im.ItemID,IF(im.Type_ID IN (1,2),1,sc.ScaleOfCost)ScaleOfCost,IFNULL(sg.Rate,'0.00')Rate,IFNULL(sg.Rate*IF(im.Type_ID IN (1,2),1,sc.ScaleOfCost),'0.00')FinalRate FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON im.SubCategoryID=sc.SubCategoryID LEFT JOIN f_surgery_group sg ON im.ItemID=sg.ItemID AND sg.IsActive=1 AND sg.GroupID='" + groupID + "' AND sg.PanelID='" + panelID + "' WHERE  im.IsActive=1 AND im.IsSurgery=1  ORDER BY TypeName ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string loadSurgeryItem()
    {
        DataTable dt = StockReports.GetDataTable("select im.ItemID ID,im.TypeName,im.Type_ID,im.ItemID,IF(im.Type_ID IN (1,2),(SELECT IFNULL(sc.ScaleOfCost,0) FROM f_subcategorymaster sc INNER JOIN f_configrelation c ON c.CategoryID=sc.CategoryID WHERE c.ConfigID=22 LIMIT 1),1) ScaleOfCost,'0' Rate,'0' FinalRate from f_itemmaster im Where im.IsActive=1 AND im.IsSurgery=1 order by im.TypeName");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string saveSurgeryGroupName(string GroupName)
    {
        try
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_surgery_groupmaster WHERE GroupName='" + GroupName.Trim() + "'"));
            if (count > 0)
                return "2";
            StockReports.ExecuteDML("INSERT INTO f_surgery_groupmaster(GroupName,CreatedBy)Values('" + GroupName.Trim() + "','" + HttpContext.Current.Session["ID"].ToString() + "')");
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string saveSurgeryGrouping(object Data, string saveType, string PanelID)
    {
        List<surgery_grouping> dataItem = new JavaScriptSerializer().ConvertToType<List<surgery_grouping>>(Data);
        int len = dataItem.Count;

        if (len > 0)
        {
            if (saveType == "Save")
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_surgery_group WHERE GroupID='" + dataItem[0].GroupID + "' and PanelID='" + PanelID + "'"));
                if (count > 0)
                    return "2";
            }

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                if (saveType == "Update")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_surgery_group SET IsActive=0 WHERE GroupID='" + dataItem[0].GroupID + "' and PanelID='" + PanelID + "'");

                }


                decimal totalRate = 0;
                surgery_grouping sg = new surgery_grouping(tnx);
                for (int i = 0; i < dataItem.Count; i++)
                {

                    sg.ItemID = dataItem[i].ItemID;
                    sg.ItemName = dataItem[i].ItemName;
                    sg.Rate = Util.GetDecimal(dataItem[i].Rate);
                    sg.GroupID = Util.GetInt(dataItem[i].GroupID);
                    sg.GroupName = dataItem[i].GroupName;
                    sg.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                    sg.PanelID = Util.GetInt(PanelID);
                    sg.ScaleOfCost = Util.GetDecimal(dataItem[i].ScaleOfCost);
                    sg.Type_ID = dataItem[i].Type_ID;

                    sg.Insert();

                    totalRate += Util.GetDecimal(dataItem[i].Rate);
                }


                ExcuteCMD excuteCMD = new ExcuteCMD();

                var dt = excuteCMD.GetDataTable("SELECT l.Surgery_ID,l.SurgeryCode FROM f_surgery_master l WHERE l.IsActive=1 AND l.GroupID=@groupID", CommandType.Text, new
                {
                    groupID = Util.GetInt(dataItem[0].GroupID)
                });


                for (int i = 0; i < dt.Rows.Count; i++)
                {

                    var surgeryID = Util.GetString(dt.Rows[i]["Surgery_ID"]);
                    var groupID = Util.GetInt(dataItem[0].GroupID);
                    var itemCode = Util.GetString(dt.Rows[i]["SurgeryCode"]);
                    excuteCMD.DML(tnx, "UPDATE f_surgery_calculator SET IsActive=0 WHERE SurgeryID=@surgeryID AND GroupID=@groupID", CommandType.Text, new
                    {
                        surgeryID = surgeryID,
                        groupID = groupID
                    });



                    DataTable dataTable = excuteCMD.GetDataTable("SELECT ItemID,GroupID,Rate,PanelID FROM f_surgery_group WHERE groupID=@groupID and PanelID=@panelID and IsActive=1", CommandType.Text, new
                    {
                        groupID = groupID,
                        panelID = Util.GetInt(PanelID)
                    });



                    for (int j = 0; j < dataTable.Rows.Count; j++)
                    {
                        Surgery_Calculator objCal = new Surgery_Calculator(tnx);
                        objCal.SurgeryID = surgeryID;
                        objCal.ItemID = dataTable.Rows[j]["ItemID"].ToString();
                        objCal.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                        objCal.GroupID = groupID;
                        objCal.Rate = Util.GetDecimal(dataItem[j].Rate);
                        objCal.PanelID = Util.GetInt(dataTable.Rows[j]["PanelID"].ToString());
                        objCal.Insert().ToString();
                    }


                    int ScheduleChargeID = Util.GetInt(StockReports.ExecuteScalar("SELECT ScheduleChargeID FROM f_rate_schedulecharges WHERE PanelID='" + Util.GetString(PanelID) + "' AND isDefault=1 "));
                    StringBuilder sb = new StringBuilder();
                    sb.Append("update  f_surgery_rate_list  set  isCurrent=0 Where Surgery_ID = '" + surgeryID + "' ");
                    sb.Append("and PanelID = '" + Util.GetString(PanelID) + "' ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                    sb = new StringBuilder();

                  

                    sb.Append("INSERT INTO f_surgery_rate_list(Surgery_ID,Rate,PanelID,IPDCaseTypeID,PanelCode,IsCurrent,DateFrom,UserID,ScheduleChargeID)");
                    sb.Append("Select '" + surgeryID + "'," + Util.GetDecimal(totalRate) + ",");
                    sb.Append("'" + Util.GetString(PanelID) + "',icm.IPDCaseType_ID,'" + itemCode + "',");
                    sb.Append("'1',");
                    sb.Append("'" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + HttpContext.Current.Session["ID"].ToString() + "'," + ScheduleChargeID + " from (Select IPDCaseTypeID from ipd_case_type_master Where IsActive=1) icm ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());






                    //StockReports.GetDataTable("SELECT ItemID,GroupID,Rate,PanelID FROM f_surgery_group WHERE groupID=" + Util.GetInt(GroupID) + " and  AND IsActive=1");





                }

                LoadCacheQuery.DropCentreWiseCache();//
                tnx.Commit();

                return "1";
            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "0";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }


        }
        else
        {
            return "";
        }
    }
}