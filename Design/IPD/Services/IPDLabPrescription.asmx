<%@ WebService Language="C#" Class="IPDLabPrescription" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class IPDLabPrescription : System.Web.Services.WebService
{
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
     [WebMethod(EnableSession = true)]
    public string BindPatientDetails(string TID,string PID)
    {
        DataTable dt = AllLoadData_IPD.LoadIPDPatientDetail(PID,TID);
        if (dt != null && dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
        {
            DataTable dtEMg = AllLoadData_IPD.LoadEMGPatientDetail(PID, TID);
            if (dtEMg != null && dtEMg.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtEMg);            
            }
            else
            {
                return "";
            } 
        }
           
    }
     [WebMethod]
     public int CalculateDays(string StartDate, string EndDate)
     {
         DateTime st = Util.GetDateTime(StartDate);
         DateTime ed = Util.GetDateTime(EndDate);
         TimeSpan ts = ed.Subtract(st);
         int Days = ts.Days;
         return Days;
     }
     [WebMethod]
     public string CalculateNextDay(DateTime StartDate)
     {
         DateTime NextDate = StartDate.AddDays(1);
         string NewDate = NextDate.ToString("dd-MMM-yyyy");
         return NewDate;
     }
     [WebMethod]
     public string getAlreadyPrescribeItem(string PatientID,string ItemID)
     {
         StringBuilder sb = new StringBuilder();
         sb.Append(" SELECT DATE_FORMAT(entryDate,'%d-%b-%Y')EntryDate,(SELECT NAME FROM employee_master WHERE EmployeeID=ltd.userid)UserName ");
         sb.Append("FROM f_ledgertnxdetail ltd INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo   ");
         sb.Append("WHERE lt.PatientID='"+ PatientID +"' AND ltd.ItemID='"+ ItemID +"'  AND lt.isCancel=0 AND isverified IN(0,1) AND TIMESTAMPDIFF(HOUR,ltd.entryDate,NOW())<'24' ORDER BY ltd.ID  ");
         return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
     }
     [WebMethod(EnableSession = true, Description = "Save IPD Lab Prescription")]
    public string SaveIPDLabPrescription(object LT, object LTD, object PLI, string PatientTypeID, string MembershipNo, string NotificationId)
     {
         string LedgerTransactionNo = string.Empty;
         string barcode = string.Empty;
         int LedgerTnxID =0;
         
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         try
         {

            List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);


            //max Discount Validation\
            string userID = HttpContext.Current.Session["ID"].ToString();
            var maxEligibleDiscountPercent = Util.round(All_LoadData.GetEligiableDiscountPercent(userID));

            var maxDiscountItems = dataLTD.Where(d => d.DiscountPercentage > maxEligibleDiscountPercent).ToList();


            if (maxDiscountItems.Count > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.maxDiscountValidationErrorMessage + maxEligibleDiscountPercent + "</b>" });
            }

            //max Discount Validation




            var LedgerTnxNo = Insert_IPDLedgertransaction.SaveLedgertransaction(LT, LTD, PLI, PatientTypeID, MembershipNo, tnx, con);
            if (LedgerTnxNo.Split('#')[0] != "" || LedgerTnxNo.Split('#')[1] != "0")
            {
                if (!string.IsNullOrEmpty( NotificationId.Trim())  )
                {
                    string str = "update crm_notification  set IsView=1,IsViewBy='" + userID + "',IsViewDateTime=NOW()  WHERE Id in( " + NotificationId + " )";
                    int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                }
              
                tnx.Commit();
                LedgerTransactionNo = LedgerTnxNo.Split('#')[0];
                barcode = LedgerTnxNo.Split('#')[2];
                //return LedgerTransactionNo + "#" + "1";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Patient Barcode No. is : " + barcode, ledgerTransactionNo = LedgerTransactionNo });

            }
            else
            {
                tnx.Rollback();
                //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, ledgerTransactionNo = LedgerTransactionNo });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, ledgerTransactionNo = LedgerTransactionNo });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true, Description = "Save IPD Lab Prescription")]
    public string SaveServicesBilling(object LT, object LTD, string PatientTypeID, string MembershipNo, string NotificationId = "0")
    {
        string LedgerTransactionNo = string.Empty;
        int LedgerTnxID = 0;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            List<LedgerTnxDetail> dataLTD = new JavaScriptSerializer().ConvertToType<List<LedgerTnxDetail>>(LTD);


            //max Discount Validation\
            string userID = HttpContext.Current.Session["ID"].ToString();
            var maxEligibleDiscountPercent = Util.round(All_LoadData.GetEligiableDiscountPercent(userID));

            var maxDiscountItems = dataLTD.Where(d => d.DiscountPercentage > maxEligibleDiscountPercent).ToList();


            if (maxDiscountItems.Count > 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.maxDiscountValidationErrorMessage + maxEligibleDiscountPercent + "</b>" });
            }

            //max Discount Validation


            var LedgerTnxNo = Insert_IPDLedgertransaction.SaveLedgertransaction(LT, LTD, "", PatientTypeID, MembershipNo, tnx, con);
            if (LedgerTnxNo.Split('#')[0] != "" || LedgerTnxNo.Split('#')[1] != "0")
            {
                if (!string.IsNullOrEmpty( NotificationId.Trim())  )
                {
                    string str = "update crm_notification  set IsView=1,IsViewBy='" + userID + "',IsViewDateTime=NOW()  WHERE Id in( " + NotificationId + " )";
                    int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                }
              
                tnx.Commit();
                LedgerTransactionNo = LedgerTnxNo.Split('#')[0];
                LedgerTnxID = Util.GetInt(LedgerTnxNo.Split('#')[1]);
                //  return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "") + "#" + "1";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, LedgerTransactionNo = LedgerTransactionNo });

            }
            else
            {
                tnx.Rollback();
                //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "") + "#" + "0";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, LedgerTransactionNo = LedgerTransactionNo });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, LedgerTransactionNo = LedgerTransactionNo });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string GetDiscount(string PanelID, string ItemID, string patientTypeID, string MembershipNo)
    {
        if (Resources.Resource.IsmembershipInIPD == "1" && PanelID == "1" && MembershipNo != "")
        {
            GetDiscount ds = new GetDiscount();
            var DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(ItemID, MembershipNo, "IPD").Split('#')[0].ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(DiscPerc);
        }
        else
        {
            DataTable dtpaneldisc = AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), ItemID, Util.GetInt(patientTypeID));
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtpaneldisc);
        }
    }

    [WebMethod]
    public string getAlreadyPrescribeOrderItem(string PatientID, string ItemID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DATE_FORMAT(crs.EntryDate,'%d-%b-%Y %r')EntryDate  FROM Tenwek_Docotor_medicine_Order crs  ");

        sb.Append("WHERE crs.PatientId='" + PatientID + "' AND crs.ItemId='" + ItemID + "' and crs.IsDisContinue=0  AND crs.IsActive=1  AND TIMESTAMPDIFF(HOUR,crs.entryDate,NOW())<'24' ORDER BY crs.ID  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }



    [WebMethod(EnableSession = true, Description = "Save Lab And Radiology Order")]
    public string SaveLabAndRadiologyOrder(object LTD)
    {
        string LedgerTransactionNo = string.Empty;
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            List<GetOrderDetails> dataLTD = new JavaScriptSerializer().ConvertToType<List<GetOrderDetails>>(LTD);




            foreach (var item in dataLTD)
            {

                StringBuilder GR = new StringBuilder();

                
                GR.Append("SELECT IF(cm.CategoryID=3,'1',IF(cm.CategoryID=7,'2',IF(cm.CategoryID IN(12,16,2),'3',IF(cm.CategoryID=6,'5',''))))RemId,IF(cm.CategoryID=3,cm.NAME,IF(cm.CategoryID=7,cm.NAME,IF(cm.CategoryID IN(12,16,2),'IPD Services & Package Prescription',IF(cm.CategoryID=6,'Procedure',''))))RemName  ");
                GR.Append("FROM f_itemmaster im ");
                GR.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubcategoryID  ");
                GR.Append(" INNER JOIN  f_categorymaster cm ON cm.CategoryID=sm.CategoryID ");
                GR.Append(" WHERE im.ItemID='" + item.ItemID + "' ");
                DataTable dtGrtype = StockReports.GetDataTable(GR.ToString());
                if (dtGrtype.Rows.Count > 0)
                {
                    item.RemainderType = dtGrtype.Rows[0]["RemId"].ToString();
                    item.RemainderName = dtGrtype.Rows[0]["RemName"].ToString();
                    if (dtGrtype.Rows[0]["RemId"].ToString() == "")
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = item.ItemName + " Is Not of Type Laboratory , Radiology,IPD Services & Package Prescription ! Remove this item ." });

                    }
                }
                //Logic to Add  Stop Date Time on Behalf of No of repetition
                if (Util.GetInt(item.TypeOfSchedular) == 0)
                {
                    DateTime dt = Util.GetDateTime(item.StartDate + ' ' + item.StartTime);

                    if (item.TypeofDuration == "HOUR")
                    {
                        dt = dt.AddHours(Util.GetInt(item.RepeatDuration) * Util.GetInt(item.NoOFRepetition));
                    }
                    else if (item.TypeofDuration == "MONTH")
                    {
                        dt = dt.AddMonths(Util.GetInt(item.RepeatDuration) * Util.GetInt(item.NoOFRepetition));
                    }
                    else if (item.TypeofDuration == "WEEK")
                    {
                        dt = dt.AddDays(Util.GetInt(item.RepeatDuration) * Util.GetInt(item.NoOFRepetition) * 7);
                    }

                    else if (item.TypeofDuration == "DAY")
                    {
                        dt = dt.AddDays(Util.GetInt(item.RepeatDuration) * Util.GetInt(item.NoOFRepetition));
                    }

                    else if (item.TypeofDuration == "MINUTE")
                    {
                        dt = dt.AddMinutes(Util.GetInt(item.RepeatDuration) * Util.GetInt(item.NoOFRepetition));
                    }


                    item.StopDate = dt.ToString("yyyy-MM-dd");
                    item.StopTime = dt.ToString("HH:mm:ss");


                }

                StringBuilder sb = new StringBuilder();


                sb.Append(" INSERT INTO  crm_reminders_status ");
                sb.Append(" (ItemId,PatientId,TransactionId,ReminderID,ReminderTypeName,TypeofScheduler,StartDate,StartTime,RepeatDuration,TypeofDuration,IsActive,EntryBy,Remark,DoctorId,Quantity,AutoStopDate,AutoStopTime,NofRepetition )");

                sb.Append(" VALUES(@ItemId,@PatientId,@TransactionId,@ReminderID,@ReminderTypeName,@TypeofScheduler,@StartDate,@StartTime,@RepeatDuration,@TypeofDuration,@IsActive,@EntryBy,@Remark,@DoctorId,@Quantity,@StopDate,@StopTime,@NofRepetition );");

                int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                      {

                          ItemId = item.ItemID,
                          PatientId = item.PatientId,
                          TransactionId = item.TransactionID,
                          ReminderID = Util.GetInt(item.RemainderType),
                          ReminderTypeName = item.RemainderName,
                          TypeofScheduler = item.TypeOfSchedular,
                          StartDate = Util.GetDateTime(item.StartDate).ToString("yyyy-MM-dd"),
                          StartTime = Util.GetDateTime(item.StartTime).ToString("HH:mm:ss"),
                          RepeatDuration = Util.GetInt(item.RepeatDuration),
                          TypeofDuration = item.TypeofDuration,
                          StopDate = Util.GetDateTime(item.StopDate).ToString("yyyy-MM-dd"),
                          StopTime = Util.GetDateTime(item.StopTime).ToString("HH:mm:ss"),
                          IsActive = 1,
                          EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),

                          Remark = item.Remark,
                          DoctorId = item.DoctorID,
                          Quantity = Util.GetInt(item.Quantity),
                          NofRepetition = Util.GetInt(item.NoOFRepetition),
                      });
                CountSave += A;
            }

            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Order Genrated Successfully" });

            }
            else
            {
                tnx.Rollback();
                //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            CountSave--;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true, Description = "Save Lab And Radiology Order")]
    public string SaveMedicienOrder(object LTD)
    {
        string LedgerTransactionNo = string.Empty;
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            List<GetOrderDetails> dataLTD = new JavaScriptSerializer().ConvertToType<List<GetOrderDetails>>(LTD);




            foreach (var item in dataLTD)
            {

                StringBuilder GR = new StringBuilder();


                item.RemainderType = "4";
                item.RemainderName = "Medicine";
                //Logic to Add  Stop Date Time on Behalf of No of repetition
                if (Util.GetInt(item.TypeOfSchedular) == 0)
                {
                    DateTime dt = Util.GetDateTime(item.StartDate + ' ' + item.StartTime);

                    if (item.TypeofDuration == "HOUR")
                    {
                        dt = dt.AddHours(Util.GetInt(item.RepeatDuration) * Util.GetInt(item.NoOFRepetition));
                    }
                    else if (item.TypeofDuration == "MONTH")
                    {
                        dt = dt.AddMonths(Util.GetInt(item.RepeatDuration) * Util.GetInt(item.NoOFRepetition));
                    }
                    else if (item.TypeofDuration == "WEEK")
                    {
                        dt = dt.AddDays(Util.GetInt(item.RepeatDuration) * Util.GetInt(item.NoOFRepetition) * 7);
                    }

                    else if (item.TypeofDuration == "DAY")
                    {
                        dt = dt.AddDays(Util.GetInt(item.RepeatDuration) * Util.GetInt(item.NoOFRepetition));
                    }

                    else if (item.TypeofDuration == "MINUTE")
                    {
                        dt = dt.AddMinutes(Util.GetInt(item.RepeatDuration) * Util.GetInt(item.NoOFRepetition));
                    }


                    item.StopDate = dt.ToString("yyyy-MM-dd");
                    item.StopTime = dt.ToString("HH:mm:ss");


                }
                StringBuilder sb = new StringBuilder();


                sb.Append(" INSERT INTO  crm_reminders_status ");
                sb.Append(" (ItemId,DurationVal,RequisitionType,PatientId,TransactionId,ReminderID,ReminderTypeName,TypeofScheduler,StartDate,StartTime,RepeatDuration,TypeofDuration,IsActive,EntryBy,Remark,DoctorId,Quantity,AutoStopDate,AutoStopTime, ");
                sb.Append(" Route,Meal,Dose,Timing,Duration,isDischargeMedicine,IsMedicineIndent,TypeOfMedicine,ToDepartment,NofRepetition ) ");
                sb.Append(" VALUES(@ItemId,@DurationVal,@RequisitionType,@PatientId,@TransactionId,@ReminderID,@ReminderTypeName,@TypeofScheduler,@StartDate,@StartTime,@RepeatDuration,@TypeofDuration,@IsActive,@EntryBy,@Remark,@DoctorId,@Quantity,@StopDate,@StopTime ,");
                sb.Append(" @Route,@Meal,@Dose,@Timing,@Duration,@isDischargeMedicine,@IsMedicineIndent,@TypeOfMedicine,@ToDepartment,@NofRepetition )");
                int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {

                    ItemId = item.ItemID,
                    DurationVal = item.DurationVal,
                    RequisitionType = item.RequisitionType,
                    PatientId = item.PatientId,
                    TransactionId = item.TransactionID,
                    ReminderID = Util.GetInt(item.RemainderType),
                    ReminderTypeName = item.RemainderName,
                    TypeofScheduler = item.TypeOfSchedular,
                    StartDate = Util.GetDateTime(item.StartDate).ToString("yyyy-MM-dd"),
                    StartTime = Util.GetDateTime(item.StartTime).ToString("HH:mm:ss"),
                    RepeatDuration = Util.GetInt(item.RepeatDuration),
                    TypeofDuration = item.TypeofDuration,
                    StopDate = Util.GetDateTime(item.StopDate).ToString("yyyy-MM-dd"),
                    StopTime = Util.GetDateTime(item.StopTime).ToString("HH:mm:ss"),
                    IsActive = 1,
                    EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),

                    Remark = item.Remark,
                    DoctorId = item.DoctorID,
                    Quantity = Util.GetInt(item.Quantity),



                    Route = item.Route,
                    Meal = item.Meal,
                    Dose = item.Dose,
                    Timing = item.Time,
                    Duration = item.Duration,
                    isDischargeMedicine = item.isDischargeMedicine,
                    IsMedicineIndent = 1,
                    TypeOfMedicine = item.TypeOfMedicine,
                    ToDepartment = item.ToDepartment,
                    NofRepetition = Util.GetInt(item.NoOFRepetition),
                });
                CountSave += A;
            }

            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Order Genrated Successfully" });

            }
            else
            {
                tnx.Rollback();
                //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            CountSave--;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //return LedgerTransactionNo.Replace("LISHHI", "3").Replace("LSHHI", "3") + "#" + "0";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true, Description = "Save Indent")]
    public string SaveIndent(List<insert> Data, string NotificationId)
    {
        string IndentNo = "";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string EntryID = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select ifnull(Max(EntryID),0)+1 ID from orderset_medication"));
            IndentNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select get_indent_no_patient('" + Data[0].Dept + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')").ToString();
            if (IndentNo != "")
            {
                int count = Util.GetInt(0);
                string ItemID = "";
                string OtherIndentNo = "";
                string DurationDate = "";
                for (int i = 0; i < Data.Count; i++)
                {

                    StringBuilder sb = new StringBuilder();
                    DurationDate = Data[i].Duration;

                    sb.Append("insert into f_indent_detail_patient(IndentNo,ItemId,ItemName,ReqQty,UnitType,DeptFrom,DeptTo,StoreId,UserId,TransactionID,IndentType,CentreID,Hospital_Id,PatientID,DoctorID,IPDCaseTypeID,RoomID,isDischargeMedicine)  ");
                    sb.Append("values('" + IndentNo + "','" + Data[i].ItemID + "','" + Data[i].MedicineName + "'," + Util.GetFloat(Data[i].Quantity) + "");
                    sb.Append(",'" + Data[i].UnitType + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + Data[i].Dept + "','STO00001', ");
                    sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + Data[i].TID + "','" + Data[i].IndentType + "','" + HttpContext.Current.Session["CentreID"].ToString() + "', ");
                    sb.Append("'" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + Data[i].PID + "','" + Data[i].DoctorID + "','" + Data[i].IPDCaseTypeID + "','" + Data[i].Room_ID + "'," + Util.GetInt ( Data[i].isDischargeMedicine )+ ") ");
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                    count = 1;
                    ItemID = Data[i].ItemID;
                    OtherIndentNo = IndentNo;
                    sb.Clear();
                    DateTime DateDuration = Util.GetDateTime(System.DateTime.Now.AddDays(Util.GetDouble(Data[i].DurationValue)).ToString("yyyy-MM-dd"));
                    sb.Append(" Insert into orderset_medication(EntryID,TransactionID,PatientID,MedicineID,MedicineName,ReqQty,Dose,Timing,Duration,EntryBy,IndentNo,Route,Meal)values(");
                    sb.Append(" " + Util.GetInt(EntryID) + ",'" + Data[i].TID + "','" + Data[i].PID + "','" + ItemID + "','" + Data[i].MedicineName + "','" + Util.GetFloat(Data[i].Quantity) + "', ");
                    sb.Append(" '" + Data[i].Dose + "','" + Data[i].Time + "','" + DateDuration.ToString("yyyy-MM-dd") + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + OtherIndentNo + "','" + Data[i].Route + "','" + Util.GetString(Data[i].Meal) + "')");
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                }
                int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + Data[0].Dept + "'"));
                string notification = Notification_Insert.notificationInsert(28, IndentNo, Tranx, "", "", roleID);
                if (notification == "")
                {
                    Tranx.Rollback();
                    return "";
                }


                if (!string.IsNullOrEmpty(NotificationId.Trim()))
                {
                    string str = "update tenwek_docotor_medicine_order  set IsIndentDone=1,IndentNo='" + IndentNo + "',UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id in( " + NotificationId + " )";
                    int i = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

                }
              
                
                Tranx.Commit();
                return "1";
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

        return "0";
    }

    public class insert
    {
        public string ItemID { get; set; }
        public string Dose { get; set; }
        public string Time { get; set; }
        public string Duration { get; set; }
        public string DurationValue { get; set; }
        public string Route { get; set; }
        public string Meal { get; set; }
        public string TID { get; set; }
        public string PID { get; set; }
        public string Doc { get; set; }
        public string LnxNo { get; set; }
        public string MedicineName { get; set; }
        public string Dept { get; set; }
        public string Quantity { get; set; }
        public string UnitType { get; set; }
        public string IndentType { get; set; }
        public string DoctorID { get; set; }
        public string IPDCaseTypeID { get; set; }
        public string Room_ID { get; set; }
        public string isDischargeMedicine { get; set; }
    }
    public class GetOrderDetails
    {

        public string ItemID { get; set; }
        public string ItemName { get; set; }

        public string Quantity { get; set; }
        public string TransactionID { get; set; }

        public string PatientId { get; set; }
        public string DoctorID { get; set; }

        public string RemainderName { get; set; }
        public string RemainderType { get; set; }

        public string StartDate { get; set; }
        public string StartTime { get; set; }


        public string StopDate { get; set; }
        public string StopTime { get; set; }



        public string RepeatDuration { get; set; }
        public string TypeofDuration { get; set; }


        public string TypeOfSchedular { get; set; }


        public string Remark { get; set; }
        public string NoOFRepetition { get; set; }

        //For Medicene only
        public string Dose { get; set; }
        public string Time { get; set; }
        public string Duration { get; set; }
        public int DurationVal { get; set; }
        public int RequisitionType { get; set; }
        public string Route { get; set; }
        public string Meal { get; set; }
        public int isDischargeMedicine { get; set; }
        public int TypeOfMedicine { get; set; }
        public string ToDepartment { get; set; }


    }

}