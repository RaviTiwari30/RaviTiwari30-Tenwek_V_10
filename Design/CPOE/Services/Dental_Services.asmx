<%@ WebService Language="C#" CodeBehind="~/App_Code/Dental_Services.cs" Class="Dental_Services" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Script.Services;
using System.Web.Script;

/// <summary>
/// Summary description for Dental_Services
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Dental_Services : System.Web.Services.WebService {

    public Dental_Services () {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string SaveStep(object ProData)
    {
        List<ProcedureMaster> dataPro = new JavaScriptSerializer().ConvertToType<List<ProcedureMaster>>(ProData);
        MySql.Data.MySqlClient.MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Update = "UPDATE den_procedure_steps SET IsActive=0 WHERE ItemID='" + dataPro[0].ItemID + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Update);
            for (int i = 0; i < dataPro.Count; i++)
            {
                string str = "INSERT INTO den_procedure_steps (ItemID,StepID,SeqNo,Per,Amount,DAY,IsActive)VALUES('" + dataPro[i].ItemID + "','" + dataPro[i].StepID + "','" + dataPro[i].SeqNo + "','" + dataPro[i].Per + "','" + dataPro[i].Amount + "','" + dataPro[i].Day + "',1)";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            return "0";
        }
        finally {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
           
    }
     [WebMethod]
    public string SaveStemMaster(string StepName, string ID, int Status)
    {
        int count = 0;
        if (ID == string.Empty)
        {
            count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM den_step_master WHERE UPPER(Name)=UPPER('" + StepName + "');"));
        }
        else { count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM den_step_master WHERE UPPER(Name)=UPPER('" + StepName + "') AND ID<>" + ID + ";")); }
        if (count == 0)
        {
            string str = "";
            if (ID == string.Empty)
            {
                str = "INSERT INTO den_step_master(Name,ISActive)VALUE('" + StepName + "',1)";
            }
            else { str = "UPDATE den_step_master SET NAME='" + StepName + "',ISActive='" + Status + "' WHERE ID='" + ID + "'"; }
            if (StockReports.ExecuteDML(str))
            {
                return "1";
            }
            else
                return "0";
        }
         else
        return "2";
    }
     [WebMethod]
     public string BindProcedure()
     {
         string str = "SELECT im.`ItemID`,im.`TypeName` FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=im.`SubCategoryID`"+
                     " INNER JOIN f_categorymaster cm ON cm.`CategoryID`=sc.`CategoryID` WHERE cm.`CategoryID`='LSHHI6'";
         DataTable dt = StockReports.GetDataTable(str);
         if (dt.Rows.Count > 0)
         { return Newtonsoft.Json.JsonConvert.SerializeObject(dt); }
         else
         {
             return "";
         }
     }
     [WebMethod]
     public string BindStep()
     {
         string str = "SELECT * FROM den_step_master";

         DataTable dt = StockReports.GetDataTable(str);
         if (dt.Rows.Count > 0)
         { return Newtonsoft.Json.JsonConvert.SerializeObject(dt); }
         else
         {
             return "";
         }
     }
     [WebMethod]
     public string BindStepMaster(string ItemId)
     {
         string str = "SELECT * FROM den_procedure_steps  WHERE IsActive=1 AND ItemID='" + ItemId + "'";

         DataTable dt = StockReports.GetDataTable(str);
         if (dt.Rows.Count > 0)
         { return Newtonsoft.Json.JsonConvert.SerializeObject(dt); }
         else
         {
             return "";
         }
     }
     [WebMethod]
     public string LoadRate(string ItemId)
     {
       DataTable dt= AllLoadData_OPD.GetItem(ItemId,"1");
       if (dt.Rows.Count > 0)
       {
           return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
       }
       else { return ""; }
     }
        [WebMethod(EnableSession = true)]
     public string SaveDentalHistory(string DentalID, string PID, string TID, string ChifComment, string PHMComment, string PDHComment, int IsAsthma, int IsHepatities, int IsMurmur, int IsPregnent, int IsSickle, int IsDiabetes, int IsHypertension, int IsNursing, int IsRHD, int IsStrock, int IsDrugRxn, int IsHypotension, string IsOral, string IsSerious, int IsBadbreath, int IsCanker, int IsDental, int IsGum, int IsOrthodontic, int IsPrevious, int IsToothaches, int IsBleeding, int IsClicking, int IsDifficult, int IsMissing, int IsPain, int IsRCT, int IsBridge, int IsCrowns, int IsGrinding, int IsMouthS, int IsPainInChewing, int IsScaling)
     {
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try
         {
             var UserID = HttpContext.Current.Session["ID"].ToString();
             var IpAddress = HttpContext.Current.Request.UserHostAddress;
             var ID = 0;
             var message = "";
             //string str = "";
             //string str = "SELECT COUNT(*) FROM eq_asset_subcategory_master WHERE  Patient_Id = '" + SubCategoryName + "' and CategoryID= '" + CategoryID + "' and GroupID= '" + GroupID + "'";
             //if (DentalID != "")
             //    str = " and ID<>'" + DentalID + "' ";

             //var IsExist = Util.GetInt(StockReports.ExecuteScalar(str));
             //if (IsExist > 0)
             //{
             //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Category Already Exists" });
             //}

             if (DentalID == "")
             {
                 string sqlCMD = "INSERT INTO cpoe_dental_history (Patient_Id,Transaction_ID,ChiefComplaint,PmhComments,PdhComments, IsAsthma,IsHepatities,IsMurmur,IsPregnent,CreatedBy,IsSickleCellDX,IsDiabetes, IsHypertension,IsNursingMother,IsRHD,IsStrock,IsDrugRxn,IsHypotension,IsOralContraceptive,IsSeriousIllness,IsBadbreath,IsCankerSores,IsDentalCheckups,IsGumSurgery,IsOrthodonticRx,IsPreviousExtraction,IsToothaches,IsBleedingGums,IsClickingofTMJ,IsDifficultExt,IsMissingTeeth,IsPaininNearEar,IsRCT,IsBridgeWork,IsCrowns,IsGrindingOfteeth,IsMouthSours,IsPainInChewing,IsScalingandPolishing)  VALUES(@Patient_Id,@Transaction_ID,@ChiefComplaint,@PmhComments,@PdhComments, @IsAsthma,@IsHepatities,@IsMurmur,@IsPregnent,@CreatedBy,@IsSickleCellDX,@IsDiabetes, @IsHypertension,@IsNursingMother,@IsRHD,@IsStrock,@IsDrugRxn,@IsHypotension,@IsOralContraceptive,@IsSeriousIllness,@IsBadbreath,@IsCankerSores,@IsDentalCheckups,@IsGumSurgery,@IsOrthodonticRx,@IsPreviousExtraction,@IsToothaches,@IsBleedingGums,@IsClickingofTMJ,@IsDifficultExt,@IsMissingTeeth,@IsPaininNearEar,@IsRCT,@IsBridgeWork,@IsCrowns,@IsGrindingOfteeth,@IsMouthSours,@IsPainInChewing,@IsScalingandPolishing);";
                 ID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                 {
                     Patient_Id = PID,
                     Transaction_ID = TID,
                     ChiefComplaint = ChifComment,
                     CreatedBy = UserID,
                     PmhComments = PHMComment,
                     PdhComments = PDHComment,
                     IsAsthma = IsAsthma,
                     IsHepatities = IsHepatities,
                     IsMurmur = IsMurmur,
                     IsPregnent = IsPregnent,
                     IsSickleCellDX = IsSickle,
                     IsDiabetes = IsDiabetes,
                     IsHypertension = IsHypertension,
                     IsNursingMother = IsNursing,
                     IsRHD = IsRHD,
                     IsStrock = IsStrock,
                     IsDrugRxn = IsDrugRxn,
                     IsHypotension = IsHypotension,
                     IsOralContraceptive = IsOral,
                     IsSeriousIllness = IsSerious,
                     IsBadbreath = IsBadbreath,
                     IsCankerSores = IsCanker,
                     IsDentalCheckups = IsDental,
                     IsGumSurgery = IsGum,
                     IsOrthodonticRx = IsOrthodontic,
                     IsPreviousExtraction = IsPrevious,
                     IsToothaches = IsToothaches,
                     IsBleedingGums = IsBleeding,
                     IsClickingofTMJ = IsClicking,
                     IsDifficultExt = IsDifficult,
                     IsMissingTeeth = IsMissing,
                     IsPaininNearEar = IsPain,
                     IsRCT = IsRCT,
                     IsBridgeWork = IsBridge,
                     IsCrowns = IsCrowns,
                     IsGrindingOfteeth = IsGrinding,
                     IsMouthSours = IsMouthS,
                     IsPainInChewing = IsPainInChewing,
                     IsScalingandPolishing = IsScaling,
                 }));


                 //SubcategoryID = excuteCMD.GetRowQuery(sqlCMD, new
                 //{
                 //    SubCategoryName = SubCategoryName,
                 //    GroupID = GroupID,
                 //    CategoryID = CategoryID,
                 //    CreatedBy = UserID,
                 //    ShowBarcodeNumber = ShowBarcodeNumber,
                 //    IsActive = IsActive,
                 //    ShowInvestigationID = ShowInvestigationID,
                 //    ShowPatientID = ShowPatientID,
                 //    ShowVisitNo = ShowVisitNo,
                 //    ShowDepartment = ShowDepartment,
                 //    MandatoryBarcodeNumber = MandatoryBarcodeNumber,
                 //    MandatoryInvestigationID = MandatoryInvestigationID,
                 //    MandatoryPatientID = MandatoryPatientID,
                 //    MandatoryVisitNo = MandatoryVisitNo,
                 //    MandatoryDepartment = MandatoryDepartment,
                 //    ShowLocation = ShowLocation,
                 //    ShowInstrument = ShowInstrument,
                 //    MandatoryLocation = MandatoryLocation,
                 //    MandatoryInstrument = MandatoryInstrument

                 //});
                 message = "Record Save Successfully";
             }
             else
             {


                 string sqlCMD = "UPDATE cpoe_dental_history SET Patient_Id=@Patient_Id,Transaction_ID=@Transaction_ID,ChiefComplaint=@ChiefComplaint,PmhComments=@PmhComments,PdhComments=@PdhComments, IsAsthma=@IsAsthma,IsHepatities=@IsHepatities,IsMurmur=@IsMurmur,IsPregnent=@IsPregnent,IsSickleCellDX=@IsSickleCellDX,IsDiabetes=@IsDiabetes, IsHypertension=@IsHypertension,IsNursingMother=@IsNursingMother,IsRHD=@IsRHD,IsStrock=@IsStrock,IsDrugRxn=@IsDrugRxn,IsHypotension=@IsHypotension,IsOralContraceptive=@IsOralContraceptive,IsSeriousIllness=@IsSeriousIllness, IsBadbreath=@IsBadbreath,IsCankerSores=@IsCankerSores,IsDentalCheckups=@IsDentalCheckups,IsGumSurgery=@IsGumSurgery,IsOrthodonticRx=@IsOrthodonticRx,IsPreviousExtraction=@IsPreviousExtraction,IsToothaches=@IsToothaches,IsBleedingGums=@IsBleedingGums,IsClickingofTMJ=@IsClickingofTMJ,IsDifficultExt=@IsDifficultExt,IsMissingTeeth=@IsMissingTeeth, IsPaininNearEar=@IsPaininNearEar,IsRCT=@IsRCT,IsBridgeWork=@IsBridgeWork,IsCrowns=@IsCrowns,IsGrindingOfteeth=@IsGrindingOfteeth,IsMouthSours=@IsMouthSours,IsPainInChewing=@IsPainInChewing,IsScalingandPolishing=@IsScalingandPolishing,UpdatedBy = @UpdatedBy,UpdatedDate = Now() WHERE ID = @ID ";
                 excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                 //excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                 {
                     Patient_Id = PID,
                     Transaction_ID = TID,
                     ChiefComplaint = ChifComment,
                     UpdatedBy = UserID,
                     PmhComments = PHMComment,
                     PdhComments = PDHComment,
                     IsAsthma = IsAsthma,
                     IsHepatities = IsHepatities,
                     IsMurmur = IsMurmur,
                     IsPregnent = IsPregnent,
                     IsSickleCellDX = IsSickle,
                     IsDiabetes = IsDiabetes,
                     IsHypertension = IsHypertension,
                     IsNursingMother = IsNursing,
                     IsRHD = IsRHD,
                     IsStrock = IsStrock,
                     IsDrugRxn = IsDrugRxn,
                     IsHypotension = IsHypotension,
                     IsOralContraceptive = IsOral,
                     IsSeriousIllness = IsSerious,
                     IsBadbreath = IsBadbreath,
                     IsCankerSores = IsCanker,
                     IsDentalCheckups = IsDental,
                     IsGumSurgery = IsGum,
                     IsOrthodonticRx = IsOrthodontic,
                     IsPreviousExtraction = IsPrevious,
                     IsToothaches = IsToothaches,
                     IsBleedingGums = IsBleeding,
                     IsClickingofTMJ = IsClicking,
                     IsDifficultExt = IsDifficult,
                     IsMissingTeeth = IsMissing,
                     IsPaininNearEar = IsPain,
                     IsRCT = IsRCT,
                     IsBridgeWork = IsBridge,
                     IsCrowns = IsCrowns,
                     IsGrindingOfteeth = IsGrinding,
                     IsMouthSours = IsMouthS,
                     IsPainInChewing = IsPainInChewing,
                     IsScalingandPolishing = IsScaling,
                     ID = DentalID,
                 });
                 message = "Record Updated Successfully";
             }







             tnx.Commit();
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
         }
         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog objClassLog = new ClassLog();
             objClassLog.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
     }

     [WebMethod]
     public string BindDentalHistoryDetails(string PID, string TID)
     {
         StringBuilder sb = new StringBuilder();
         sb.Append("SELECT pdh.ID AS DId,pdh.Patient_Id AS PID,pdh.ChiefComplaint,pdh.PmhComments,pdh.PdhComments, ");
         sb.Append("IF(pdh.IsAsthma=1,'Yes','No')IsAsthma, IF(pdh.IsHepatities=1,'Yes','No')IsHepatities,");
         sb.Append("IF(pdh.IsMurmur=1,'Yes','No')IsMurmur, IF(pdh.IsPregnent=1,'Yes','No')IsPregnent,");
         sb.Append("IF(pdh.IsSickleCellDX=1,'Yes','No')IsSickleCellDX, IF(pdh.IsDiabetes=1,'Yes','No')IsDiabetes,");
         sb.Append("IF(pdh.IsHypertension=1,'Yes','No')IsHypertension,IF(pdh.IsNursingMother=1,'Yes','No')IsNursingMother, ");

         sb.Append("IF(pdh.IsRHD=1,'Yes','No')IsRHD, IF(pdh.IsStrock=1,'Yes','No')IsStrock,");
         sb.Append("IF(pdh.IsDrugRxn=1,'Yes','No')IsDrugRxn, IF(pdh.IsHypotension=1,'Yes','No')IsHypotension,");
         sb.Append("IF(pdh.IsOralContraceptive=1,'Yes','No')IsOralContraceptive, IF(pdh.IsSeriousIllness=1,'Yes','No')IsSeriousIllness,");
         sb.Append("IF(pdh.IsBadbreath=1,'Yes','No')IsBadbreath,IF(pdh.IsCankerSores=1,'Yes','No')IsCankerSores, ");

         sb.Append("IF(pdh.IsDentalCheckups=1,'Yes','No')IsDentalCheckups, IF(pdh.IsGumSurgery=1,'Yes','No')IsGumSurgery,");
         sb.Append("IF(pdh.IsOrthodonticRx=1,'Yes','No')IsOrthodonticRx, IF(pdh.IsPreviousExtraction=1,'Yes','No')IsPreviousExtraction,");
         sb.Append("IF(pdh.IsToothaches=1,'Yes','No')IsToothaches, IF(pdh.IsBleedingGums=1,'Yes','No')IsBleedingGums,");
         sb.Append("IF(pdh.IsClickingofTMJ=1,'Yes','No')IsClickingofTMJ,IF(pdh.IsDifficultExt=1,'Yes','No')IsDifficultExt, ");

         sb.Append("IF(pdh.IsMissingTeeth=1,'Yes','No')IsMissingTeeth, IF(pdh.IsPaininNearEar=1,'Yes','No')IsPaininNearEar,");
         sb.Append("IF(pdh.IsRCT=1,'Yes','No')IsRCT, IF(pdh.IsBridgeWork=1,'Yes','No')IsBridgeWork,");
         sb.Append("IF(pdh.IsCrowns=1,'Yes','No')IsCrowns, IF(pdh.IsGrindingOfteeth=1,'Yes','No')IsGrindingOfteeth,");
         sb.Append("IF(pdh.IsMouthSours=1,'Yes','No')IsMouthSours,IF(pdh.IsPainInChewing=1,'Yes','No')IsPainInChewing, ");
         sb.Append("IF(pdh.IsScalingandPolishing=1,'Yes','No')IsScalingandPolishing, ");

         sb.Append("CONCAT(CONCAT(em.Title,em.Name))CreatedBy , ");
         sb.Append("DATE_FORMAT(pdh.CreatedDate,'%d-%b-%Y')DateTime , ");
         sb.Append("CONCAT(IFNULL((SELECT CONCAT(title,'',NAME) FROM employee_master WHERE employeeid=pdh.UpdatedBy),''),' ',IFNULL(DATE_FORMAT(pdh.UpdatedDate,'%d-%b-%Y'),''))LastUpdateBy ");
         sb.Append("FROM cpoe_dental_history pdh  ");
         sb.Append("INNER JOIN employee_master em ON em.EmployeeID= pdh.CreatedBy ");
         sb.Append("  WHERE pdh.Patient_Id='" + PID + "'  and pdh.Transaction_ID='" + TID + "' ");

         //sb.Append(" Order By SubCategoryName ");

         return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
     }
        [WebMethod]
     public string BindTeethMaster()
     {

         StringBuilder sb = new StringBuilder();
         sb.Append("SELECT Id,TeethName AS Name from cpoe_teeth_master where IsActive=1 and  GroupId=1;");
         DataTable dtteeth = StockReports.GetDataTable(sb.ToString());
         sb.Clear();
         sb.Append("SELECT Id,TeethName AS Name from cpoe_teeth_master where IsActive=1 and  GroupId=2; ");
         DataTable dttreatment = StockReports.GetDataTable(sb.ToString());


         return Newtonsoft.Json.JsonConvert.SerializeObject(new { dtteeth = dtteeth, dttreatment = dttreatment });
         //return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

     }

     [WebMethod(EnableSession = true)]
     public string SaveTreatmentPlan(string TreatmentID, string PID, string TID, string mouthfloorcomment, string Plaquecomment, string calculascomment, string teethComment, string treatmentcomment, int IsPains, int IsSwell, int IsUIceration, int Plaque, int IsOcciusal, int Ischksub, int Ischksupra, List<TeethValue> TeethValue, List<TreatmentValue> TreatmentValue)
     {
         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try
         {
             var UserID = HttpContext.Current.Session["ID"].ToString();
             var IpAddress = HttpContext.Current.Request.UserHostAddress;
             var ID = 0;
             var message = "";


             if (TreatmentID == "")
             {
                 string sqlCMD = "INSERT INTO cpoe_Dental_treatmentPlan (Patient_Id,Transaction_ID,MouthfloorComment,PlaqueComment,CalculasComment, TeethComment,TreatmentComment,IsPains,IsSwell,CreatedBy,IsUIceration,Plaque, IsOcciusal,Ischksub,Ischksupra)  VALUES(@Patient_Id,@Transaction_ID,@MouthfloorComment,@PlaqueComment,@CalculasComment,@TeethComment,@TreatmentComment,@IsPains,@IsSwell,@CreatedBy,@IsUIceration,@Plaque,@IsOcciusal,@Ischksub,@Ischksupra);select @@identity;";
                 ID = Util.GetInt(excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                 {
                     Patient_Id = PID,
                     Transaction_ID = TID,
                     MouthfloorComment = mouthfloorcomment,
                     CreatedBy = UserID,
                     PlaqueComment = Plaquecomment,
                     CalculasComment = calculascomment,
                     TeethComment = teethComment,
                     TreatmentComment = treatmentcomment,
                     IsPains = IsPains,
                     IsSwell = IsSwell,
                     IsUIceration = IsUIceration,
                     Plaque = Plaque,
                     IsOcciusal = IsOcciusal,
                     Ischksub = Ischksub,
                     Ischksupra = Ischksupra,


                 }));

                 TreatmentID = Util.GetString(ID);

                 message = "Record Save Successfully";
             }
             else
             {
                 string sqlCMD = "UPDATE cpoe_Dental_treatmentPlan SET Patient_Id = @Patient_Id,Transaction_ID=@Transaction_ID,MouthfloorComment=@MouthfloorComment, PlaqueComment=@PlaqueComment, CalculasComment=@CalculasComment, TeethComment=@TeethComment,TreatmentComment=@TreatmentComment,IsPains=@IsPains,IsSwell=@IsSwell,IsUIceration=@IsUIceration, Plaque=@Plaque, IsOcciusal=@IsOcciusal,Ischksub=@Ischksub,Ischksupra=@Ischksupra,UpdatedBy = @UpdatedBy,UpdatedDate = Now() WHERE ID = @ID ";
                 excuteCMD.ExecuteScalar(tnx, sqlCMD, CommandType.Text, new
                 //excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                 {
                     Patient_Id = PID,
                     Transaction_ID = TID,
                     MouthfloorComment = mouthfloorcomment,
                     CreatedBy = UserID,
                     PlaqueComment = Plaquecomment,
                     CalculasComment = calculascomment,
                     TeethComment = teethComment,
                     TreatmentComment = treatmentcomment,
                     IsPains = IsPains,
                     IsSwell = IsSwell,
                     IsUIceration = IsUIceration,
                     Plaque = Plaque,
                     IsOcciusal = IsOcciusal,
                     Ischksub = Ischksub,
                     Ischksupra = Ischksupra,
                     UpdatedBy = UserID,
                     ID = TreatmentID,
                 });
                 message = "Record Updated Successfully";
             }


             string str = "SELECT COUNT(*) FROM cpoe_Dental_teeth WHERE isactive=1 and TreatmentID = '" + TreatmentID + "'";

             var IsExist1 = Util.GetInt(StockReports.ExecuteScalar(str));
             if (IsExist1 > 0)
             {
                 string sqlCMD1 = "Update cpoe_Dental_teeth set IsActive=0 WHERE TreatmentID=@TreatmentID AND ISActive=1 ";
                 excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
                 {
                     TreatmentID = TreatmentID,
                 });
             }


             for (int i = 0; i < TeethValue.Count; i++)
             {
                 string sqlCMD = "INSERT INTO cpoe_Dental_teeth (TreatmentID,TeethId,IsActive,CreatedBy,CreatedDate) values(@TreatmentID,@TeethId,@IsActive,@CreatedBy,now())";

                 excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                 {
                     TreatmentID = TreatmentID,
                     TeethId = TeethValue[i].Id,
                     CreatedBy = UserID,
                     IsActive = 1
                 });
             }


             string str1 = "SELECT COUNT(*) FROM cpoe_Dental_teeth WHERE isactive=1 and TreatmentID = '" + TreatmentID + "'";


             var IsExist2 = Util.GetInt(StockReports.ExecuteScalar(str1));
             if (IsExist2 > 0)
             {
                 string sqlCMD1 = "Update cpoe_Dental_Treatment set IsActive=0 WHERE TreatmentID=@TreatmentID AND ISActive=1 ";
                 excuteCMD.DML(tnx, sqlCMD1, CommandType.Text, new
                 {
                     TreatmentID = TreatmentID,
                 });
             }


             for (int i = 0; i < TreatmentValue.Count; i++)
             {
                 string sqlCMD = "INSERT INTO cpoe_Dental_Treatment (TreatmentID,TId,IsActive,CreatedBy,CreatedDate) values(@TreatmentID,@TeethId,@IsActive,@CreatedBy,now())";

                 excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                 {
                     TreatmentID = TreatmentID,
                     TeethId = TreatmentValue[i].Id,
                     CreatedBy = UserID,
                     IsActive = 1
                 });
             }
             tnx.Commit();
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });
         }
         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog objClassLog = new ClassLog();
             objClassLog.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
     }

     public class TeethValue
     {
         public string TreatmentID { get; set; }
         public int Id { get; set; }

     }
     public class TreatmentValue
     {
         public string TreatmentID { get; set; }
         public int Id { get; set; }

     }

     [WebMethod]
     public string BindTreatmentPlanDetails(string PID, string TID)
     {
         StringBuilder sb = new StringBuilder();
         sb.Append("SELECT cdtp.Id,cdtp.Patient_Id AS PID,cdtp.MouthfloorComment,cdtp.PlaqueComment,cdtp.CalculasComment,cdtp.TeethComment,cdtp.TreatmentComment, ");
         sb.Append("IF(cdtp.IsPains=1,'Yes','No')IsPains, IF(cdtp.IsSwell=1,'Yes','No')IsSwell,");
         sb.Append("IF(cdtp.IsUIceration=1,'Yes','No')IsUIceration, IF(cdtp.IsOcciusal=1,'Yes','No')IsOcciusal,");
         sb.Append("IF(cdtp.Ischksub=1,'Yes','No')Ischksub, IF(cdtp.Ischksupra=1,'Yes','No')Ischksupra,");
         sb.Append("cdtp.Plaque, ");

         sb.Append("CONCAT(CONCAT(em.Title,em.Name))CreatedBy , ");
         sb.Append("DATE_FORMAT(cdtp.CreatedDate,'%d-%b-%Y')DateTime , ");
         sb.Append("CONCAT(IFNULL((SELECT CONCAT(title,'',NAME) FROM employee_master WHERE employeeid=cdtp.UpdatedBy),''),' ',IFNULL(DATE_FORMAT(cdtp.UpdatedDate,'%d-%b-%Y'),''))LastUpdateBy ");
         sb.Append("FROM cpoe_Dental_treatmentPlan cdtp  ");
         sb.Append("INNER JOIN employee_master em ON em.EmployeeID= cdtp.CreatedBy ");
         //sb.Append("INNER JOIN cpoe_Dental_Treatment cdtt ON cdtt.TreatmentID= cdtp.Id ");
         //sb.Append("INNER JOIN cpoe_Dental_teeth cdt ON cdt.TreatmentId= cdtp.Id ");
         sb.Append("  WHERE cdtp.Patient_Id='" + PID + "'  and cdtp.Transaction_ID='" + TID + "' ");

         sb.Append(" GROUP BY cdtp.Id  ");

         return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
     }

     [WebMethod]
     public string EditTeeth(string TreatmentId)
     {
         StringBuilder sb = new StringBuilder();
         sb.Append("SELECT TreatmentId, TeethId FROM cpoe_Dental_teeth WHERE isactive=1 and TreatmentId='" + TreatmentId + "';");
         DataTable dtteeth = StockReports.GetDataTable(sb.ToString());
         sb.Clear();
         sb.Append("SELECT TreatmentId,TId  from cpoe_Dental_Treatment where IsActive=1   and TreatmentId='" + TreatmentId + "'; ");
         DataTable dttreatment = StockReports.GetDataTable(sb.ToString());

         return Newtonsoft.Json.JsonConvert.SerializeObject(new { dtteeth = dtteeth, dttreatment = dttreatment });
         //return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

     }
}
public class ProcedureMaster {
    public string ItemID { get; set; }
    public string StepID { get; set; }
    public int SeqNo { get; set; }
    public Decimal Per { get; set; }
    public Decimal Amount { get; set; }
    public int Day { get; set; }
    public int IsActive { get; set; }
}