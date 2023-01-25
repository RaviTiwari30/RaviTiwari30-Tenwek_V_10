<%@ WebService Language="C#" CodeBehind="~/App_Code/EarlyWarningScoring.cs" Class="EarlyWarningScoring" %>
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
/// Summary description for EarlyWarningScoring
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class EarlyWarningScoring : System.Web.Services.WebService
{
    
    [WebMethod(EnableSession = true, Description = "Get Physiological Early Warning Scoring")]
    public string GetEarlyWarningScoringDetails(string TransactionID)
    {
        StringBuilder objSQL = new StringBuilder();
        objSQL.Append(" Select ID,TransactionID,Weight,BMI,CapillaryBloodGlucose,DATE,TIME,RespiratoryRateText,RespiratoryRateValue, OxygenSaturationText,OxygenSaturationValue,InspiredText,InspiredValue,OxygenDeviceText,OxygenDeviceValue, TemperatureText,TemperatureValue,BloodPressureText,BloodPressureValue,HeartRateText,HeartRateValue,ConfusedText,Confusedvalue,AlertText,AlertValue,VerbalText,VerbalValue,PainText,PainValue,UnresponsiveText,UnresponsiveValue,PEWSScore,PainScore,BowelsOpenedText,BowelsOpenedValue, NauseaAndVomitingScoreText,NauseaAndVomitingScoreValue,UrineOutputText,UrineOutputValue,VisualInfusionPhlebitisText,VisualInfusionPhlebitisValue,SignatureName,SignatureNameOfStaffNurseTakingVitals,OtherComments,CreatedDateTime, CreatedBy,UpdatedDatetime,UpdatedBy From physiological_early_warning_scoring_chart where TransactionID ='" + TransactionID + "' ");
        DataTable dt = StockReports.GetDataTable(objSQL.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true, Description = "Save Physiological Early Warning Scoring Details")]
    public string SaveEarlyWarningScoringDetails(List<PhysiologicalEarlyWarningScoring> DefaultlDetails)
    {
        List<PhysiologicalEarlyWarningScoring> Details = DefaultlDetails;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            PhysiologicalEarlyWarningScoring PhysiologicalEarlyWarningScoring = new PhysiologicalEarlyWarningScoring(tnx);
            PhysiologicalEarlyWarningScoring.ID = Details[0].ID;
            PhysiologicalEarlyWarningScoring.TransactionID = Details[0].TransactionID;
            PhysiologicalEarlyWarningScoring.Date = Details[0].Date;
            PhysiologicalEarlyWarningScoring.Time = Details[0].Time;
            PhysiologicalEarlyWarningScoring.Weight = Details[0].Weight;
            PhysiologicalEarlyWarningScoring.BMI = Details[0].BMI;
            PhysiologicalEarlyWarningScoring.CapillaryBloodGlucose = Details[0].CapillaryBloodGlucose;
            PhysiologicalEarlyWarningScoring.RespiratoryRateValue = Details[0].RespiratoryRateValue;
            PhysiologicalEarlyWarningScoring.RespiratoryRateText = Details[0].RespiratoryRateText;
            PhysiologicalEarlyWarningScoring.OxygenSaturationValue = Details[0].OxygenSaturationValue;
            PhysiologicalEarlyWarningScoring.OxygenSaturationText = Details[0].OxygenSaturationText;
            PhysiologicalEarlyWarningScoring.InspiredValue = Details[0].InspiredValue;
            PhysiologicalEarlyWarningScoring.InspiredText = Details[0].InspiredText;
            PhysiologicalEarlyWarningScoring.OxygenDeviceValue = Details[0].OxygenDeviceValue;
            PhysiologicalEarlyWarningScoring.OxygenDeviceText = Details[0].OxygenDeviceText;
            PhysiologicalEarlyWarningScoring.TemperatureValue = Details[0].TemperatureValue;
            PhysiologicalEarlyWarningScoring.TemperatureText = Details[0].TemperatureText;
            PhysiologicalEarlyWarningScoring.BloodPressureText = Details[0].BloodPressureText;
            PhysiologicalEarlyWarningScoring.BloodPressureValue = Details[0].BloodPressureValue;
            PhysiologicalEarlyWarningScoring.HeartRateValue = Details[0].HeartRateValue;
            PhysiologicalEarlyWarningScoring.HeartRateText = Details[0].HeartRateText;
            PhysiologicalEarlyWarningScoring.ConfusedText = Details[0].ConfusedText;
            PhysiologicalEarlyWarningScoring.Confusedvalue = Details[0].Confusedvalue;
            PhysiologicalEarlyWarningScoring.AlertText = Details[0].AlertText;
            PhysiologicalEarlyWarningScoring.AlertValue = Details[0].AlertValue;
            PhysiologicalEarlyWarningScoring.VerbalText = Details[0].VerbalText;
            PhysiologicalEarlyWarningScoring.VerbalValue = Details[0].VerbalValue;
            PhysiologicalEarlyWarningScoring.PainText = Details[0].PainText;
            PhysiologicalEarlyWarningScoring.PainValue = Details[0].PainValue;
            PhysiologicalEarlyWarningScoring.UnresponsiveText = Details[0].UnresponsiveText;
            PhysiologicalEarlyWarningScoring.UnresponsiveValue = Details[0].UnresponsiveValue;            
            PhysiologicalEarlyWarningScoring.PEWSScore = Details[0].PEWSScore;
            PhysiologicalEarlyWarningScoring.PainScore = Details[0].PainScore;
            PhysiologicalEarlyWarningScoring.BowelsOpenedValue = Details[0].BowelsOpenedValue;
            PhysiologicalEarlyWarningScoring.BowelsOpenedText = Details[0].BowelsOpenedText;
            PhysiologicalEarlyWarningScoring.NauseaAndVomitingScoreValue = Details[0].NauseaAndVomitingScoreValue;
            PhysiologicalEarlyWarningScoring.NauseaAndVomitingScoreText = Details[0].NauseaAndVomitingScoreText;
            PhysiologicalEarlyWarningScoring.UrineOutputValue = Details[0].UrineOutputValue;
            PhysiologicalEarlyWarningScoring.UrineOutputText = Details[0].UrineOutputText;
            PhysiologicalEarlyWarningScoring.VisualInfusionPhlebitisValue = Details[0].VisualInfusionPhlebitisValue;
            PhysiologicalEarlyWarningScoring.VisualInfusionPhlebitisText = Details[0].VisualInfusionPhlebitisText;
            PhysiologicalEarlyWarningScoring.SignatureName = "";
            PhysiologicalEarlyWarningScoring.SignatureNameOfStaffNurseTakingVitals = "";
            PhysiologicalEarlyWarningScoring.OtherComments = Details[0].OtherComments;
            
            int i = PhysiologicalEarlyWarningScoring.SavePhysiologicalEarlyWarningScoringDetails();
            if (i == 0)
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Not Saved" });
            }
            tnx.Commit();
            if (Details[0].ID > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Data Updated Successfully", message = "Updated Successfully" });
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Data Saved Successfully", message = "Saved Successfully" });
            }
           
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
}

    
   