using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_BloodTransfusionRecords : System.Web.UI.Page
{

    string PID = "";
    string TID = "";
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
    public static string LoadBloodComponent()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT bcm.ID,bcm.ComponentName FROM bb_component_master bcm ");
        
        DataTable dtCentre = StockReports.GetDataTable(sb.ToString());
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null)
            {
                spnTransactionID.InnerText = Request.QueryString["TransactionID"].ToString();
                spnPatientID.InnerText = Request.QueryString["PatientID"].ToString();

                PID = Request.QueryString["PatientID"].ToString();
                TID = Request.QueryString["TransactionID"].ToString();

                AllQuery AQ = new AllQuery();
                DataTable dtDischarge = AQ.GetPatientDischargeStatus(spnTransactionID.InnerText);
                if (dtDischarge != null && dtDischarge.Rows.Count > 0 && dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                {
                    string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No Services possible...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }

        }
        txtDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");

        txtExpiryDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");

        txtCDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");

        calExpiryDate.StartDate = DateTime.Now.Date;

        txtDate.Attributes.Add("readonly", "true");
        txtCDate.Attributes.Add("readonly", "true");
        txtExpiryDate.Attributes.Add("readonly", "true");

    }



    [WebMethod(EnableSession = true)]
    public static string BindEmployee()
    {
        string str = "SELECT em.EmployeeID Id , CONCAT(em.Title,' ',em.NAME)Name FROM employee_master em WHERE em.IsActive=1 ";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true, Description = "Save Blood Transfusion")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveRecord(Records Records, List<Observation> Observation)
    {
        ////if ( Util.GetDateTime(Records.TimeTransfusionStarted)<Util.GetDateTime(Records.TimeTransfusionEnded))
        ////{
        ////     return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Time Transfusion Ended Can not smaller then TimeTransfusionStarted" });

        ////}

        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  tenwek_bloodtransfusion_record ");
            sb.Append(" (PatientId,TransactionId, ");
            sb.Append(" Diagnosis,Date,PatientBloodType,BloodProductTransfused, ");
            sb.Append(" ExpiryDate,BloodUnit,BloodType,TransfusionStratedById, ");
            sb.Append(" TransfusionStratedByName,CounterCheckedById,CounterCheckedByName, ");
            sb.Append(" TimeTransfusionStarted,TimeTransfusionEnded,AmountTransfused,BloodReturnToLab, ");
            sb.Append(" TransfusionReaction,GFever,GChills,GFlushing,GVomating,DUrticarial,DRash,RChestPain, ");
            sb.Append(" RDyspnea,RHypotension,RTchycardia,OtherSpecify,ActionTaken,TransfusionReactionFormFilled,HasLabBeenContacted, ");
            sb.Append(" CName,CTime,NameOfNurse,Signs,CDate,EntryBy,EntryByName, ");
            sb.Append(" IsActive,CentreId ) ");

            sb.Append(" values (@PatientId,@TransactionId, ");
            sb.Append(" @Diagnosis,@Date,@PatientBloodType,@BloodProductTransfused, ");
            sb.Append(" @ExpiryDate,@BloodUnit,@BloodType,@TransfusionStratedById, ");
            sb.Append(" @TransfusionStratedByName,@CounterCheckedById,@CounterCheckedByName, ");
            sb.Append(" @TimeTransfusionStarted,@TimeTransfusionEnded,@AmountTransfused,@BloodReturnToLab, ");
            sb.Append(" @TransfusionReaction,@GFever,@GChills,@GFlushing,@GVomating,@DUrticarial,@DRash,@RChestPain, ");
            sb.Append(" @RDyspnea,@RHypotension,@RTchycardia,@OtherSpecify,@ActionTaken,@TransfusionReactionFormFilled,@HasLabBeenContacted, ");
            sb.Append(" @CName,@CTime,@NameOfNurse,@Signs,@CDate,@EntryBy,@EntryByName, ");
            sb.Append(" @IsActive,@CentreId ) ");

            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {

                PatientId = Records.PatientId,
                TransactionId = Records.TransactionId,
                Diagnosis = Records.Diagnosis,
                Date = Util.GetDateTime(Records.Date).ToString("yyyy-MM-dd"),
                PatientBloodType = Records.PatientBloodType,
                BloodProductTransfused = Records.BloodProductTransfused,
                ExpiryDate = Util.GetDateTime(Records.ExpiryDate).ToString("yyyy-MM-dd"),
                BloodUnit = Records.BloodUnit,
                BloodType = Records.BloodType,
                TransfusionStratedById = Records.TransfusionStratedById,
                TransfusionStratedByName = Records.TransfusionStratedByName,
                CounterCheckedById = Records.CounterCheckedById,
                CounterCheckedByName = Records.CounterCheckedByName,

                TimeTransfusionStarted = Util.GetDateTime(Records.TimeTransfusionStarted).ToString("HH:mm:ss"),
                TimeTransfusionEnded = Util.GetDateTime(Records.TimeTransfusionEnded).ToString("HH:mm:ss"),

                AmountTransfused = Records.AmountTransfused,
                BloodReturnToLab = Records.BloodReturnToLab,
                TransfusionReaction = Records.TransfusionReaction,
                GFever = Records.GFever,
                GChills = Records.GChills,
                GFlushing = Records.GFlushing,
                GVomating = Records.GVomating,
                DUrticarial = Records.DUrticarial,
                DRash = Records.DRash,
                RChestPain = Records.RChestPain,
                RDyspnea = Records.RDyspnea,
                RHypotension = Records.RHypotension,
                RTchycardia = Records.RTchycardia,
                OtherSpecify = Records.OtherSpecify,
                ActionTaken = Records.ActionTaken,
                TransfusionReactionFormFilled = Records.TransfusionReactionFormFilled,
                HasLabBeenContacted = Records.HasLabBeenContacted,
                CName = Records.CName,
                CTime = Util.GetDateTime(Records.CTime).ToString("HH:mm:ss"),
                NameOfNurse = Records.NameOfNurse,
                Signs = Records.Signs,
                CDate = Util.GetDateTime(Records.CDate).ToString("yyyy-MM-dd"),
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                EntryByName = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                IsActive = 1,
                CentreId = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()),

            });




            int RecordId = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(ID) FROM tenwek_bloodtransfusion_record"));

            foreach (var item in Observation)
            {
                StringBuilder sbDoseTime = new StringBuilder();


                sbDoseTime.Append(" INSERT INTO  tenwek_bloodtransfusion_observation ");
                sbDoseTime.Append(" ( BTRecordId,PatientId, ");
                sbDoseTime.Append(" TransactionId,Intervals,Time, ");
                sbDoseTime.Append(" BP,Temp,Pulse,Resp,SPO2, ");
                sbDoseTime.Append(" Remark,EntryBy,IsActive, ");
                sbDoseTime.Append(" CentreId )  ");
                sbDoseTime.Append(" VALUES( @BTRecordId,@PatientId, ");
                sbDoseTime.Append(" @TransactionId,@Intervals,@Time, ");
                sbDoseTime.Append(" @BP,@Temp,@Pulse,@Resp,@SPO2, ");
                sbDoseTime.Append(" @Remark,@EntryBy,@IsActive, ");
                sbDoseTime.Append(" @CentreId )  ");
                int T = excuteCMD.DML(tnx, sbDoseTime.ToString(), CommandType.Text, new
                {

                    BTRecordId = Util.GetInt(RecordId),
                    PatientId = item.PatientId,
                    TransactionId = item.TransactionId,
                    Intervals = item.Intervals,
                    Time = Util.GetDateTime(item.Time).ToString("HH:mm:ss"),
                    BP = item.BP,
                    Temp = item.Temp,
                    Pulse = item.Pulse,
                    Resp = item.Resp,
                    SPO2 = item.SPO2,
                    Remark = item.Remark,
                    EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                    IsActive = 1,
                    CentreId = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()),


                });

            }



            CountSave += A;


            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Save Successfully" });

            }
            else
            {
                tnx.Rollback();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            CountSave--;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true, Description = "Save Blood Transfusion")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateRecord(Records Records, List<Observation> Observation)
    {
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {



            StringBuilder sb = new StringBuilder();


            sb.Append(" UPDATE  tenwek_bloodtransfusion_record ");

            sb.Append(" SET Diagnosis=@Diagnosis,Date=@Date,PatientBloodType=@PatientBloodType,BloodProductTransfused=@BloodProductTransfused, ");
            sb.Append(" ExpiryDate=@ExpiryDate,BloodUnit=@BloodUnit,BloodType=@BloodType,TransfusionStratedById=@TransfusionStratedById, ");
            sb.Append(" TransfusionStratedByName=@TransfusionStratedByName,CounterCheckedById=@CounterCheckedById,CounterCheckedByName=@CounterCheckedByName, ");
            sb.Append(" TimeTransfusionStarted=@TimeTransfusionStarted,TimeTransfusionEnded=@TimeTransfusionEnded,AmountTransfused=@AmountTransfused,BloodReturnToLab=@BloodReturnToLab, ");
            sb.Append(" TransfusionReaction=@TransfusionReaction,GFever=@GFever,GChills=@GChills,GFlushing=@GFlushing,GVomating=@GVomating,DUrticarial=@DUrticarial,DRash=@DRash,RChestPain=@RChestPain, ");
            sb.Append(" RDyspnea=@RDyspnea,RHypotension=@RHypotension,RTchycardia=@RTchycardia,OtherSpecify=@OtherSpecify,ActionTaken=@ActionTaken,TransfusionReactionFormFilled=@TransfusionReactionFormFilled,HasLabBeenContacted=@HasLabBeenContacted, ");
            sb.Append(" CName=@CName,CTime=@CTime,NameOfNurse=@NameOfNurse,Signs=@Signs,CDate=@CDate,UpdateBy=@UpdateBy,UpdateDate=NOW() WHERE Id=@Id ");



            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {

                Id=Records.Id,
                Diagnosis = Records.Diagnosis,
                Date = Util.GetDateTime(Records.Date).ToString("yyyy-MM-dd"),
                PatientBloodType = Records.PatientBloodType,
                BloodProductTransfused = Records.BloodProductTransfused,
                ExpiryDate = Util.GetDateTime(Records.ExpiryDate).ToString("yyyy-MM-dd"),
                BloodUnit = Records.BloodUnit,
                BloodType = Records.BloodType,
                TransfusionStratedById = Records.TransfusionStratedById,
                TransfusionStratedByName = Records.TransfusionStratedByName,
                CounterCheckedById = Records.CounterCheckedById,
                CounterCheckedByName = Records.CounterCheckedByName,

                TimeTransfusionStarted = Util.GetDateTime(Records.TimeTransfusionStarted).ToString("HH:mm:ss"),
                TimeTransfusionEnded = Util.GetDateTime(Records.TimeTransfusionEnded).ToString("HH:mm:ss"),

                AmountTransfused = Records.AmountTransfused,
                BloodReturnToLab = Records.BloodReturnToLab,
                TransfusionReaction = Records.TransfusionReaction,
                GFever = Records.GFever,
                GChills = Records.GChills,
                GFlushing = Records.GFlushing,
                GVomating = Records.GVomating,
                DUrticarial = Records.DUrticarial,
                DRash = Records.DRash,
                RChestPain = Records.RChestPain,
                RDyspnea = Records.RDyspnea,
                RHypotension = Records.RHypotension,
                RTchycardia = Records.RTchycardia,
                OtherSpecify = Records.OtherSpecify,
                ActionTaken = Records.ActionTaken,
                TransfusionReactionFormFilled = Records.TransfusionReactionFormFilled,
                HasLabBeenContacted = Records.HasLabBeenContacted,
                CName = Records.CName,
                CTime = Util.GetDateTime(Records.CTime).ToString("HH:mm:ss"),
                NameOfNurse = Records.NameOfNurse,
                Signs = Records.Signs,
                CDate = Util.GetDateTime(Records.CDate).ToString("yyyy-MM-dd"),
                UpdateBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
               

            });



            string str = "update tenwek_bloodtransfusion_observation  set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=NOW()  WHERE BTRecordId=" + Util.GetInt(Records.Id) + " ";
            int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            int RecordId = Records.Id;

            foreach (var item in Observation)
            {
                StringBuilder sbDoseTime = new StringBuilder();

                string Sign=Util.GetString(HttpContext.Current.Session["ID"].ToString());
                if (!string.IsNullOrEmpty( item.EntryBy) )
	                {
		                    Sign=item.EntryBy;
                    }

                sbDoseTime.Append(" INSERT INTO  tenwek_bloodtransfusion_observation ");
                sbDoseTime.Append(" ( BTRecordId,PatientId, ");
                sbDoseTime.Append(" TransactionId,Intervals,Time, ");
                sbDoseTime.Append(" BP,Temp,Pulse,Resp,SPO2, ");
                sbDoseTime.Append(" Remark,EntryBy,IsActive, ");
                sbDoseTime.Append(" CentreId )  ");
                sbDoseTime.Append(" VALUES( @BTRecordId,@PatientId, ");
                sbDoseTime.Append(" @TransactionId,@Intervals,@Time, ");
                sbDoseTime.Append(" @BP,@Temp,@Pulse,@Resp,@SPO2, ");
                sbDoseTime.Append(" @Remark,@EntryBy,@IsActive, ");
                sbDoseTime.Append(" @CentreId )  ");
                int T = excuteCMD.DML(tnx, sbDoseTime.ToString(), CommandType.Text, new
                {

                    BTRecordId = Util.GetInt(RecordId),
                    PatientId = item.PatientId,
                    TransactionId = item.TransactionId,
                    Intervals = item.Intervals,
                    Time = Util.GetDateTime(item.Time).ToString("HH:mm:ss"),
                    BP = item.BP,
                    Temp = item.Temp,
                    Pulse = item.Pulse,
                    Resp = item.Resp,
                    SPO2 = item.SPO2,
                    Remark = item.Remark,
                    EntryBy = Sign,
                    IsActive = 1,
                    CentreId = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()),

                    
                });

            }



            CountSave += A;


            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Updated Successfully" });

            }
            else
            {
                tnx.Rollback();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {
            CountSave--;
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetDataDetails(string Pid, string Tid)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();


            sbnew.Append(" SELECT Id,PatientId,TransactionId, ");
            sbnew.Append(" Diagnosis,DATE_FORMAT( DATE,'%d-%b-%Y')Date,PatientBloodType,(SELECT BloodGroup FROM bb_BloodGroup_master WHERE ID=PatientBloodType )PatientBloodType1,BloodProductTransfused,(SELECT bcm.ComponentName FROM bb_component_master bcm where bcm.ID=iu.BloodProductTransfused)BloodProductTransfused1 , ");
            sbnew.Append(" DATE_FORMAT( ExpiryDate,'%d-%b-%Y')ExpiryDate,BloodUnit,BloodType,(SELECT BloodGroup FROM bb_BloodGroup_master WHERE ID=iu.BloodType)BloodType1,TransfusionStratedById, ");
            sbnew.Append(" TransfusionStratedByName,CounterCheckedById,CounterCheckedByName, ");
            sbnew.Append(" DATE_FORMAT(TimeTransfusionStarted,'%I:%i %p')TimeTransfusionStarted, ");
            sbnew.Append(" DATE_FORMAT(TimeTransfusionEnded,'%I:%i %p')TimeTransfusionEnded,AmountTransfused,BloodReturnToLab, ");
            sbnew.Append(" TransfusionReaction,GFever,GChills,GFlushing,GVomating,DUrticarial,DRash,RChestPain, ");
            sbnew.Append(" RDyspnea,RHypotension,RTchycardia,OtherSpecify,ActionTaken,TransfusionReactionFormFilled,HasLabBeenContacted, ");
            sbnew.Append(" CName,DATE_FORMAT(CTime,'%I:%i %p')CTime,NameOfNurse,Signs,DATE_FORMAT( CDate,'%d-%b-%Y')CDate, ");
            sbnew.Append(" EntryBy,EntryByName,DATE_FORMAT( EntryDate,'%d-%b-%Y')EntryDate, ");
            sbnew.Append(" IsActive,CentreId FROM tenwek_bloodtransfusion_record iu WHERE IsActive=1  AND PatientId='" + Pid + "' AND TransactionId='" + Tid + "' ");

            DataTable dt = StockReports.GetDataTable(sbnew.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

        }
    }




    [WebMethod(EnableSession = true)]
    public static string GetObservationData(int RecId)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();

            sbnew.Append(" SELECT Id,BTRecordId,PatientId, ");
            sbnew.Append(" TransactionId,Intervals,DATE_FORMAT(TIME,'%I:%i %p')Time, ");
            sbnew.Append(" BP,Temp,Pulse,Resp,SPO2, ");
            sbnew.Append(" Remark,EntryBy ");
            sbnew.Append("   FROM tenwek_bloodtransfusion_observation WHERE IsActive=1 AND BTRecordId=" + RecId + " ");

            DataTable dt = StockReports.GetDataTable(sbnew.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

        }
    }


































    public class Records
    {

        public int Id { get; set; }
        public string PatientId { get; set; }
        public string TransactionId { get; set; }
        public string Diagnosis { get; set; }
        public string Date { get; set; }
        public string PatientBloodType { get; set; }
        public string BloodProductTransfused { get; set; }
        public string ExpiryDate { get; set; }
        public string BloodUnit { get; set; }
        public string BloodType { get; set; }
        public string TransfusionStratedById { get; set; }
        public string TransfusionStratedByName { get; set; }
        public string CounterCheckedById { get; set; }
        public string CounterCheckedByName { get; set; }
        public string TimeTransfusionStarted { get; set; }
        public string TimeTransfusionEnded { get; set; }
        public string AmountTransfused { get; set; }
        public int BloodReturnToLab { get; set; }
        public int TransfusionReaction { get; set; }
        public int GFever { get; set; }
        public int GChills { get; set; }
        public int GFlushing { get; set; }
        public int GVomating { get; set; }
        public int DUrticarial { get; set; }
        public int DRash { get; set; }
        public int RChestPain { get; set; }
        public int RDyspnea { get; set; }
        public int RHypotension { get; set; }
        public int RTchycardia { get; set; }
        public string OtherSpecify { get; set; }
        public string ActionTaken { get; set; }
        public int TransfusionReactionFormFilled { get; set; }
        public int HasLabBeenContacted { get; set; }
        public string CName { get; set; }
        public string CTime { get; set; }
        public string NameOfNurse { get; set; }
        public string Signs { get; set; }
        public string CDate { get; set; }
        public string EntryBy { get; set; }
        public string EntryByName { get; set; }

        public int IsActive { get; set; }
        public int CentreId { get; set; }

    }



    public class Observation
    {

        public int Id { get; set; }
        public int BTRecordId { get; set; }
        public string PatientId { get; set; }
        public string TransactionId { get; set; }
        public string Intervals { get; set; }
        public string Time { get; set; }
        public string BP { get; set; }
        public string Temp { get; set; }
        public string Pulse { get; set; }
        public string Resp { get; set; }
        public string SPO2 { get; set; }
        public string Remark { get; set; }
        public string EntryBy { get; set; }
        public int IsActive { get; set; }
        public int CentreId { get; set; }

    }




}