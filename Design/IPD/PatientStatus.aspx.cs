using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Diagnostics;
using System.Collections;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Web.Services;
using System.Web.UI.HtmlControls;



public partial class Design_IPD_PatientStatus : System.Web.UI.Page
{


    private string TID;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {


            ViewState["CenterId"] = Session["CentreID"].ToString();
            hdnTID.Value = Request.QueryString["TransactionID"].ToString();
            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            ViewState["ScreenID"] = 1;
            ViewState["RoleID"] = Session["RoleID"].ToString();
            TID = Request.QueryString["TransactionID"].ToString();
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
        }
    }

[WebMethod]
    public static string CheckDetails(string RoleID, string ID, string TID)
    {
            string IsdischargeIntimated = "";
            IsdischargeIntimated = StockReports.ExecuteScalar(" SELECT IsDischargeIntimate FROM patient_medical_history WHERE TransactionID='" + TID + "'");

            if (IsdischargeIntimated != "")
            {

                DataTable dtIsMedClear = StockReports.GetDataTable("SELECT IFNULL(i.IsMedCleared,0)IsMedCleared,CONCAT(em.Title,'',em.Name)ClearedBy,DATE_FORMAT(i.MedClearedDate,'%d-%b-%Y %h:%i %p')MedClearedDate FROM patient_medical_history i LEFT JOIN employee_master em ON em.EmployeeID =i.MedClearedBy WHERE i.TransactionID='" + TID + "'");//f_ipdadjustment

                if (Util.GetInt(dtIsMedClear.Rows[0]["IsMedCleared"]) != 1)
                {
                    // CHECKING IF PERSON IS AUTHORISED TO GIVE CLEARANCE OF MEDICAL
                    int IsAuthorised = Util.GetInt(All_LoadData.GetAuthorization(Util.GetInt(RoleID), ID, "IsMedClear"));
                    if (IsAuthorised == 0)
                    {
                       
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "You Are Not Authorised for Medical Clearance..." });


                    }
                    else
                    {
                        // Check for discharge process
                        string IsDisIntimated = "";
                        IsDisIntimated = StockReports.ExecuteScalar(" SELECT IsDisIntimated FROM patient_ipd_profile WHERE TransactionID='" + TID + "' AND IsDisIntimated=1 ORDER BY PatientIPDProfile_ID DESC LIMIT 1");
                        if (IsDisIntimated != "1")
                        {
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Kindly Discharge Intimate First.." });

                        }
                    }
                }
            }
            return "";
    }


       
  
  


    [WebMethod]
    public static string LoadMedRequisition( string TID)
    {
           
        try
        {
            StringBuilder sb = new StringBuilder();
           
            sb.Append("SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM (   ");
            sb.Append("SELECT t.*,(CASE WHEN  t.IsAutoReject=0 AND t.reqQty=t.RejectQty THEN 'REJECT'   ");
            sb.Append("WHEN t.IsAutoReject=0 AND t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'     ");
            sb.Append("WHEN   t.IsAutoReject=0 AND t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' WHEN t.IsAutoReject=1 THEN 'AUTOREJECT' ELSE 'PARTIAL'  END)StatusNew   ");
            sb.Append("FROM (             SELECT id.indentno,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,id.Status,SUM(id.IsAutoReject)IsAutoReject,  ");
            sb.Append("lm.ledgername AS DeptTo,   ");
            sb.Append(" pmh.TransactionID,   ");
            sb.Append(" SUM(id.ReqQty)ReqQty,  ");
            sb.Append("SUM(id.ReceiveQty)ReceiveQty,SUM(id.RejectQty)RejectQty FROM f_indent_detail_patient id   ");
            sb.Append("INNER JOIN (SELECT ledgername,ledgernumber FROM f_ledgermaster WHERE groupid='DPT')lm ON lm.LedgerNumber = id.deptto    ");
            sb.Append("INNER JOIN patient_medical_history pmh ON id.TransactionID=pmh.TransactionID      ");
            sb.Append(" WHERE id.StoreID = 'STO00001'   AND pmh.TransactionID = '" + TID + "'    ");
            sb.Append(" GROUP BY indentno ORDER BY id.indentno DESC  ");
            sb.Append("   ) t HAVING StatusNew<>'CLOSE' ");
            sb.Append(" )t1  ");

            DataTable dtIndentDetails = StockReports.GetDataTable(sb.ToString());
       

            if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtIndentDetails);
            }
            else
            {

                return "";
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string LoadDetails(string CenterId, string TID)
    {
        string SqlQuery = "CALL DishargeDisplayScreenPatient(" + CenterId + "," + TID + ")";
        DataTable dt = StockReports.GetDataTable(SqlQuery);

        if (dt.Rows.Count > 0 && dt != null)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
           
        }
        else
        {
            return "";
          
        }
    }
   
     //Pharmacy Clearance

    [WebMethod]
    public static string SaveMedClearance(string ID, string TID)
    {
        bool rowAffected;
        string sql = "";

        sql = "SELECT SUM(IFNULL(id.RejectQty, 0.000000))RejectQty  FROM f_indent_detail_patient id WHERE id.TransactionID ='" + TID + "' ";
        DataTable dt = StockReports.GetDataTable(sql.ToString());
        int checkBit = 0;    

        if (dt != null && dt.Rows.Count > 0)
        {
            //for (int i = 0; dt.Rows.Count > i; i++)
            //{

                if ( Util.GetInt(dt.Rows[0]["RejectQty"])> 0)
                {
                    checkBit = 1;
                }
                
           /// }
            if (checkBit==0)
            {
                string str = "UPDATE patient_medical_history SET IsMedCleared=1,MedClearedBy='" + ID + "',MedClearedDate=now() WHERE TransactionID='" + TID + "'";//f_ipdadjustment      
                rowAffected = StockReports.ExecuteDML(str);
                if ((bool)rowAffected)
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Medicine Clearance Saved Successfully.." });
                }

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient Medical Indents Are Pending.." });
            }

        }

        else
        {
            string str = "UPDATE patient_medical_history SET IsMedCleared=1,MedClearedBy='" + ID + "',MedClearedDate=now() WHERE TransactionID='" + TID + "'";//f_ipdadjustment      
            rowAffected = StockReports.ExecuteDML(str);
                    if ((bool)rowAffected)
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Medicine Clearance Saved Successfully.." });
                    }
               
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient Medical Indents Are Pending.." });
            }

        }
        return "";
    }


      //RejectIndent
    [WebMethod]
    public static string RejectIndent(string indentNo, string ItemId, string status, string ID)
    {
        string IsRejected = "";
        IsRejected = StockReports.ExecuteScalar(" SELECT RejectQty FROM f_indent_detail_patient WHERE IndentNo='" + indentNo + "' and Itemid="+ItemId+"");
          

            if (status.ToUpper() == "OPEN")
            {
                StockReports.ExecuteDML("UPDATE f_indent_detail_patient SET RejectQty=ReqQty,RejectReason='To MedClearance',RejectBy='" + ID + "',dtReject=CURDATE() WHERE IndentNo='" + indentNo + "' AND ITemID='" + ItemId + "'");
                IsRejected = StockReports.ExecuteScalar(" SELECT RejectQty FROM f_indent_detail_patient WHERE IndentNo='" + indentNo + "' ");
                return IsRejected;
            }
            else if (status.ToUpper() == "PARTIAL")
            {
                StockReports.ExecuteDML("UPDATE f_indent_detail_patient SET RejectQty=(ReqQty-ReceiveQty),RejectReason='To MedClearance',RejectBy='" + ID + "',dtReject=CURDATE() WHERE IndentNo='" + indentNo + "' AND ITemID='" + ItemId + "'");
                IsRejected = StockReports.ExecuteScalar(" SELECT RejectQty FROM f_indent_detail_patient WHERE IndentNo='" + indentNo + "' ");
                return IsRejected;
            }

            return "";
    }

      //ViewMedRequition
    [WebMethod]
    public static string ViewMedRequition (string indentNo, string DeptTo, string status)
    {
     
            StringBuilder sb1 = new StringBuilder();
            sb1.Append("  SELECT (CASE WHEN id.reqQty=id.RejectQty THEN 'REJECT' WHEN  id.reqQty-id.ReceiveQty-id.RejectQty=0 THEN 'CLOSE' WHEN   id.reqQty+id.ReceiveQty+id.RejectQty=id.reqQty AND id.IsAutoReject!=1 THEN 'OPEN' WHEN (id.reqQty+id.ReceiveQty+id.RejectQty=id.reqQty OR id.reqQty-id.ReceiveQty-id.RejectQty>0) AND id.IsAutoReject=1 THEN 'AUTOREJECT' ELSE 'PARTIAL'  END)StatusNew,id.IndentNo,(rd.DeptName)DeptFrom,(rd1.DeptName)DeptTo,id.ItemId,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,id.UnitType,id.Narration,  ");
            sb1.Append("  id.isApproved,   id.ApprovedBy,id.ApprovedReason,DATE_FORMAT(id.dtEntry,'%d-%b-%y')DATE,id.UserId,CONCAT(em.Title,' ',em.Name)EmpName, ");
            sb1.Append("   CONCAT(pm.Title,' ',pm.PName)PatientName,pmh.TransactionID,pmh.PatientID,(SELECT NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)DocName, ");
            sb1.Append("   fs.StockID,  sd.SoldUnits,sd.BillNo,sd.PerUnitBuyPrice,sd.PerUnitSellingPrice,fs.BatchNumber,fs.MRP,fs.MedExpiryDate, ");
            sb1.Append("   ROUND((FS.MRP*SD.SoldUnits),2)AMOUNT ");
            sb1.Append("   ,(id.ReqQty-id.ReceiveQty-id.RejectQty)PendingQty,(SELECT CONCAT(Title,' ',NAME)EmpName FROM employee_master WHERE employeeID=id.rejectBy)RejectBy ");
            sb1.Append("  FROM ( ");
            sb1.Append("    SELECT * FROM f_indent_detail_patient id WHERE indentno='" + indentNo + "' )id  INNER  JOIN f_rolemaster rd ON id.DeptFrom=rd.DeptLedgerNo   ");
            sb1.Append("   INNER JOIN f_rolemaster rd1  ON id.DeptTo=rd1.DeptLedgerNo  INNER JOIN employee_master em ON id.UserId=em.EmployeeID   ");
            sb1.Append("   INNER JOIN patient_medical_history pmh ON pmh.TransactionID=id.TransactionID  INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID   ");
            sb1.Append("   LEFT JOIN f_salesdetails sd ON id.IndentNo=sd.IndentNo AND id.ItemId=sd.ItemID  LEFT JOIN f_stock fs ON fs.StockID=sd.StockID   ");

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb1.ToString());
            if (dt.Rows.Count > 0)
            {
              for (int i = 0; i < dt.Rows.Count; i++)
               {
                string sts = dt.Rows[i]["StatusNew"].ToString();
                if (sts.ToUpper() == "OPEN" || sts.ToUpper() == "PARTIAL")
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                }
                
            }
               return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
                      
                return "";
                  
        }
   
      //Bill Freezed
    [WebMethod]
    public static string SaveBillFreezed(string RoleID, string ID, string TID)
    {

        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(RoleID), Util.GetString(ID));

        if (dtAuthority.Rows.Count > 0)
        {
            if (dtAuthority.Rows[0]["IsBillFreezed"].ToString() == "0")
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "You Are Not Authorised To Bill Freezed..." });

            }

            else
            {
                bool rowAffected;
                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction objtnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

                try
                {
                    string Sql = " UPDATE patient_medical_history SET IsBillFreezed=1,BillFreezedTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',BillFreezedUser='" + ID + "' WHERE TransactionID='" + TID + "' ";//f_ipdAdjustment

                    rowAffected = StockReports.ExecuteDML(Sql);
                    if ((bool)rowAffected)
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Bill Freezed. No Further Changes can be done..." });

                    }
                    MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, Sql);
                    string skipStepIDs = IPDBilling.getDischargeSkipSteps(objtnx, (int)AllGlobalFunction.DischargeProcessStep.BillFreeze);
                    if (!String.IsNullOrEmpty(skipStepIDs))
                    {
                        AllUpdate objUpdate = new AllUpdate(objtnx);
                        bool updateStatus = objUpdate.UpdateDischargeProcessStep(TID, Util.GetString(ID), skipStepIDs);
                        if (!updateStatus)
                        {
                            objtnx.Rollback();

                        }
                    }

                    objtnx.Commit();
                }
                catch (Exception ex)
                {
                    objtnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                  
                }
                finally
                {
                    objtnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "last Return" });

    }

  

    //Patient Clearance
 
    [WebMethod]
    public static string SavePatientClearance(string RoleID, string ID, string TID, string Naration)
    {
          DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(RoleID), Util.GetString(ID));

          if (dtAuthority.Rows.Count > 0)
          {
              if (dtAuthority.Rows[0]["IsPatientClearance"].ToString() == "0")
              {
                  return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "You Are Not Authorised To Patient Clearance..." });

              }
              else
              {

                  bool rowAffected;
                  string Sql = "";
                
                  MySqlConnection con = new MySqlConnection();
                  con = Util.GetMySqlCon();
                  con.Open();
                  MySqlTransaction objtnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

                  try
                  {
                      Sql = " UPDATE patient_medical_history SET IsClearance=1,ClearanceRemark='" + Naration.Trim() + "',ClearanceTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',ClearanceUserID='" + ID + "' WHERE TransactionID='" + TID + "' ";//f_ipdAdjustment
                      rowAffected = StockReports.ExecuteDML(Sql);
                      if ((bool)rowAffected)
                      {

                          return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Patient Clearance Saved Successfully.." });


                      }
                 
                      string skipStepIDs = IPDBilling.getDischargeSkipSteps(objtnx, (int)AllGlobalFunction.DischargeProcessStep.PatientClearance);
                      if (!String.IsNullOrEmpty(skipStepIDs))
                      {
                          AllUpdate objUpdate = new AllUpdate(objtnx);
                          bool updateStatus = objUpdate.UpdateDischargeProcessStep(TID, Util.GetString(ID), skipStepIDs);
                          if (!updateStatus)
                          {
                              objtnx.Rollback();

                          }
                      }

                      
                      objtnx.Commit();
                  }
                  catch (Exception ex)
                  {
                      objtnx.Rollback();
                      ClassLog cl = new ClassLog();
                      cl.errLog(ex);
                 
                  }
                  finally
                  {
                      objtnx.Dispose();
                      con.Close();
                      con.Dispose();

                  }
        
              }

          }
          return "" ;


    }

    //Nurse Clrearance

    [WebMethod]
    public static string SaveNurseClearance(string RoleID, string ID, string TID)
    {
        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(RoleID), Util.GetString(ID));

        if (dtAuthority.Rows.Count > 0)
        {
            if (dtAuthority.Rows[0]["IsNurseClean"].ToString() == "0")
            {              
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "You Are Not Authorised To Nursing Clearance..." });

            }
            else
            {
                bool rowAffected;
                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction objtnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

                try
                {
                    string Sql = " UPDATE patient_medical_history SET IsNurseClean=1,NurseCleanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',NurseCleanUserID='" + ID + "' WHERE TransactionID='" + TID + "' ";//f_ipdAdjustment
                    rowAffected = StockReports.ExecuteDML(Sql);
                    if ((bool)rowAffected)
                    {

                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Nursing Clearance Saved Successfully...." });


                    }
                    string skipStepIDs = IPDBilling.getDischargeSkipSteps(objtnx, (int)AllGlobalFunction.DischargeProcessStep.NursingClearance);
                    if (!String.IsNullOrEmpty(skipStepIDs))
                    {
                        AllUpdate objUpdate = new AllUpdate(objtnx);
                        bool updateStatus = objUpdate.UpdateDischargeProcessStep(TID, Util.GetString(ID), skipStepIDs);
                        if (!updateStatus)
                        {
                            objtnx.Rollback();

                        }
                    }

                    objtnx.Commit();
                }
                catch (Exception ex)
                {
                    objtnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                  
                }
                finally
                {
                    objtnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
        }
        return "";

    }

    
     //Room Clearance

    [WebMethod]
    public static string SaveRoomClearance(string RoleID, string ID, string TID)
    {
        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(RoleID), Util.GetString(ID));

        if (dtAuthority.Rows.Count > 0)
        {
            if (dtAuthority.Rows[0]["IsRoomClearance"].ToString() == "0")
            {
          
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "You Are Not Authorised To Room Clearance..." });

            }
            else
            {
                bool rowAffected;
                MySqlConnection con = new MySqlConnection();
                con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction objtnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

                try
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("  SELECT pip.PatientIPDProfile_ID,rm.RoomId,rm.Room_No,rm.Bed_No,ctm.Name,pip.TransactionID FROM patient_ipd_profile pip  ");
                    sb.Append("  INNER JOIN room_master rm ON pip.RoomID=rm.RoomId ");
                    sb.Append("  INNER JOIN ipd_case_type_master ctm ON pip.IPDCaseTypeID=ctm.IPDCaseTypeID ");
                    sb.Append("  WHERE pip.Status='OUT' AND TransactionID='" + TID + "' order by pip.PatientIPDProfile_ID desc limit 1 ");

                    DataTable dtroomdetail = StockReports.GetDataTable(sb.ToString());
                    if (dtroomdetail.Rows.Count > 0)
                    {
                        string SqlRM = " UPDATE room_master SET IsRoomClean=1 WHERE RoomId='" + dtroomdetail.Rows[0]["RoomId"].ToString() + "' ";
                        MySqlHelper.ExecuteNonQuery(objtnx, CommandType.Text, SqlRM);

                        string SqlAdj = " UPDATE patient_medical_history SET IsRoomClean=1,RoomCleanTimeStamp='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "',RoomCleanUserID='" + ID + "' WHERE TransactionID='" + TID + "' ";//f_ipdAdjustment

                        rowAffected = StockReports.ExecuteDML(SqlAdj);
                        if ((bool)rowAffected)
                        {
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Room Clearance Saved Successfully...." });
                        }
                
                        objtnx.Commit();

                    }

                }
                catch (Exception ex)
                {
                    objtnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    
                }
                finally
                {
                    objtnx.Dispose();
                    con.Close();
                    con.Dispose();
                }

            }
        }
        return "";
    }

}                                                                                                                                                           