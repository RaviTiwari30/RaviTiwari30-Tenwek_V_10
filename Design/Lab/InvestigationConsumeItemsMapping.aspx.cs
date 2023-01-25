using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
public partial class Design_OPD_InvestigationConsumeItemsMapping : System.Web.UI.Page
{

    #region Events

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["LoginType"] = Session["LoginType"].ToString();
        }
        lblMsg.Text = "";
     
    }

  
    #endregion

    #region DataLoad


    [WebMethod(EnableSession = true)]
    public static string bindConsumeInvestigation()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT inv.Investigation_Id,inv.NAME InvestigationName FROM investigation_master inv INNER JOIN f_itemmaster im ON im.`Type_ID`=inv.`Investigation_Id` INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`= im.`SubcategoryID`INNER JOIN f_configrelation cr ON sc.`CategoryID`=cr.`CategoryID` WHERE sc.`CategoryID` in(3,7)  ");
        DataTable pg = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(pg);
    }

    [WebMethod(EnableSession = true)]
    public static string bindConsumeInvestigationItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.`ItemID`,im.`TypeName` ItemName FROM f_subcategorymaster sc ");
        sb.Append(" INNER JOIN f_itemmaster im ON sc.`SubCategoryID`=im.`SubcategoryID` ");
        sb.Append(" INNER JOIN f_configrelation cr ON sc.`CategoryID`=cr.`CategoryID` ");
        sb.Append(" WHERE cr.`ConfigID`in (11,28);   ");
        DataTable pg = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(pg);
    }

     [WebMethod(EnableSession = true)]
    public static string getDetail(string investigation_id)
     {
         DataTable dt = new DataTable();
         try
         {
             StringBuilder str = new StringBuilder();
             str.Append(" select csm.`ID`pid,csm.`InvestigationId`,csm.`ItemId`,csm.`DeptLedgerNo`,csm.`CenterId`, ");
             str.Append(" csm.`Qty`,csm.`Remarks`,inv.`NAME` InvestigationName,im.`TypeName` from   ");
             str.Append(" Investigation_ConsumeItems_Mapping csm ");
             str.Append(" inner join investigation_master inv on csm.`InvestigationId`=inv.`Investigation_Id` ");
             str.Append(" INNER JOIN f_itemmaster im ON   csm.`ItemId`=im.`ItemID` ");
             str.Append(" where csm.CenterId=1 ");
             str.Append(" AND csm.InvestigationId='" + investigation_id + "' ");
             dt = StockReports.GetDataTable(str.ToString()).Copy();
         }
         catch (Exception ex)
         {
             ClassLog cl = new ClassLog();
             cl.errLog(ex);

         }
         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
     }


     [WebMethod(EnableSession = true)]
     public static string Save(string pid, string investigationId, string itemId, int qty, string department)
     {


         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try
         {

             if (string.IsNullOrEmpty(pid))
             {


                 excuteCMD.DML(tnx, " insert into Investigation_ConsumeItems_Mapping(investigationId,itemId,qty,centerid,EntryBy,DeptLedgerNo) values(@investigationId,@itemId,@qty,1,@createdby,@DeptLedgerNo) ", CommandType.Text, new
                 {

                     investigationId = investigationId,
                     itemId = itemId,
                     qty = qty,
                     DeptLedgerNo=department,
                     createdby = HttpContext.Current.Session["ID"].ToString()
                 });
                 tnx.Commit();


                 return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = " Save Successfully" });
             }
             else
             {


                 excuteCMD.DML(tnx, "UPDATE Investigation_ConsumeItems_Mapping pmh SET pmh.DeptLedgerNo=@DeptLedgerNo,pmh.investigationId=@investigationId,pmh.itemId=@itemId,qty=@qty,UpdatedDate=@updatedate,UpdatedBy=@updatedby WHERE pmh.id=@pid ", CommandType.Text, new
                 {
                     investigationId = investigationId,
                     itemId = itemId,
                     qty = qty,
                     pid = pid,
                     DeptLedgerNo = department,
                     updatedate = Util.GetDateTime(DateTime.Now),
                     updatedby = HttpContext.Current.Session["ID"].ToString()
                 });
                 tnx.Commit();


                 return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = " Update Successfully" });
             }








         }
         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog cl = new ClassLog();
             cl.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved", message = ex.Message });
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
     }

     [WebMethod(EnableSession = true)]
     public static string cancelRecord(string pid)
     {


         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try
         {

             if (!string.IsNullOrEmpty(pid))
             {
                 excuteCMD.DML(tnx, " delete cm.* from Investigation_ConsumeItems_Mapping cm WHERE cm.id=@pid ", CommandType.Text, new
                 {
                     pid = pid
                 });


             }
             tnx.Commit();
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = " Record Deleted Successfully" });
         }
         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog cl = new ClassLog();
             cl.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved", message = ex.Message });
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
     }

    #endregion

   
}
