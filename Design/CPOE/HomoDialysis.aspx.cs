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

public partial class Design_CPOE_HomoDialysis : System.Web.UI.Page
{
    string PID = "";
    string TID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["TransactionID"] != null)
        {
            spnTransactionID.InnerText = Request.QueryString["TransactionID"].ToString();
            spnPatientID.InnerText = Request.QueryString["PatientID"].ToString();

            PID = Request.QueryString["PatientID"].ToString();
            TID = Request.QueryString["TransactionID"].ToString();
            HttpContext.Current.Session["PID"] = PID;
            HttpContext.Current.Session["TID"] = TID;
        }
        txtScreeingDate1.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtScreeingDate2.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtScreeingDate3.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtDateDone.Text = DateTime.Now.ToString("dd-MMM-yyyy");

        txtScreeingDate1.Attributes.Add("readOnly", "readOnly");
        txtScreeingDate2.Attributes.Add("readOnly", "readOnly");
        txtScreeingDate3.Attributes.Add("readOnly", "readOnly");
        txtDateDone.Attributes.Add("readOnly", "readOnly");
    }



    [WebMethod(EnableSession = true, Description = "Hemodialysis_Pre_Dialysis_Vital")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveHemodialysis_Pre_Dialysis_Vital(Hemodialysis_Pre_Dialysis_Vital Vital)
    {


        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  Hemodialysis_Pre_Dialysis_Vital ");
            sb.Append("  (TransactionId,PatientId,PreviousWeight,CurrentWeight, ");
            sb.Append(" WeightGain,DryWeight,BloodGroup,HivTest,HepatitisBSurfaceAg, ");
            sb.Append(" HeapatitisCAntiBody,BP,Pulse,Resp,Spo2,Temp,RBS, ");
            sb.Append(" ScreeingDate1,ScreeingDate2,ScreeingDate3,DateDone, ");
            sb.Append(" EntryBy,EntryByName,IsActive,CurrentHB,Diagnosis)  ");
            sb.Append(" values (@TransactionId,@PatientId,@PreviousWeight,@CurrentWeight, ");
            sb.Append(" @WeightGain,@DryWeight,@BloodGroup,@HivTest,@HepatitisBSurfaceAg, ");
            sb.Append(" @HeapatitisCAntiBody,@BP,@Pulse,@Resp,@Spo2,@Temp,@RBS, ");
            sb.Append(" @ScreeingDate1,@ScreeingDate2,@ScreeingDate3,@DateDone, ");
            sb.Append(" @EntryBy,@EntryByName,@IsActive,@CurrentHB,@Diagnosis)  ");
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                TransactionId = Vital.TransactionId,
                PatientId = Vital.PatientId,
                PreviousWeight = Vital.PreviousWeight,
                CurrentWeight = Vital.CurrentWeight,
                WeightGain = Vital.WeightGain,
                DryWeight = Vital.DryWeight,
                BloodGroup = Vital.BloodGroup,
                HivTest = Vital.HivTest,
                HepatitisBSurfaceAg = Vital.HepatitisBSurfaceAg,
                HeapatitisCAntiBody = Vital.HeapatitisCAntiBody,
                BP = Vital.BP,
                Pulse = Vital.Pulse,
                Resp = Vital.Resp,
                Spo2 = Vital.Spo2,
                Temp = Vital.Temp,
                RBS = Vital.RBS,
                ScreeingDate1 = Util.GetDateTime(Vital.ScreeingDate1).ToString("yyyy-MM-dd"),
                ScreeingDate2 = Util.GetDateTime(Vital.ScreeingDate2).ToString("yyyy-MM-dd"),
                ScreeingDate3 = Util.GetDateTime(Vital.ScreeingDate3).ToString("yyyy-MM-dd"),
                DateDone = Util.GetDateTime(Vital.DateDone).ToString("yyyy-MM-dd"),
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                EntryByName = Util.GetString(HttpContext.Current.Session["EmployeeName"].ToString()),
                IsActive = 1,
                CurrentHB = Vital.CurrentHB,
                Diagnosis = Vital.Diagnosis,
            });

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


    [WebMethod(EnableSession = true, Description = "Hemodialysis_Pre_Dialysis_Vital Update")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateHemodialysis_Pre_Dialysis_Vital(Hemodialysis_Pre_Dialysis_Vital Vital)
    {


        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string str = "update Hemodialysis_Pre_Dialysis_Vital  set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id=" + Util.GetInt(Vital.Id) + " ";
            int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);


            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  Hemodialysis_Pre_Dialysis_Vital ");
            sb.Append("  (TransactionId,PatientId,PreviousWeight,CurrentWeight, ");
            sb.Append(" WeightGain,DryWeight,BloodGroup,HivTest,HepatitisBSurfaceAg, ");
            sb.Append(" HeapatitisCAntiBody,BP,Pulse,Resp,Spo2,Temp,RBS, ");
            sb.Append(" ScreeingDate1,ScreeingDate2,ScreeingDate3,DateDone, ");
            sb.Append(" EntryBy,EntryByName,IsActive,CurrentHB,Diagnosis)  ");
            sb.Append(" values (@TransactionId,@PatientId,@PreviousWeight,@CurrentWeight, ");
            sb.Append(" @WeightGain,@DryWeight,@BloodGroup,@HivTest,@HepatitisBSurfaceAg, ");
            sb.Append(" @HeapatitisCAntiBody,@BP,@Pulse,@Resp,@Spo2,@Temp,@RBS, ");
            sb.Append(" @ScreeingDate1,@ScreeingDate2,@ScreeingDate3,@DateDone, ");
            sb.Append(" @EntryBy,@EntryByName,@IsActive,@CurrentHB,@Diagnosis)  ");
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                TransactionId = Vital.TransactionId,
                PatientId = Vital.PatientId,
                PreviousWeight = Vital.PreviousWeight,
                CurrentWeight = Vital.CurrentWeight,
                WeightGain = Vital.WeightGain,
                DryWeight = Vital.DryWeight,
                BloodGroup = Vital.BloodGroup,
                HivTest = Vital.HivTest,
                HepatitisBSurfaceAg = Vital.HepatitisBSurfaceAg,
                HeapatitisCAntiBody = Vital.HeapatitisCAntiBody,
                BP = Vital.BP,
                Pulse = Vital.Pulse,
                Resp = Vital.Resp,
                Spo2 = Vital.Spo2,
                Temp = Vital.Temp,
                RBS = Vital.RBS,
                ScreeingDate1 = Util.GetDateTime(Vital.ScreeingDate1).ToString("yyyy-MM-dd"),
                ScreeingDate2 = Util.GetDateTime(Vital.ScreeingDate2).ToString("yyyy-MM-dd"),
                ScreeingDate3 = Util.GetDateTime(Vital.ScreeingDate3).ToString("yyyy-MM-dd"),
                DateDone = Util.GetDateTime(Vital.DateDone).ToString("yyyy-MM-dd"),
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                EntryByName = Util.GetString(HttpContext.Current.Session["EmployeeName"].ToString()),
                IsActive = 1,
                CurrentHB = Vital.CurrentHB,
                Diagnosis=Vital.Diagnosis
            });

            CountSave += A;


            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Update Successfully" });

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
    public static string BindGrid(string Id)
    {

        StringBuilder sbnew = new StringBuilder();


        sbnew.Append(" SELECT DISTINCT t.EntryDate1 FROM (SELECT DATE_FORMAT(EntryDate,'%d/%m/%Y')EntryDate1 FROM Hemodialysis_Pre_Dialysis_Vital where PatientID='" + HttpContext.Current.Session["PID"].ToString() + "' and TransactionID='" + HttpContext.Current.Session["TID"].ToString() + "' ");
           sbnew.Append("UNION ALL ");
           sbnew.Append("SELECT DATE_FORMAT(EntryDate,'%d/%m/%Y')EntryDate1 FROM Hemodialysis_Dialysis_Order  where PatientID='" + HttpContext.Current.Session["PID"].ToString() + "' and TransactionID='" + HttpContext.Current.Session["TID"].ToString() + "'");
   sbnew.Append("UNION ALL ");
   sbnew.Append("SELECT DATE_FORMAT(EntryDate,'%d/%m/%Y')EntryDate1 FROM Hemodialysis_Machine_Check where PatientID='" + HttpContext.Current.Session["PID"].ToString() + "' and TransactionID='" + HttpContext.Current.Session["TID"].ToString() + "' ");
   sbnew.Append("UNION ALL ");
   sbnew.Append("SELECT DATE_FORMAT(EntryDate,'%d/%m/%Y')EntryDate1 FROM hemodialysis_dialysis_examination where PatientID='" + HttpContext.Current.Session["PID"].ToString() + "' and TransactionID='" + HttpContext.Current.Session["TID"].ToString() + "' ");
   sbnew.Append("UNION ALL ");
   sbnew.Append("SELECT DATE_FORMAT(EntryDate,'%d/%m/%Y')EntryDate1 FROM Hemodialysis_Intra_Dialytic_Observation where PatientID='" + HttpContext.Current.Session["PID"].ToString() + "' and TransactionID='" + HttpContext.Current.Session["TID"].ToString() + "' ");
   sbnew.Append("UNION ALL ");
   sbnew.Append("SELECT DATE_FORMAT(EntryDate,'%d/%m/%Y')EntryDate1 FROM Hemodialysis_Post_Dialytic_Observation where PatientID='" + HttpContext.Current.Session["PID"].ToString() + "' and TransactionID='" + HttpContext.Current.Session["TID"].ToString() + "') AS t order by t.EntryDate1 desc ");
        DataTable dt = StockReports.GetDataTable(sbnew.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn("LoginType");
            dc.DefaultValue = HttpContext.Current.Session["RoleID"].ToString();
            dt.Columns.Add(dc);
            DataView dv = dt.DefaultView;
            if (dv.ToTable().Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dv.ToTable());
            else
                return "";
        }
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string GetHemodialysis_Pre_Dialysis_Vital(string Pid, string Tid)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();


            sbnew.Append(" SELECT Id,TransactionId,PatientId,PreviousWeight,CurrentWeight,");
            sbnew.Append(" WeightGain,DryWeight,BloodGroup,HivTest,HepatitisBSurfaceAg,");
            sbnew.Append(" HeapatitisCAntiBody,BP,Pulse,Resp,Spo2,Temp,RBS,CurrentHB,");
            sbnew.Append(" DATE_FORMAT(hb.ScreeingDate1,'%d-%b-%Y')ScreeingDate1,DATE_FORMAT(hb.ScreeingDate2,'%d-%b-%Y')ScreeingDate2,");
            sbnew.Append("  DATE_FORMAT(hb.ScreeingDate3,'%d-%b-%Y')ScreeingDate3,DATE_FORMAT(hb.DateDone,'%d-%b-%Y')DateDone,Diagnosis ");
            sbnew.Append("  From Hemodialysis_Pre_Dialysis_Vital hb ");
            sbnew.Append("  WHERE hb.PatientId='" + Pid + "'  AND ");
            sbnew.Append("  hb.TransactionId='" + Tid + "' AND ");
            sbnew.Append("  hb.EntryDate>='" + Util.GetDateTime(DateTime.Now.Date).ToString("yyyy-MM-dd") + "' and hb.EntryDate<'" + Util.GetDateTime(DateTime.Now.Date.AddDays(1)).ToString("yyyy-MM-dd") + "' AND ");
            sbnew.Append(" hb.IsActive=1 order By Id Desc Limit 1  ");

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




    [WebMethod(EnableSession = true, Description = "Hemodialysis_Dialysis_Order")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveHemodialysis_Dialysis_Order(hemodialysis_dialysis_order Vital)
    {


        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  Hemodialysis_Dialysis_Order ");
            sb.Append("  ( TransactionId,PatientId,VascularAccessType, ");
            sb.Append(" TargetUltraFiltration,Duration,TreatmentType,BloodFlowRate, ");
            sb.Append(" Priming,DialysisSolution,DialyserType,MembraneType,BathK, ");
            sb.Append(" LoadingDose,UnitLitre,IsActive,EntryBy)  ");
            sb.Append(" values ( @TransactionId,@PatientId,@VascularAccessType, ");
            sb.Append(" @TargetUltraFiltration,@Duration,@TreatmentType,@BloodFlowRate, ");
            sb.Append(" @Priming,@DialysisSolution,@DialyserType,@MembraneType,@BathK, ");
            sb.Append(" @LoadingDose,@UnitLitre,@IsActive,@EntryBy)  ");
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                TransactionId = Vital.TransactionId,
                PatientId = Vital.PatientId,

                VascularAccessType = Vital.VascularAccessType,
                TargetUltraFiltration = Vital.TargetUltraFiltration,
                //Duration = Util.GetDateTime(Vital.Duration).ToString("HH:mm:ss"),
                Duration = Vital.Duration,
                TreatmentType = Vital.TreatmentType,
                BloodFlowRate = Vital.BloodFlowRate,
                Priming = Vital.Priming,
                DialysisSolution = Vital.DialysisSolution,
                DialyserType = Vital.DialyserType,
                MembraneType = Vital.MembraneType,
                BathK = Vital.BathK,
                LoadingDose = Vital.LoadingDose,
                UnitLitre = Vital.UnitLitre,
                IsActive = 1,
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString())


            });

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


    [WebMethod(EnableSession = true, Description = "Hemodialysis_Dialysis_Order Update")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateHemodialysis_Dialysis_Order(hemodialysis_dialysis_order Vital)
    {


        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string str = "update Hemodialysis_Dialysis_Order  set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id=" + Util.GetInt(Vital.Id) + " ";
            int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);


            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  Hemodialysis_Dialysis_Order ");
            sb.Append("  ( TransactionId,PatientId,VascularAccessType, ");
            sb.Append(" TargetUltraFiltration,Duration,TreatmentType,BloodFlowRate, ");
            sb.Append(" Priming,DialysisSolution,DialyserType,MembraneType,BathK, ");
            sb.Append(" LoadingDose,UnitLitre,IsActive,EntryBy)  ");
            sb.Append(" values ( @TransactionId,@PatientId,@VascularAccessType, ");
            sb.Append(" @TargetUltraFiltration,@Duration,@TreatmentType,@BloodFlowRate, ");
            sb.Append(" @Priming,@DialysisSolution,@DialyserType,@MembraneType,@BathK, ");
            sb.Append(" @LoadingDose,@UnitLitre,@IsActive,@EntryBy)  ");
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                TransactionId = Vital.TransactionId,
                PatientId = Vital.PatientId,

                VascularAccessType = Vital.VascularAccessType,
                TargetUltraFiltration = Vital.TargetUltraFiltration,
                Duration =Vital.Duration,
                TreatmentType = Vital.TreatmentType,
                BloodFlowRate = Vital.BloodFlowRate,
                Priming = Vital.Priming,
                DialysisSolution = Vital.DialysisSolution,
                DialyserType = Vital.DialyserType,
                MembraneType = Vital.MembraneType,
                BathK = Vital.BathK,
                LoadingDose = Vital.LoadingDose,
                UnitLitre = Vital.UnitLitre,
                IsActive = 1,
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString())


            });

            CountSave += A;


            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Update Successfully" });

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
    public static string GetHemodialysis_Dialysis_Order(string Pid, string Tid)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();


            sbnew.Append(" SELECT ");
            sbnew.Append(" Id,TransactionId,PatientId,VascularAccessType, ");
            //sbnew.Append(" TargetUltraFiltration,TIME_FORMAT(hb.Duration,'%I:%i %p') Duration,TreatmentType,BloodFlowRate, ");
            sbnew.Append(" TargetUltraFiltration,hb.Duration,TreatmentType,BloodFlowRate, ");
            sbnew.Append(" Priming,DialysisSolution,DialyserType,MembraneType,BathK, ");
            sbnew.Append(" LoadingDose,UnitLitre ");
            sbnew.Append("  From Hemodialysis_Dialysis_Order hb ");
            sbnew.Append("  WHERE hb.PatientId='" + Pid + "'  AND ");
            sbnew.Append("  hb.TransactionId='" + Tid + "' AND ");
            sbnew.Append("  hb.EntryDate>='" + Util.GetDateTime(DateTime.Now.Date).ToString("yyyy-MM-dd") + "' and hb.EntryDate<'" + Util.GetDateTime(DateTime.Now.Date.AddDays(1)).ToString("yyyy-MM-dd") + "' AND ");
            
            sbnew.Append(" hb.IsActive=1 order By Id Desc Limit 1  ");

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


    //Machine Check  Work
    [WebMethod(EnableSession = true, Description = "save Hemodialysis_Machine_Check")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveHemodialysis_Machine_Check(hemodialysis_machine_check Vital)
    {

        string BloodTestedOn = Util.GetDateTime(Vital.BloodTestedOn).ToString("yyyy-MM-dd");
        string AirTestedOn = Util.GetDateTime(Vital.AirTestedOn).ToString("yyyy-MM-dd");
           
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  Hemodialysis_Machine_Check ");
            sb.Append("  (TransactionId,PatientId,BloodLeakAssessment, ");
            sb.Append(" BloodTested,BloodTestedOn,AirDetaction,AirTested, ");
            sb.Append(" AirTestedOn,MachineNumber,Temprature, ");
            sb.Append(" Conductivity,StaffSettingMachine,NureseCommencingDialysis, ");
            sb.Append(" IsActive,EntryBy) ");
            sb.Append(" values  ( @TransactionId,@PatientId,@BloodLeakAssessment, ");
            sb.Append(" @BloodTested,@BloodTestedOn,@AirDetaction,@AirTested, ");
            sb.Append(" @AirTestedOn,@MachineNumber,@Temprature, ");
            sb.Append(" @Conductivity,@StaffSettingMachine,@NureseCommencingDialysis, ");
            sb.Append(" @IsActive,@EntryBy) ");

            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                TransactionId = Vital.TransactionId,
                PatientId = Vital.PatientId,
                BloodLeakAssessment = Vital.BloodLeakAssessment,
                BloodTested = Vital.BloodTested,
                BloodTestedOn = BloodTestedOn,
                AirDetaction = Vital.AirDetaction,
                AirTested = Vital.AirTested,
                AirTestedOn = AirTestedOn,
                MachineNumber = Vital.MachineNumber,
                Temprature = Vital.Temprature,
                Conductivity = Vital.Conductivity,
                StaffSettingMachine = Vital.StaffSettingMachine,
                NureseCommencingDialysis = Vital.NureseCommencingDialysis,

                IsActive = 1,
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString())

            });
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


    [WebMethod(EnableSession = true, Description = "Update Hemodialysis_Machine_Check")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateHemodialysis_Machine_Check(hemodialysis_machine_check Vital)
    {


        int CountSave = 0;
        string BloodTestedOn = Util.GetDateTime(Vital.BloodTestedOn).ToString("yyyy-MM-dd");
        string AirTestedOn = Util.GetDateTime(Vital.AirTestedOn).ToString("yyyy-MM-dd");
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string str = "update Hemodialysis_Machine_Check  set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id=" + Util.GetInt(Vital.Id) + " ";
            int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  Hemodialysis_Machine_Check ");
            sb.Append("  ( TransactionId,PatientId,BloodLeakAssessment, ");
            sb.Append(" BloodTested,BloodTestedOn,AirDetaction,AirTested, ");
            sb.Append(" AirTestedOn,MachineNumber,Temprature, ");
            sb.Append(" Conductivity,StaffSettingMachine,NureseCommencingDialysis, ");
            sb.Append(" IsActive,EntryBy) ");
            sb.Append(" values ( @TransactionId,@PatientId,@BloodLeakAssessment, ");
            sb.Append(" @BloodTested,@BloodTestedOn,@AirDetaction,@AirTested, ");
            sb.Append(" @AirTestedOn,@MachineNumber,@Temprature, ");
            sb.Append(" @Conductivity,@StaffSettingMachine,@NureseCommencingDialysis, ");
            sb.Append(" @IsActive,@EntryBy) ");
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                TransactionId = Vital.TransactionId,
                PatientId = Vital.PatientId,
                BloodLeakAssessment = Vital.BloodLeakAssessment,
                BloodTested = Vital.BloodTested,
                BloodTestedOn = BloodTestedOn,
                AirDetaction = Vital.AirDetaction,
                AirTested = Vital.AirTested,
                AirTestedOn = AirTestedOn,
                MachineNumber = Vital.MachineNumber,
                Temprature = Vital.Temprature,
                Conductivity = Vital.Conductivity,
                StaffSettingMachine = Vital.StaffSettingMachine,
                NureseCommencingDialysis = Vital.NureseCommencingDialysis,

                IsActive = 1,
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString())

            });

            CountSave += A;


            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Update Successfully" });

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
    public static string GetHemodialysis_Machine_Check(string Pid, string Tid)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();


            sbnew.Append(" SELECT ");
            sbnew.Append("  Id,TransactionId,PatientId,BloodLeakAssessment, ");
            sbnew.Append(" BloodTested,BloodTestedOn,AirDetaction,AirTested, ");
            sbnew.Append(" AirTestedOn,MachineNumber,Temprature, ");
            sbnew.Append(" Conductivity,StaffSettingMachine,NureseCommencingDialysis, ");
            sbnew.Append(" IsActive,DATE_FORMAT(BloodTestedOn, '%d %b %Y') as BloodTestedOn1,DATE_FORMAT(AirTestedOn, '%d %b %Y') as AirTestedOn1 ");

            sbnew.Append("  From Hemodialysis_Machine_Check hb ");

            sbnew.Append("  WHERE hb.PatientId='" + Pid + "'  AND ");
            sbnew.Append("  hb.TransactionId='" + Tid + "' AND ");
            sbnew.Append("  hb.EntryDate>='" + Util.GetDateTime(DateTime.Now.Date).ToString("yyyy-MM-dd") + "' and hb.EntryDate<'" + Util.GetDateTime(DateTime.Now.Date.AddDays(1)).ToString("yyyy-MM-dd") + "' AND ");
           
            sbnew.Append(" hb.IsActive=1 order By Id Desc Limit 1  ");

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


    // Machine Check Work End 



    // Hemodialysis_Dialysis_Examination Work Start

    [WebMethod(EnableSession = true, Description = "save Hemodialysis_Dialysis_Examination")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveHemodialysis_Dialysis_Examination(hemodialysis_dialysis_examination Vital)
    {


        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  hemodialysis_dialysis_examination ");

            sb.Append(" (TransactionId,PatientId,HistoryOfPresentingIllness,PreviousDialysisHistory,CNS,CVS,Resp,Renal, ");
            sb.Append(" Git,Skin,StatusOfTheAccess,NurshingDiagnosis,PlanOfCare,IsActive,EntryBy ) ");
            sb.Append(" values (@TransactionId,@PatientId,@HistoryOfPresentingIllness,@PreviousDialysisHistory,@CNS,@CVS,@Resp,@Renal, ");
            sb.Append(" @Git,@Skin,@StatusOfTheAccess,@NurshingDiagnosis,@PlanOfCare,@IsActive,@EntryBy ) ");
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                TransactionId = Vital.TransactionId,
                PatientId = Vital.PatientId,

                HistoryOfPresentingIllness = Vital.HistoryOfPresentingIllness,
                PreviousDialysisHistory = Vital.PreviousDialysisHistory,
                CNS = Vital.CNS,
                CVS = Vital.CVS,
                Resp = Vital.Resp,
                Renal = Vital.Renal,
                Git = Vital.Git,
                Skin = Vital.Skin,
                StatusOfTheAccess = Vital.StatusOfTheAccess,
                NurshingDiagnosis = Vital.NurshingDiagnosis,
                PlanOfCare = Vital.PlanOfCare,
                IsActive = 1,
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString())


            });
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


    [WebMethod(EnableSession = true, Description = "Update Hemodialysis_Dialysis_Examination")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateHemodialysis_Dialysis_Examination(hemodialysis_dialysis_examination Vital)
    {


        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string str = "update Hemodialysis_Dialysis_Examination  set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id=" + Util.GetInt(Vital.Id) + " ";
            int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  hemodialysis_dialysis_examination ");

            sb.Append(" (TransactionId,PatientId,HistoryOfPresentingIllness,PreviousDialysisHistory,CNS,CVS,Resp,Renal, ");
            sb.Append(" Git,Skin,StatusOfTheAccess,NurshingDiagnosis,PlanOfCare,IsActive,EntryBy ) ");
            sb.Append(" values (@TransactionId,@PatientId,@HistoryOfPresentingIllness,@PreviousDialysisHistory,@CNS,@CVS,@Resp,@Renal, ");
            sb.Append(" @Git,@Skin,@StatusOfTheAccess,@NurshingDiagnosis,@PlanOfCare,@IsActive,@EntryBy ) ");
            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                TransactionId = Vital.TransactionId,
                PatientId = Vital.PatientId,

                HistoryOfPresentingIllness = Vital.HistoryOfPresentingIllness,
                PreviousDialysisHistory = Vital.PreviousDialysisHistory,
                CNS = Vital.CNS,
                CVS = Vital.CVS,
                Resp = Vital.Resp,
                Renal = Vital.Renal,
                Git = Vital.Git,
                Skin = Vital.Skin,
                StatusOfTheAccess = Vital.StatusOfTheAccess,
                NurshingDiagnosis = Vital.NurshingDiagnosis,
                PlanOfCare = Vital.PlanOfCare,
                IsActive = 1,
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString())


            });
            CountSave += A;


            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Update Successfully" });

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
    public static string GetHemodialysis_Dialysis_Examination(string Pid, string Tid)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();


            sbnew.Append(" SELECT ");

            sbnew.Append("Id,TransactionId,PatientId,HistoryOfPresentingIllness,PreviousDialysisHistory,CNS,CVS,Resp,Renal, ");

            sbnew.Append("Git,Skin,StatusOfTheAccess,NurshingDiagnosis,PlanOfCare,IsActive,EntryBy,EntryDate,UpdateBy,UpdateDate ");

            sbnew.Append("  From Hemodialysis_Dialysis_Examination hb ");

            sbnew.Append("  WHERE hb.PatientId='" + Pid + "'  AND ");
            sbnew.Append("  hb.TransactionId='" + Tid + "' AND ");
             sbnew.Append("  hb.EntryDate>='" + Util.GetDateTime(DateTime.Now.Date).ToString("yyyy-MM-dd") + "' and hb.EntryDate<'" + Util.GetDateTime(DateTime.Now.Date.AddDays(1)).ToString("yyyy-MM-dd") + "' AND ");

             sbnew.Append(" hb.IsActive=1 order By Id Desc Limit 1  ");

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


    // Hemodialysis_Dialysis_Examination Work End






    // Hemodialysis_Post_Dialytic_Observation Work Start

    [WebMethod(EnableSession = true, Description = "save Hemodialysis_Post_Dialytic_Observation")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveHemodialysis_Post_Dialytic_Observation(hemodialysis_post_dialytic_observation Vital)
    {


        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  Hemodialysis_Post_Dialytic_Observation ");
            sb.Append("   (TransactionId,PatientId,HoursDialyzed,BP,Pulse,UFAchieved,Weight, ");
            sb.Append(" BloodTransfusion,ComplicationDuringDialysis,SpecialOrder,IsActive,EntryBy) ");
            sb.Append("  values (@TransactionId,@PatientId,@HoursDialyzed,@BP,@Pulse,@UFAchieved,@Weight, ");
            sb.Append(" @BloodTransfusion,@ComplicationDuringDialysis,@SpecialOrder,@IsActive,@EntryBy) ");

            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                TransactionId = Vital.TransactionId,
                PatientId = Vital.PatientId,

                HoursDialyzed = Vital.HoursDialyzed,
                BP = Vital.BP,
                Pulse = Vital.Pulse,
                UFAchieved = Vital.UFAchieved,
                Weight = Vital.Weight,
                BloodTransfusion = Vital.BloodTransfusion,
                ComplicationDuringDialysis = Vital.ComplicationDuringDialysis,
                SpecialOrder = Vital.SpecialOrder,
                IsActive = 1,
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString())

            });
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


    [WebMethod(EnableSession = true, Description = "Update Hemodialysis_Post_Dialytic_Observation")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateHemodialysis_Post_Dialytic_Observation(hemodialysis_post_dialytic_observation Vital)
    {


        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string str = "update Hemodialysis_Post_Dialytic_Observation  set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE Id=" + Util.GetInt(Vital.Id) + " ";
            int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            StringBuilder sb = new StringBuilder();


            sb.Append(" INSERT INTO  Hemodialysis_Post_Dialytic_Observation ");
            sb.Append("   (TransactionId,PatientId,HoursDialyzed,BP,Pulse,UFAchieved,Weight, ");
            sb.Append(" BloodTransfusion,ComplicationDuringDialysis,SpecialOrder,IsActive,EntryBy) ");
            sb.Append("  values (@TransactionId,@PatientId,@HoursDialyzed,@BP,@Pulse,@UFAchieved,@Weight, ");
            sb.Append(" @BloodTransfusion,@ComplicationDuringDialysis,@SpecialOrder,@IsActive,@EntryBy) ");

            int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {
                TransactionId = Vital.TransactionId,
                PatientId = Vital.PatientId,

                HoursDialyzed = Vital.HoursDialyzed,
                BP = Vital.BP,
                Pulse = Vital.Pulse,
                UFAchieved = Vital.UFAchieved,
                Weight = Vital.Weight,
                BloodTransfusion = Vital.BloodTransfusion,
                ComplicationDuringDialysis = Vital.ComplicationDuringDialysis,
                SpecialOrder = Vital.SpecialOrder,
                IsActive = 1,
                EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString())

            });
            CountSave += A;


            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Update Successfully" });

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
    public static string GetHemodialysis_Post_Dialytic_Observation(string Pid, string Tid)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();


            sbnew.Append(" SELECT ");

            sbnew.Append(" Id,TransactionId,PatientId,HoursDialyzed,BP,Pulse,UFAchieved,Weight, ");
            sbnew.Append("BloodTransfusion,ComplicationDuringDialysis,SpecialOrder,IsActive  ");

            sbnew.Append("  From Hemodialysis_Post_Dialytic_Observation hb ");

            sbnew.Append("  WHERE hb.PatientId='" + Pid + "'  AND ");
            sbnew.Append("  hb.TransactionId='" + Tid + "' AND ");
            sbnew.Append("  hb.EntryDate>='" + Util.GetDateTime(DateTime.Now.Date).ToString("yyyy-MM-dd") + "' and hb.EntryDate<'" + Util.GetDateTime(DateTime.Now.Date.AddDays(1)).ToString("yyyy-MM-dd") + "' AND ");
           
            sbnew.Append(" hb.IsActive=1 order By Id Desc Limit 1  ");

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


    // Hemodialysis_Post_Dialytic_Observation Work End






    // Hemodialysis_Intra_Dialytic_Observation Work Start

    [WebMethod(EnableSession = true, Description = "save Hemodialysis_Intra_Dialytic_Observation")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveHemodialysis_Intra_Dialytic_Observation(List<hemodialysis_intra_dialytic_observation> Vital)
    {


        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            foreach (var item in Vital)
            {
                StringBuilder sb = new StringBuilder();


                sb.Append(" INSERT INTO  Hemodialysis_Intra_Dialytic_Observation ");
                sb.Append("   (TransactionId,PatientId,Time,BP,");
                sb.Append("HR,Temp,VP,AP,TMP,UF,Heparin,");
                sb.Append("BFR,REMARK,IsActive,EntryBy,EntryByName) ");
                sb.Append(" VALUES  (@TransactionId,@PatientId,@Time,@BP,");
                sb.Append("@HR,@Temp,@VP,@AP,@TMP,@UF,@Heparin,");
                sb.Append("@BFR,@REMARK,@IsActive,@EntryBy,@EntryByName) ");
                int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    TransactionId = item.TransactionId,
                    PatientId = item.PatientId,
                    Time = Util.GetDateTime(item.Time).ToString("HH:mm:ss"),
                    BP = item.BP,
                    HR = item.HR,
                    Temp = item.Temp,
                    VP = item.VP,
                    AP = item.AP,
                    TMP = item.TMP,
                    UF = item.UF,
                    Heparin = item.Heparin,
                    BFR = item.BFR,
                    REMARK = item.REMARK, 
                    IsActive = 1,
                    EntryBy = Util.GetString(HttpContext.Current.Session["ID"].ToString()),
                    EntryByName = Util.GetString(HttpContext.Current.Session["EmployeeName"].ToString()),

                });


                CountSave += A;

            }

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


    [WebMethod(EnableSession = true, Description = "Update Hemodialysis_Intra_Dialytic_Observation")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateHemodialysis_Intra_Dialytic_Observation(List<hemodialysis_intra_dialytic_observation> Vital)
    {


        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            string str = "update Hemodialysis_Intra_Dialytic_Observation  set IsActive=0,UpdateBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate=NOW()  WHERE TransactionId='" + Vital[0].TransactionId + "' and PatientId='" + Vital[0].PatientId + "' ";
            int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            

            foreach (var item in Vital)
            {

                StringBuilder sb = new StringBuilder();
                string entryby = "";
                string entryname = "";
                if (item.EntryBy != Util.GetString(HttpContext.Current.Session["ID"].ToString()))
                {
                    entryby = item.EntryBy;
                    entryname = item.EntryName;
                }
                else
                {
                    entryby = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                    entryname=Util.GetString(HttpContext.Current.Session["EmployeeName"].ToString());
                }

                sb.Append(" INSERT INTO  Hemodialysis_Intra_Dialytic_Observation ");
                sb.Append("   (TransactionId,PatientId,Time,BP,");
                sb.Append("HR,Temp,VP,AP,TMP,UF,Heparin,");
                sb.Append("BFR,REMARK,IsActive,EntryBy,EntryByName) ");
                sb.Append(" VALUES  (@TransactionId,@PatientId,@Time,@BP,");
                sb.Append("@HR,@Temp,@VP,@AP,@TMP,@UF,@Heparin,");
                sb.Append("@BFR,@REMARK,@IsActive,@EntryBy,@EntryByName) ");
                int A = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
                {
                    TransactionId = item.TransactionId,
                    PatientId = item.PatientId,
                    Time = Util.GetDateTime(item.Time).ToString("HH:mm:ss"),
                    BP = item.BP,
                    HR = item.HR,
                    Temp = item.Temp,
                    VP = item.VP,
                    AP = item.AP,
                    TMP = item.TMP,
                    UF = item.UF,
                    Heparin = item.Heparin,
                    BFR = item.BFR,
                    REMARK = item.REMARK,

                    IsActive = 1,
                    EntryBy = entryby,
                    EntryByName = entryname,

                });


                CountSave += A;

            }
            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Update Successfully" });

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
    public static string GetHemodialysis_Intra_Dialytic_Observation(string Pid, string Tid)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();


            sbnew.Append(" SELECT ");
            sbnew.Append(" Id,TransactionId,PatientId,TIME_FORMAT(hb.Time,'%I:%i %p')Time,BP,HR,Temp,VP,AP,TMP,UF,Heparin,");
            sbnew.Append(" BFR,REMARK,IsActive,EntryBy,EntryByName ");


            sbnew.Append("  From Hemodialysis_Intra_Dialytic_Observation hb ");

            sbnew.Append("  WHERE hb.PatientId='" + Pid + "'  AND ");
            sbnew.Append("  hb.TransactionId='" + Tid + "' AND ");
            sbnew.Append("  hb.EntryDate>='" + Util.GetDateTime(DateTime.Now.Date).ToString("yyyy-MM-dd") + "' and hb.EntryDate<'" + Util.GetDateTime(DateTime.Now.Date.AddDays(1)).ToString("yyyy-MM-dd") + "' AND ");
           
            sbnew.Append(" hb.IsActive=1  ");

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


    // Hemodialysis_Intra_Dialytic_Observation Work End


















    public class Hemodialysis_Pre_Dialysis_Vital
    {

        public int Id { get; set; }
        public string PatientId { get; set; }
        public string TransactionId { get; set; }

        public string PreviousWeight { get; set; }
        public string CurrentWeight { get; set; }
        public string WeightGain { get; set; }
        public string DryWeight { get; set; }
        public string BloodGroup { get; set; }
        public string HivTest { get; set; }
        public string HepatitisBSurfaceAg { get; set; }
        public string HeapatitisCAntiBody { get; set; }
        public string BP { get; set; }
        public string Pulse { get; set; }
        public string Resp { get; set; }
        public string Spo2 { get; set; }
        public string Temp { get; set; }
        public string RBS { get; set; }
        public string ScreeingDate1 { get; set; }
        public string ScreeingDate2 { get; set; }
        public string ScreeingDate3 { get; set; }
        public string DateDone { get; set; }
        public string CurrentHB { get; set; }
        public string Diagnosis { get; set; }
    }

    public class hemodialysis_dialysis_order
    {

        public int Id { get; set; }
        public string PatientId { get; set; }
        public string TransactionId { get; set; }
        public string VascularAccessType { get; set; }
        public string TargetUltraFiltration { get; set; }
        public string Duration { get; set; }
        public string TreatmentType { get; set; }
        public string BloodFlowRate { get; set; }
        public string Priming { get; set; }
        public string DialysisSolution { get; set; }
        public string DialyserType { get; set; }
        public string MembraneType { get; set; }
        public string BathK { get; set; }
        public string LoadingDose { get; set; }
        public string UnitLitre { get; set; }

    }

    public class hemodialysis_machine_check
    {

        public int Id { get; set; }
        public string PatientId { get; set; }
        public string TransactionId { get; set; }

        public string BloodLeakAssessment { get; set; }
        public string BloodTested { get; set; }
        public string BloodTestedOn { get; set; }
        public string AirDetaction { get; set; }
        public string AirTested { get; set; }
        public string AirTestedOn { get; set; }
        public string MachineNumber { get; set; }
        public string Temprature { get; set; }
        public string Conductivity { get; set; }
        public string StaffSettingMachine { get; set; }
        public string NureseCommencingDialysis { get; set; }
        public string IsActive { get; set; }



    }


    public class hemodialysis_dialysis_examination
    {

        public int Id { get; set; }
        public string PatientId { get; set; }
        public string TransactionId { get; set; }

        public string HistoryOfPresentingIllness { get; set; }
        public string PreviousDialysisHistory { get; set; }
        public string CNS { get; set; }
        public string CVS { get; set; }
        public string Resp { get; set; }
        public string Renal { get; set; }
        public string Git { get; set; }
        public string Skin { get; set; }
        public string StatusOfTheAccess { get; set; }
        public string NurshingDiagnosis { get; set; }
        public string PlanOfCare { get; set; }
        public string IsActive { get; set; }



    }


    public class hemodialysis_intra_dialytic_observation
    {

        public int Id { get; set; }
        public string PatientId { get; set; }
        public string TransactionId { get; set; }

        public string Time { get; set; }
        public string BP { get; set; }
        public string HR { get; set; }
        public string Temp { get; set; }
        public string VP { get; set; }
        public string AP { get; set; }
        public string TMP { get; set; }
        public string UF { get; set; }
        public string Heparin { get; set; }
        public string BFR { get; set; }
        public string REMARK { get; set; }
        public string EntryBy { get; set; }
        public string EntryName { get; set; }

    }
    public class hemodialysis_post_dialytic_observation
    {

        public int Id { get; set; }
        public string PatientId { get; set; }
        public string TransactionId { get; set; }
        public string HoursDialyzed { get; set; }
        public string BP { get; set; }
        public string Pulse { get; set; }
        public string UFAchieved { get; set; }
        public string Weight { get; set; }
        public string BloodTransfusion { get; set; }
        public string ComplicationDuringDialysis { get; set; }
        public string SpecialOrder { get; set; }

    }



}