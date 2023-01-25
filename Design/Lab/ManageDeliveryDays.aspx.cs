using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_ManageDeliveryDays : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindcentre();
            LoadSubCategory();

        }

    }



    private void LoadSubCategory()
    {
        ddlDepartment.DataSource = AllLoadData_OPD.BindLabRadioDepartment(Session["RoleID"].ToString());
        ddlDepartment.DataTextField = "Name";
        ddlDepartment.DataValueField = "ObservationType_ID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem { Text = "All", Value = "0" });

    }
    private void bindcentre()
    {
        string mystr = "SELECT CentreID,CentreName Centre FROM center_master  where isActive='1' order by CentreName";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(mystr);
        ddlCentreAccess.DataSource = dt;
        ddlCentreAccess.DataTextField = "Centre";
        ddlCentreAccess.DataValueField = "CentreID";
        ddlCentreAccess.DataBind();
        //ddlCentreAccess.SelectedIndex = ddlCentreAccess.Items.IndexOf(ddlCentreAccess.Items.FindByValue(UserInfo.Centre.ToString()));
    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetDeliveryDays(string CentreId, string SubCategoryId, string TestName, string TestCode)
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ifnull(id.ID,0) ID,'" + CentreId + "'  CentreId,ifnull(DayType,'')DayType,ifnull(Sun,'0')Sun,ifnull(Mon,'0')Mon,ifnull(Tue,'0')Tue,ifnull(Wed,'0')Wed,ifnull(Thu,'0')Thu,ifnull(Fri,'0')Fri,ifnull(Sat,'0')Sat,ifnull(bookingcutoff,'6:30 pm') bookingcutoff,ifnull(sracutoff,'80:30 am')sracutoff,ifnull(testprocessingday,'0')testprocessingday,ifnull(reportingcutoff,'06:30 pm')reportingcutoff, iom.ObservationType_Id SubCategoryID,im.Investigation_Id  Type_ID,im.Name AS InvName, im.testcode ");
        sb.Append("  ,IFNULL(Sun_Proc, '0') Sun_Proc,  IFNULL(Mon_Proc, '0') Mon_Proc,  IFNULL(Tue_Proc, '0') Tue_Proc,  IFNULL(Wed_Proc, '0') Wed_Proc,  IFNULL(Thu_Proc, '0') Thu_Proc,  IFNULL(Fri_Proc, '0') Fri_Proc,  IFNULL(Sat_Proc, '0') Sat_Proc ");
        sb.Append(" FROM investigation_master im INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID AND it.IsActive=1 ");
        sb.Append(" INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ");
        if (TestName != "")
        {
            sb.Append(" and im.Name like '%" + TestName + "%' ");
        }
        if (TestCode != "")
        {
            sb.Append(" and it.ItemCode like '%" + TestCode + "%' ");
        }
        if (SubCategoryId != "0")
            sb.Append(" AND iom.ObservationType_Id='" + SubCategoryId + "' ");

        sb.Append(" LEFT JOIN ");
        sb.Append(" (SELECT * FROM `investiagtion_delivery` WHERE  `CentreID`='" + CentreId + "' ");
        if (SubCategoryId != "0")
            sb.Append(" AND `SubCategoryID`='" + SubCategoryId + "' ");

        sb.Append(" ) id ");
        // sb.Append(" ON id.Investigation_id=im.`Type_ID` AND id.SubCategoryID=im.`SubCategoryID` where im.isActive=1 order by typename ");
        sb.Append(" ON id.Investigation_id=im.Investigation_Id  where it.isActive=1 GROUP BY im.Investigation_ID   order by typename ");

        dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveInvDeliveryDays(List<InvestigationDeliveryDate> objsavedata)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO investiagtion_delivery (sun,mon,tue,wed,thu,fri,sat,sun_Proc,mon_Proc,tue_Proc,wed_Proc,thu_Proc,fri_Proc,sat_Proc,DayType,CentreID,SubcategoryID,Investigation_ID,bookingcutoff,sracutoff,testprocessingday,reportingcutoff,dtEntry,UserID,IpAddress,UserName) ");
            sb.Append(" VALUES ");

            string Investigation = "";          

                foreach (InvestigationDeliveryDate savedata in objsavedata)
                {
                    //string str = "Delete from investiagtion_delivery where Investigation_ID='" + savedata.Investigation_ID + "' and  CentreID='" + objsavedata[0].CentreID + "'";
                    //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

                    Investigation += "'" + savedata.Investigation_ID + "',";
                    sb.Append(" (");
                    if (savedata.DayType == "Day")
                    {
                        sb.Append("'0',");
                        sb.Append("'0',");
                        sb.Append("'0',");
                        sb.Append("'0',");
                        sb.Append("'0',");
                        sb.Append("'0',");
                        sb.Append("'0',");
                    }
                    else
                    {
                        sb.Append("'" +  savedata.Sun + "',");
                        sb.Append("'" +  savedata.Mon + "',");
                        sb.Append("'" +  savedata.Tue + "',");
                        sb.Append("'" +  savedata.Wed + "',");
                        sb.Append("'" +  savedata.Thu + "',");
                        sb.Append("'" +  savedata.Fri + "',");
                        sb.Append("'" +  savedata.Sat + "',");                       
                    }
                    sb.Append("'" + savedata.Sun_Proc + "',");
                    sb.Append("'" + savedata.Mon_Proc + "',");
                    sb.Append("'" + savedata.Tue_Proc + "',");
                    sb.Append("'" + savedata.Wed_Proc + "',");
                    sb.Append("'" + savedata.Thu_Proc + "',");
                    sb.Append("'" + savedata.Fri_Proc + "',");
                    sb.Append("'" + savedata.Sat_Proc + "',");

                    sb.Append("'" + savedata.DayType + "',");
                    sb.Append("'" + savedata.CentreID + "',");
                    sb.Append("'" + savedata.SubcategoryID + "',");
                    sb.Append("'" + savedata.Investigation_ID + "',");
                    sb.Append("'" + Util.GetDateTime(savedata.bookingcutoff).ToString("HH:mm:ss") + "',");
                    sb.Append("'" + Util.GetDateTime(savedata.sracutoff).ToString("HH:mm:ss") + "',");
                    if (savedata.DayType == "WeekDay")
                    {
                        sb.Append("'0',");
                    }
                    else
                    {
                        sb.Append("'" + savedata.testprocessingday + "',");
                    }
                    sb.Append("'" + Util.GetDateTime(savedata.Reportingcutoff).ToString("HH:mm:ss") + "',");
                    sb.Append("'" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "',");
                    sb.Append("'" + HttpContext.Current.Session["ID"].ToString() + "',");
                    sb.Append("'" + All_LoadData.IpAddress() + "',");
                    sb.Append("'" + HttpContext.Current.Session["LoginName"].ToString() + "'");
                    sb.Append(" ),");


                    


                }

                
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Delete from investiagtion_delivery where Investigation_ID in(" + Investigation.Trim().TrimEnd(',') + ") and  CentreID='" + objsavedata[0].CentreID + "'");
                
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString().Trim().TrimEnd(','));

            

            Tnx.Commit();
            return "1";
        }


        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tnx.Rollback();
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}


