using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_EDP_IPDBill_PrintSetting : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string bindselectiontype(string type)
    {
        DataTable dt = new DataTable();
        if (type.ToUpper() == "DETMIXCONFIG")
        {
            dt = StockReports.GetDataTable("SELECT cr.ConfigID Value,cr.Name Text FROM f_configrelation cr WHERE IsActive=1 GROUP BY cr.ConfigID");
        }
        else if (type.ToUpper() == "DETMIXDISP")
        {
            dt = StockReports.GetDataTable("SELECT dn.DisplayName Value,dn.DisplayName Text  FROM f_displaynamemaster dn WHERE dn.IsActive=1");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public static string SaveIPDBillSetting(string BillType, string Type,int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (BillType.ToUpper() == "DETMIXDISP")
            {
                int alreadyexist = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM ipd_billprintsetting bp WHERE bp.BillPrintType='DETMIXDISP' AND bp.IsActive=1 AND bp.DisplayName='" + Type + "' AND CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " "));
                if (alreadyexist == 0)
                {
                    StringBuilder sb = new StringBuilder();
                    if (ID == 0)
                    {
                        sb.Append("INSERT INTO ipd_billprintsetting (DisplayName=@DisplayName,EntryBy,BillPrintType,CentreID) VALUES (@DisplayName,@EntryBy,@BillPrintType,@CentreID) ");
                    }
                    else
                    {
                        sb.Append(" Update ipd_billprintsetting set DisplayName=@DisplayName,UpdatedBy=@EntryBy,BillPrintType=@BillPrintType,CentreID=@CentreID where ID=@ID ");
                    }
                        int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@DisplayName", Type),
                         new MySqlParameter("@EntryBy", HttpContext.Current.Session["ID"].ToString()),
                         new MySqlParameter("@BillPrintType", BillType),
                         new MySqlParameter("@CentreID", Util.GetString(HttpContext.Current.Session["CentreID"])),
                         new MySqlParameter("@ID", ID)
                         );
                }
                else
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This Entry Already Exist.", message = "This Entry Already Exist." });
                }
            }
            else if (BillType.ToUpper() == "DETMIXCONFIG")
            {
                int alreadyexist = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM ipd_billprintsetting bp WHERE bp.BillPrintType='DETMIXCONFIG' AND bp.IsActive=1 AND bp.ConfigID='" + Type + "' AND CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + ""));
                if (alreadyexist == 0)
                {
                    StringBuilder sb = new StringBuilder();
                    if (ID == 0)
                    {
                        sb.Append("INSERT INTO ipd_billprintsetting (ConfigID,EntryBy,BillPrintType,CentreID) VALUES (@ConfigID,@EntryBy,@BillPrintType,@CentreID) ");
                    }
                    else
                    {
                        sb.Append(" Update ipd_billprintsetting set ConfigID=@ConfigID,UpdatedBy=@EntryBy,BillPrintType=@BillPrintType,CentreID=@CentreID where ID=@ID ");
                    }
                        int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@ConfigID", Type),
                         new MySqlParameter("@EntryBy", HttpContext.Current.Session["ID"].ToString()),
                         new MySqlParameter("@BillPrintType", BillType),
                         new MySqlParameter("@CentreID", Util.GetString(HttpContext.Current.Session["CentreID"])),
                          new MySqlParameter("@ID", ID)
                         );
                }
                else
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This Entry Already Exist.", message = "This Entry Already Exist." });
                }
            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindbillprintsetting(string BillType, string Type)
    {
        try
        {
            StringBuilder sqlCMD = new StringBuilder();

            sqlCMD.Append(" SELECT bs.ConfigID,bs.ID,(SELECT c.NAME FROM f_configrelation c where c.ConfigID=bs.ConfigID and c.IsActive=1 GROUP BY c.ConfigID)NAME,bs.DisplayName,DATE_FORMAT(bs.EntryDate,'%d-%b-%Y %h:%i %p')EntryDate,DATE_FORMAT(bs.UpdatedDate,'%d-%b-%Y %h:%i %p')UpdatedDate, ");
            sqlCMD.Append(" (SELECT CONCAT(em.Title,' ',em.Name) FROM employee_master em WHERE em.EmployeeID=bs.EntryBy)EntryBy, ");
            sqlCMD.Append(" (SELECT CONCAT(em.Title,' ',em.Name) FROM employee_master em WHERE em.EmployeeID=bs.UpdatedBy)UpdatedBy, ");
            sqlCMD.Append(" bs.IsActive,bs.BillPrintType,(CASE WHEN bs.BillPrintType='DETMIXCONFIG' THEN 'Config Wise' ELSE 'Display Name Wise' END)PrintType, ");
            sqlCMD.Append(" cm.CentreName FROM ipd_billprintsetting bs ");
            sqlCMD.Append(" INNER JOIN center_master cm ON cm.CentreID=bs.CentreID where bs.BillPrintType=@BillType and bs.CentreID='" + Util.GetString(System.Web.HttpContext.Current.Session["BookingCentreID"].ToString()) + "' ");

            if (Type != "0")
                sqlCMD.Append(" and bs.ConfigID =@Type ");

            sqlCMD.Append(" ORDER BY bs.EntryDate desc ");

            ExcuteCMD excuteCMD = new ExcuteCMD();
            var dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
            {
                BillType = BillType,
                Type = Type
            });

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {

        }
    }
    [WebMethod(EnableSession = true)]
    public static string UpdateStatus(int ID, string Status)
    {
        MySqlConnection objCon = Util.GetMySqlCon();
        objCon.Open();
        MySqlTransaction objTrans = objCon.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string str = " Update ipd_billprintsetting set IsActive=" + Status + " where ID=" + ID + "; ";
            int i = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, str);
            objTrans.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Status Changed Succefully." });
        }
        catch (Exception ex)
        {
            objTrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });
        }
        finally
        {
            objTrans.Dispose();
            objCon.Close();
            objCon.Dispose();
        }
    }
}