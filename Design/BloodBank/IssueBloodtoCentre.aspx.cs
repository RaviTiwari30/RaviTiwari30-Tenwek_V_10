using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;

public partial class Design_BloodBank_IssueBloodtoCentre : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }
    }

    [WebMethod(EnableSession = true)]
    public static string LoadCentre()
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT CentreID,CentreName FROM center_master WHERE isactive=1 and CentreID<>'" + HttpContext.Current.Session["CentreID"].ToString() + "' order by CentreName");
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string LoadComponent()
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT ComponentName ,ID FROM bb_component_master  WHERE active='1' order by ComponentName");
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string LoadBloodGroup()
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT ID,BloodGroup FROM bb_BloodGroup_master WHERE IsActive=1 AND bloodgroup<>' NA'  order by bloodgroup ");
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string SearchRequest(string CentreID, string Component, string BloodGroup)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT bdr.ID as RequestID,cm.CentreID, cm.CentreName,bdr.ComponentID,bdr.ComponentName,bdr.BloodGroup,bdr.Quantity,IFNULL(bdr.IssueQuantity,0)IssueQuantity,IFNULL(bdr.RejectQty,0)RejectQty,(bdr.Quantity-IFNULL(bdr.IssueQuantity,0)-IFNULL(bdr.RejectQty,0))PendingQuantity,bdr.EntryReason,  DATE_FORMAT(bdr.EntryDate,'%d-%b-%Y') EntryDate,CONCAT(em.Title,'',em.Name)EntryBy  ");
        sb.Append(" FROM bb_Department_BloodRequest bdr INNER JOIN center_master cm ON cm.CentreID=bdr.FromCentreID   INNER JOIN employee_master em ON bdr.EntryBy=em.Employee_ID WHERE bdr.FromCentreID=" + CentreID + " and bdr.ToCentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " and (bdr.Quantity-IFNULL(bdr.IssueQuantity,0)-IFNULL(bdr.RejectQty,0))>0");
        if (Component != "0")
        {
            sb.Append(" and bdr.ComponentID='" + Component + "'");
        }
        if (BloodGroup != "All")
        {
            sb.Append(" AND bdr.BloodGroup='" + BloodGroup + "'");
        }
        sb.Append(" GROUP BY bdr.ID ORDER BY bdr.Id ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string SearchStock(string CentreID, string Component, string BloodGroup)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sm.Stock_Id,sm.BBTubeNo BatchNo,sm.BloodGroup,sm.Componentname,sm.ComponentId,(initialcount-releasecount)Quantity,    ");
        sb.Append("  DATE_FORMAT(ExpiryDate,'%d-%b-%Y')ExpiryDate FROM bb_stock_master sm ");
        sb.Append(" INNER JOIN center_master cm ON sm.centreId=cm.CentreId WHERE sm.STATUS=1 AND IsDiscarded=0 AND IsDispatch=0 AND IsHold=0 AND DATE(ExpiryDate)>=CURDATE() AND initialcount-releasecount>0 AND sm.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + "");
        if (Component != "0")
        {
            sb.Append(" AND sm.ComponentId='" + Component + "' ");
        }
        //if (BloodGroup != "All")
        //{
        //    sb.Append(" AND sm.BloodGroup='" + BloodGroup + "'");
        //}
        sb.Append(" ORDER BY sm.Id ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }


    [WebMethod(EnableSession = true, Description = "Save Request")]
    public static string SaveRequest(List<StockData> Data)
    {
        int len = Data.Count;
        string StockID = "";
        if (len > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                StockInsert si = new StockInsert(tranX);
                
                for (int i = 0; i < Data.Count; i++)
                {
                    string strStk = "UPDATE bb_stock_master SET ReleaseCount=ReleaseCount+1,IssuedBy='" + HttpContext.Current.Session["ID"].ToString() + "',status=1,IssueDate=now() where Stock_Id='" + Data[i].StockID + "'  ";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strStk);

                    DataTable dt = StockReports.GetDataTable("Select * from bb_stock_master where Stock_Id='" + Data[i].StockID + "'");

                    si.BBTubeNo = dt.Rows[0]["BBTubeNo"].ToString();
                    si.BloodGroup = dt.Rows[0]["BloodGroup"].ToString();
                    si.ComponentName = dt.Rows[0]["ComponentName"].ToString();
                    si.ComponentID = Util.GetInt(dt.Rows[0]["ComponentID"].ToString());
                    si.ExpiryDate = Util.GetDateTime(dt.Rows[0]["ExpiryDate"].ToString());
                    si.InitialCount = Util.GetDecimal(dt.Rows[0]["InitialCount"].ToString());
                    si.CentreId = Util.GetInt(Data[i].CentreID);
                    si.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                    si.IsComponent = 1;
                    si.status = 1;
                    si.IsDiscarded = 0;
                    si.EntryDate = Util.GetDateTime(System.DateTime.Now.ToString());
                    si.FromCentreID = Util.GetInt(dt.Rows[0]["CentreID"].ToString());
                    si.FromStockID = Util.GetString(dt.Rows[0]["Stock_ID"].ToString());
                    if (dt.Rows[0]["BloodCollection_Id"].ToString() == "")
                    {
                        si.FromBloodCollection_Id = Util.GetString(dt.Rows[0]["FromBloodCollection_Id"].ToString());
                    }
                    else
                    {
                        si.FromBloodCollection_Id = Util.GetString(dt.Rows[0]["BloodCollection_Id"].ToString());
                    }
                    si.DeptRequestID =Util.GetInt(Data[0].RequestID);
                    
                    si.Rate = Util.GetDecimal(dt.Rows[0]["Rate"].ToString());
                    StockID = si.Insert();
                }

                string str = "UPDATE bb_department_bloodrequest SET IsIssue = 1, IssueBy = '" + HttpContext.Current.Session["ID"].ToString() + "', IssueDate = NOW(), STATUS = 2, IssueQuantity =IssueQuantity+ " + Data.Count + " WHERE ID = '" + Data[0].RequestID + "' ";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);

                if (Resources.Resource.AllowFiananceIntegration == "1")
                {
                    string IsIntegrated = Util.GetString(EbizFrame.InsertBloodBankPurchase(Util.GetString(Data[0].RequestID), 0, tranX));
                    if (IsIntegrated == "0")
                    {
                        tranX.Rollback();
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
            return "0";
        }
    }

    public class StockData
    {
        public string CentreID { get; set; }
        public string ComponentID { get; set; }
        public string StockID { get; set; }
        public string RequestID { get; set; }
    }

    [WebMethod(EnableSession = true, Description = "Reject Request")]
    public static string RejectRequest(string RequestID, string RejectQty, string RejectReason)
    {
         MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE  bb_Department_BloodRequest SET IsReject=1,  RejectBy='" + HttpContext.Current.Session["ID"].ToString() + "' , STATUS=3,RejectQty=RejectQty+" + Util.GetInt(RejectQty) + ",RejectReason='" + RejectReason + "' WHERE id='" + RequestID + "'");
                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }  
    }
       
}