public class InvestigationDeliveryDate
{
    public string ID { get; set; }
    public string CentreID { get; set; }
    public string labstarttime { get; set; }
    public string labendtime { get; set; }
    public string Processtype { get; set; }
    public string SR_To_DR { get; set; }
    public string SR_To_ST { get; set; }
    public string ST_To_SLR { get; set; }
    public string SLR_To_DR { get; set; }
    public string SubcategoryID { get; set; }
    public string Investigation_ID { get; set; }
    public string TATType { get; set; }
    public string woringhours { get; set; }
    public string nonworinghours { get; set; }
    public string stathours { get; set; }
    public string Days { get; set; }

    public string Sun { get; set; }
    public string Mon { get; set; }
    public string Tue { get; set; }
    public string Wed { get; set; }
    public string Thu { get; set; }
    public string Fri { get; set; }
    public string Sat { get; set; }

    public string Sun_Proc { get; set; }
    public string Mon_Proc { get; set; }
    public string Tue_Proc { get; set; }
    public string Wed_Proc { get; set; }
    public string Thu_Proc { get; set; }
    public string Fri_Proc { get; set; }
    public string Sat_Proc { get; set; }

    public string CutOffTime { get; set; }
    public string samedaydeliverytime { get; set; }
    public string nextdaydeliverytime { get; set; }
    public string Approval_To_Dispatch { get; set; }

    public string bookingcutoff { get; set; }
    public string sracutoff { get; set; }
    public string testprocessingday { get; set; }
    public string Reportingcutoff { get; set; }
    public string DayType { get; set; }

}