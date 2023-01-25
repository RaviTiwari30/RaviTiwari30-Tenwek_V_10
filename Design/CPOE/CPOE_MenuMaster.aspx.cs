using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_CPOE_CPOE_MenuMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                bindLoginType();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void bindLoginType()
    {
        try
        {
            string str = "select ID,RoleName from f_rolemaster where active=1 order by RoleName";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlRole.DataSource = dt;
                ddlRole.DataTextField = "RoleName";
                ddlRole.DataValueField = "ID";
                ddlRole.DataBind();

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindAllMenu(string RoleID,int type)
    {
        try
        {
            DataTable dt = new DataTable();
            if (type == 1)
            {
                dt = StockReports.GetDataTable("SELECT Id,MenuName,SequenceNo,IsActive,'Active' Active,'DeActive' DeActive FROM  cpoe_menumaster WHERE RoleID='" + RoleID + "' order by SequenceNo+0");
            }
            else
            {
                dt = StockReports.GetDataTable("SELECT cp.`ID` AS Id,cp.`AccordianName` AS MenuName,cpms.`Order` SequenceNo,cpms.IsActive,'Active' Active,'DeActive' DeActive FROM  cpoe_prescription_master cp INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID` WHERE cpms.`RoleID`='" + RoleID + "' AND cp.IsActive=1 AND cpms.`IsDefault`=1 AND IFNULL(cpms.`DoctorID`,'')='' group by cp.ID ORDER BY cpms.`Order`+0 ");
                if (dt.Rows.Count == 0)
                {
                    dt = StockReports.GetDataTable("SELECT cp.`ID` AS Id,cp.`AccordianName` AS MenuName,cp.`Order` SequenceNo,IsActive,'Active' Active,'DeActive' DeActive FROM cpoe_prescription_master cp WHERE cp.IsActive=1  ORDER BY cp.`Order`+0 ");
                }
            }
                if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    public static string saveCPOETable(object CPOE, string RoleID,int type)
    {
        List<CPOEMenu> CPOEMenu = new JavaScriptSerializer().ConvertToType<List<CPOEMenu>>(CPOE);
        if (CPOEMenu.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                
                for (int i = 0; i < CPOEMenu.Count; i++)
                {
                    if (type == 1)
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE cpoe_menumaster cmm LEFT JOIN cpoe_menu cm ON cmm.id=cm.MenuID  SET cmm.SequenceNo='" + (Util.GetInt(i) + 1) + "',cmm.IsActive='" + HttpUtility.UrlDecode(CPOEMenu[i].Active) + "',cm.IsActive='" + HttpUtility.UrlDecode(CPOEMenu[i].Active) + "'  WHERE cmm.RoleID='" + RoleID + "' AND cmm.ID='" + CPOEMenu[i].ID + "' ");
                    else
                    {
                        if(i==0)
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE cpoe_prescription_master_setting SET IsDefault=2,IsActive=0,UpdatedDateTime=NOW(),UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "' WHERE RoleID='" + RoleID + "' and IsDefault=1 AND IsActive=1 ");

                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO cpoe_prescription_master_setting(RoleID,CPOE_Prescription_Master_ID,`Order`,IsDefault,CreatedBy,CreatedDateTime,IsActive) VALUES('" + RoleID + "','" + CPOEMenu[i].ID + "','" + (Util.GetInt(i) + 1) + "',1,'" + HttpContext.Current.Session["ID"].ToString() + "',now(),'" + HttpUtility.UrlDecode(CPOEMenu[i].Active) + "') ");
                    
                    
                    }
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {

                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
        {
            return "";
        }
    }

    public class CPOEMenu
    {
        public string SNo { get; set; }
        public string ID { get; set; }
        public string MenuName { get; set; }
        public string SequenceNo { get; set; }
        public string Active { get; set; }
    }
    
}