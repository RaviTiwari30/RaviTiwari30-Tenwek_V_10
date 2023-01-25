<%@ WebService Language="C#" CodeBehind="~/App_Code/babychart.cs" Class="babychart" %>
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
using System.IO;
using System.Text;

/// <summary>
/// Summary description for babychart
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class babychart : System.Web.Services.WebService
{
    [WebMethod(EnableSession = true, Description = "Get Baby Chart")]
    public string GetBabyCharDetails(string TransactionID)
    {
        StringBuilder objSQL = new StringBuilder();
        objSQL.Append(" Select bc.ID,pm.PName AS BabyName,pm.Gender,pmh.PatientID AS BabyMotherUHID,bc.BabyUHID,bc.TransactionID,bc.BloodGroup,ObstetricHistory,FamilyHistory,MedicalHistory,LMP,DATE_FORMAT(EDDByDate,'%d-%b-%Y')EDDByDate,EDDByScan,AntenatalCare,DATE_FORMAT(BookingDate,'%d-%b-%Y')BookingDate, ");
        objSQL.Append(" SmokesPerDay,Alcohol,DurationOfLabourFirstStage,DurationOfLabourSecondStage,DurationOfLabourThirdStage,AntenatalProblemsAndDrugs, ");
        objSQL.Append(" Amnio,Result,MembranesRuptured,AntenalSteroids,Placenta,DeliveryMode,Indication,bc.Weight,LENGTH,OFC,DATE_FORMAT(GestationDate,'%d-%b-%Y')GestationDate,GestationScan,Dubowitz,ApgarScoreFirst, ");
        objSQL.Append(" ApgarScoreSecond,ApgarScoreThird,ColourFirst,ColourSecond,ColourThird,HeartRateFirst,HeartRateSecond,HeartRateThird,RespirationFirst, ");
        objSQL.Append(" RespirationSecond,RespirationThird,ToneFirst,ToneSecond,ToneThird,ResponseFirst,ResponseSecond,ResponseThird,TotalFirst,TotalSecond, ");
        objSQL.Append(" TotalThird,Resuscitation,EyeOintmentGiven,VitaminKGiven,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,DrExamining,HeadSuturesFontanelles,Hips,Eyes,Genitalia,Ears,Testes,Palate,Spine,Neck, ");
        objSQL.Append(" LowerLimbs,UpperLimbs,Skin,RSChest,Tone,CVS,Movement,Abdomen,Moro,FemoralPulses,Grasp,Anus,Suck,Comments,BabyGender From baby_chart bc INNER JOIN patient_medical_history pmh ON bc.TransactionID=pmh.TransactionID INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID where bc.TransactionID='" + TransactionID + "' ");
        DataTable dt = StockReports.GetDataTable(objSQL.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true, Description = "Save Baby Chart")]
    public string SaveBabyChart(List<BabyChart> DefaultlDetails)
    {
        List<BabyChart> Details = DefaultlDetails; 
       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            int dividend = (Details[0].GaWeek * 7) + Details[0].GaDays;
            int divisor = 7;
            int remainder;
            int quotient = Math.DivRem(dividend, divisor, out remainder);
            
                BabyChart BabyChart = new BabyChart(tnx);

                BabyChart.TransactionID = Details[0].TransactionID; 
                BabyChart.BloodGroup = Details[0].BloodGroup;
                BabyChart.ObstetricHistory = Details[0].ObstetricHistory;
                BabyChart.FamilyHistory = Details[0].FamilyHistory;
                BabyChart.MedicalHistory = Details[0].MedicalHistory;
                BabyChart.LMP = Details[0].LMP;
                BabyChart.EDDByDate = Details[0].EDDByDate; 
                BabyChart.EDDByScan = Details[0].EDDByScan;
                BabyChart.AntenatalCare = Details[0].AntenatalCare;
                BabyChart.BookingDate = Details[0].BookingDate; 
                BabyChart.SmokesPerDay = Details[0].SmokesPerDay;
                BabyChart.Alcohol = Details[0].Alcohol;
                BabyChart.DurationOfLabourFirstStage = Details[0].DurationOfLabourFirstStage;
                BabyChart.DurationOfLabourSecondStage = Details[0].DurationOfLabourSecondStage;
                BabyChart.DurationOfLabourThirdStage = Details[0].DurationOfLabourThirdStage;
                BabyChart.AntenatalProblemsAndDrugs = Details[0].AntenatalProblemsAndDrugs;
                BabyChart.Amnio = Details[0].Amnio;
                BabyChart.Result = Details[0].Result;
                BabyChart.MembranesRuptured = Details[0].MembranesRuptured;
                BabyChart.AntenalSteroids = Details[0].AntenalSteroids;
                BabyChart.Placenta = Details[0].Placenta;
                BabyChart.DeliveryMode = Details[0].DeliveryMode;
                BabyChart.Indication = Details[0].Indication;
                BabyChart.Weight = Details[0].Weight;
                BabyChart.Length = Details[0].Length;              
                BabyChart.OFC = Details[0].OFC;
                BabyChart.GestationDate = Details[0].GestationDate;
                BabyChart.GestationScan = Details[0].GestationScan;
                BabyChart.Dubowitz = Details[0].Dubowitz;
                BabyChart.ApgarScoreFirst = Details[0].ApgarScoreFirst;
                BabyChart.ApgarScoreSecond = Details[0].ApgarScoreSecond;
                BabyChart.ApgarScoreThird = Details[0].ApgarScoreThird;
                BabyChart.ColourFirst = Details[0].ColourFirst;
                BabyChart.ColourSecond = Details[0].ColourSecond;
                BabyChart.ColourThird = Details[0].ColourThird;
                BabyChart.HeartRateFirst = Details[0].HeartRateFirst;
                BabyChart.HeartRateSecond = Details[0].HeartRateSecond;
                BabyChart.HeartRateThird = Details[0].HeartRateThird;
                BabyChart.RespirationFirst = Details[0].RespirationFirst;
                BabyChart.RespirationSecond = Details[0].RespirationSecond;
                BabyChart.RespirationThird = Details[0].RespirationThird;
                BabyChart.ToneFirst = Details[0].ToneFirst;
                BabyChart.ToneSecond = Details[0].ToneSecond;
                BabyChart.ToneThird = Details[0].ToneThird;
                BabyChart.ResponseFirst = Details[0].ResponseFirst;
                BabyChart.ResponseSecond = Details[0].ResponseSecond;
                BabyChart.ResponseThird = Details[0].ResponseThird;
                BabyChart.TotalFirst = Details[0].TotalFirst;
                BabyChart.TotalSecond = Details[0].TotalSecond;
                BabyChart.TotalThird = Details[0].TotalThird;
                BabyChart.Resuscitation = Details[0].Resuscitation;
                BabyChart.VitaminKGiven = Details[0].VitaminKGiven;
                BabyChart.EyeOintmentGiven = Details[0].EyeOintmentGiven;
                BabyChart.DATE = Details[0].DATE;
                BabyChart.DrExamining = Details[0].DrExamining;
                BabyChart.HeadSuturesFontanelles = Details[0].HeadSuturesFontanelles;
                BabyChart.Hips = Details[0].Hips;
                BabyChart.Eyes = Details[0].Eyes;
                BabyChart.Genitalia = Details[0].Genitalia;
                BabyChart.Ears = Details[0].Ears;
                BabyChart.Testes = Details[0].Testes;
                BabyChart.Palate = Details[0].Palate;
                BabyChart.Spine = Details[0].Spine;
                BabyChart.Neck = Details[0].Neck;
                BabyChart.LowerLimbs = Details[0].LowerLimbs;
                BabyChart.UpperLimbs = Details[0].UpperLimbs;
                BabyChart.Skin = Details[0].Skin;
                BabyChart.RSChest = Details[0].RSChest;
                BabyChart.Tone = Details[0].Tone;
                BabyChart.CVS = Details[0].CVS;
                BabyChart.Movement = Details[0].Movement;
                BabyChart.Abdomen = Details[0].Abdomen;
                BabyChart.Moro = Details[0].Moro;
                BabyChart.FemoralPulses = Details[0].FemoralPulses;
                BabyChart.Grasp = Details[0].Grasp;
                BabyChart.Anus = Details[0].Anus;
                BabyChart.Suck = Details[0].Suck;
                BabyChart.Comments = Details[0].Comments;
                BabyChart.babyUHID = Details[0].babyUHID;
                BabyChart.gender = Details[0].gender;
                BabyChart.BabyChartID = Details[0].BabyChartID;                
                BabyChart.GaWeek = Details[0].GaWeek;
                BabyChart.GaDays = Details[0].GaDays;

                        int i = BabyChart.Insert();

                    
                        string BabyIDUpdate = "UPDATE  PatientMotherBabyDetails SET BabyChartDone=1 WHERE ID=@ID";
                        excuteCMD.DML(tnx, BabyIDUpdate, CommandType.Text, new
                        {
                            ID = Details[0].BabyID
                        });
                        string BabyGenderUpdate = "UPDATE  patient_master SET Gender=@Gender WHERE PatientID=@PatientID";
                        excuteCMD.DML(tnx, BabyGenderUpdate, CommandType.Text, new
                        {
                            PatientID= Details[0].babyUHID,
                            Gender = Details[0].gender
                        });
               
            if (i == 0)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Not Saved" });
                }
            
                
                tnx.Commit();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", message = "Saved Successfully" });         
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true, Description = "Get Baby UHID")]

    public string GetBabyUHID(string TransactionID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,BabyPatientID FROM PatientMotherBabyDetails WHERE MotherTransactionID='" + TransactionID + "' AND BabyChartDone=0");
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else { return ""; }
        
    }
    [WebMethod(EnableSession = true, Description = "Get Baby Chart")]
    public string GetBabyCharDetailsID(string ID)
    {
        StringBuilder objSQL = new StringBuilder();
        objSQL.Append(" Select GaWeek,GaDays,pm.PName AS BabyName,pm.Gender,pmh.PatientID AS BabyMotherUHID,bc.BabyUHID,bc.TransactionID,bc.BloodGroup,ObstetricHistory,FamilyHistory,MedicalHistory,LMP,DATE_FORMAT(EDDByDate,'%d-%b-%Y')EDDByDate,EDDByScan,AntenatalCare,DATE_FORMAT(BookingDate,'%d-%b-%Y')BookingDate, ");
        objSQL.Append(" SmokesPerDay,Alcohol,DurationOfLabourFirstStage,DurationOfLabourSecondStage,DurationOfLabourThirdStage,AntenatalProblemsAndDrugs, ");
        objSQL.Append(" Amnio,Result,MembranesRuptured,AntenalSteroids,Placenta,DeliveryMode,Indication,LENGTH,OFC,DATE_FORMAT(GestationDate,'%d-%b-%Y')GestationDate,GestationScan,Dubowitz,ApgarScoreFirst, ");
        objSQL.Append(" ApgarScoreSecond,ApgarScoreThird,ColourFirst,ColourSecond,ColourThird,HeartRateFirst,HeartRateSecond,HeartRateThird,RespirationFirst, ");
        objSQL.Append(" RespirationSecond,RespirationThird,ToneFirst,ToneSecond,ToneThird,ResponseFirst,ResponseSecond,ResponseThird,TotalFirst,TotalSecond, ");
        objSQL.Append(" TotalThird,Resuscitation,VitaminKGiven,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,DrExamining,HeadSuturesFontanelles,Hips,Eyes,Genitalia,Ears,Testes,Palate,Spine,Neck, ");
        objSQL.Append(" LowerLimbs,UpperLimbs,Skin,RSChest,Tone,CVS,Movement,Abdomen,Moro,FemoralPulses,Grasp,Anus,Suck,Comments From baby_chart bc INNER JOIN patient_medical_history pmh ON bc.TransactionID=pmh.TransactionID INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID where bc.ID='" + ID + "' ");
        DataTable dt = StockReports.GetDataTable(objSQL.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
     
    
    
}