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
public partial class Design_OPD_OPDFixedPharmacyBill : System.Web.UI.Page
{

    #region Events

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPatientID.Focus();
          
            ViewState["LoginType"] = Session["LoginType"].ToString();
          
        }
        lblMsg.Text = "";
    }

  
    #endregion

    #region DataLoad


     [WebMethod(EnableSession = true)]  
    public static string getPatientDetails(string PatientId)
    {
        DataTable dt = new DataTable();
        try
        {
            StringBuilder str = new StringBuilder();
            str.Append(" SELECT pm.gender,CONCAT(pm.title,' ',pm.pname)pname,pm.PatientID,fpm.Company_Name PanelName,fpm.PanelID PanelID, ");
            str.Append("   CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City)Address,pm.Relation,pm.RelationName   ");
            str.Append("  From patient_master pm  ");
            str.Append("  INNER JOIN (SELECT pmh.patientid, pmh.PanelID,pmh.TransactionID FROM patient_medical_history pmh WHERE pmh.patientid='" + PatientId + "' and pmh.type='OPD' ORDER BY pmh.TransactionID DESC LIMIT 0,1) t ON pm.`PatientID`=t.`PatientID` ");
            str.Append("  INNER JOIN f_panel_master fpm ON t.`PanelID`=fpm.`PanelID`  ");
            str.Append(" WHERE    pm.Active=1 AND pm.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");

            str.Append("AND pm.PatientID='" + PatientId + "' limit 0,1 ");
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
     public static string getPatientHistory(string PatientId)
     {
         DataTable dt = new DataTable();
         try
         {
             StringBuilder str = new StringBuilder();
             str.Append(" SELECT IFNULL(ofp.Id,'') ofpbid,ofp.ReferealNo,ofp.MaxBillAllow,pm.gender,CONCAT(pm.title,' ',pm.pname)pname,pm.PatientID,fpm.Company_Name PanelName,fpm.PanelID PanelID, ");
             str.Append("   CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City)Address,pm.Relation,pm.RelationName   ");
             str.Append("  From patient_master pm  ");
             str.Append("  INNER JOIN (SELECT  pmh.patientid,pmh.PanelID,pmh.TransactionID FROM patient_medical_history pmh WHERE pmh.patientid='" + PatientId + "' and pmh.type='OPD' ORDER BY pmh.TransactionID DESC LIMIT 0,1) t ON pm.`PatientID`=t.`PatientID` ");
             str.Append("  INNER JOIN f_panel_master fpm ON t.`PanelID`=fpm.`PanelID`  ");
             str.Append(" inner join f_opdfixedpharmacybill ofp on pm.patientid=ofp.patientid and ofp.IsActive=1    ");
             str.Append(" WHERE pm.Active=1 AND pm.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");

             if (!string.IsNullOrEmpty(PatientId))
             str.Append(" AND pm.PatientID='" + PatientId + "' ");

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
     public static string cancelRecord(string pid, string patientID)
     {


         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try
         {

             if (!string.IsNullOrEmpty(pid))
             {
                 excuteCMD.DML(tnx, "UPDATE f_opdfixedpharmacybill pmh SET pmh.IsActive=0 WHERE pmh.id=@pid and pmh.patientID=@patientID ", CommandType.Text, new
                 {
                     patientID = patientID,
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

     [WebMethod(EnableSession = true)]
     public static string Save(string pid, string patientID, string referealno, string maxbillallow)
     {


         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try
         {


          


             if (string.IsNullOrEmpty(pid))
             {
                 int isExit = Util.GetInt(StockReports.ExecuteScalar("SELECT pnl.Id FROM f_opdfixedpharmacybill pnl WHERE pnl.`patientID`=" + patientID + " and pnl.isactive=1 "));

                 if (isExit > 0)
                     return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Duplicate Patient not Allow.", message = "Duplicate Patient not Allow." });


                 excuteCMD.DML(tnx, " insert into f_opdfixedpharmacybill(patientID,referealno,maxbillallow,CreatedBy) values(@patientID,@referealno,@maxbillallow,@createdby) ", CommandType.Text, new
                 {
                     patientID = patientID,
                     referealno = referealno,
                     maxbillallow = maxbillallow,
                     createdby = HttpContext.Current.Session["ID"].ToString()
                 });
                 tnx.Commit();


                 return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
             }
             else
             {


                 excuteCMD.DML(tnx, "UPDATE f_opdfixedpharmacybill pmh SET pmh.referealno=@referealno,pmh.maxbillallow=@maxbillallow,UpdateDate=@updatedate,UpdateBy=@updatedby WHERE pmh.id=@pid and pmh.patientID=@patientID ", CommandType.Text, new
                 {
                     patientID = patientID,
                     referealno = referealno,
                     maxbillallow = maxbillallow,
                     pid = pid,
                     updatedate = Util.GetDateTime(DateTime.Now),
                     updatedby = HttpContext.Current.Session["ID"].ToString()
                 });
                 tnx.Commit();


                 return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = " Record Update Successfully" });
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

    #endregion

   
}
