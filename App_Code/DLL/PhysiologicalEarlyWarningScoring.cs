#region All Namespaces
using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Web;
#endregion All Namespaces

/// <summary>
/// Summary description for PhysiologicalEarlyWarningScoring
/// </summary>
public class PhysiologicalEarlyWarningScoring
{
    #region Overloaded Constructor

    public PhysiologicalEarlyWarningScoring()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
	}
    public PhysiologicalEarlyWarningScoring(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion Overloaded Constructor
    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables
     #region All Memory Variables
    private int _ID;
    private string _TransactionID;
    private string _Date;
    private string _Time;
    private string _Weight;
    private string _BMI;
    private string _CapillaryBloodGlucose;
    private string _RespiratoryRateValue;
    private string _RespiratoryRateText;
    private string _OxygenSaturationValue;
    private string _OxygenSaturationText;
    private string _InspiredValue;
    private string _InspiredText;
    private string _OxygenDeviceValue;
    private string _OxygenDeviceText;
    private string _SignatureName;
    private string _SignatureNameOfStaffNurseTakingVitals;
    private string _TemperatureValue;
    private string _TemperatureText;
    private string _BloodPressureValue;
    private string _BloodPressureText;
    private string _HeartRateValue;
    private string _HeartRateText;
    private string _PEWSScore;
    private string _PainScore;
    private string _BowelsOpenedValue;
    private string _BowelsOpenedText;
    private string _NauseaAndVomitingScoreValue;
    private string _NauseaAndVomitingScoreText;
    private string _UrineOutputValue;
    private string _UrineOutputText;
    private string _VisualInfusionPhlebitisValue;
    private string _VisualInfusionPhlebitisText;
    private string _OtherComments;

    private string _ConfusedText;
    private string _Confusedvalue;
    private string _AlertText;
    private string _AlertValue;
    private string _VerbalText;
    private string _VerbalValue;
    private string _PainText;
    private string _PainValue;
    private string _UnresponsiveText;
    private string _UnresponsiveValue;

    #endregion All Memory Variables   
	 #region Set All Property
    public virtual int ID
    {
        get
        {
            return _ID;
        }
        set
        {
            _ID = value;
        }
    }
    public virtual string SignatureName
    {
        get
        {
            return _SignatureName;
        }
        set
        {
            _SignatureName = value;
        }
    }
    public virtual string SignatureNameOfStaffNurseTakingVitals
    {
        get
        {
            return _SignatureNameOfStaffNurseTakingVitals;
        }
        set
        {
            _SignatureNameOfStaffNurseTakingVitals = value;
        }
    }
    public virtual string TemperatureValue
    {
        get
        {
            return _TemperatureValue;
        }
        set
        {
            _TemperatureValue = value;
        }
    }
    public virtual string TemperatureText
    {
        get
        {
            return _TemperatureText;
        }
        set
        {
            _TemperatureText = value;
        }
    }
    public virtual string InspiredValue
    {
        get
        {
            return _InspiredValue;
        }
        set
        {
            _InspiredValue = value;
        }
    }
    public virtual string InspiredText
    {
        get
        {
            return _InspiredText;
        }
        set
        {
            _InspiredText = value;
        }
    }
    public virtual string AlertText
    {
        get
        {
            return _AlertText;
        }
        set
        {
            _AlertText = value;
        }
    }
    public virtual string AlertValue
    {
        get
        {
            return _AlertValue;
        }
        set
        {
            _AlertValue = value;
        }
    }
    public virtual string VerbalText
    {
        get
        {
            return _VerbalText;
        }
        set
        {
            _VerbalText = value;
        }
    }
    public virtual string VerbalValue
    {
        get
        {
            return _VerbalValue;
        }
        set
        {
            _VerbalValue = value;
        }
    }
    public virtual string PainText
    {
        get
        {
            return _PainText;
        }
        set
        {
            _PainText = value;
        }
    }
    public virtual string PainValue
    {
        get
        {
            return _PainValue;
        }
        set
        {
            _PainValue = value;
        }
    }
    public virtual string UnresponsiveText
    {
        get
        {
            return _UnresponsiveText;
        }
        set
        {
            _UnresponsiveText = value;
        }
    }
    public virtual string UnresponsiveValue
    {
        get
        {
            return _UnresponsiveValue;
        }
        set
        {
            _UnresponsiveValue = value;
        }
    }
    public virtual string ConfusedText
    {
        get
        {
            return _ConfusedText;
        }
        set
        {
            _ConfusedText = value;
        }
    }
    public virtual string Confusedvalue
    {
        get
        {
            return _Confusedvalue;
        }
        set
        {
            _Confusedvalue = value;
        }
    }
    public virtual string TransactionID
    {
        get
        {
            return _TransactionID;
        }
        set
        {
            _TransactionID = value;
        }
    }
    public virtual string Date
    {
        get
        {
            return _Date;
        }
        set
        {
            _Date = value;
        }
    }
    public virtual string Time
    {
        get
        {
            return _Time;
        }
        set
        {
            _Time = value;
        }
    }
    public virtual string Weight
    {
        get
        {
            return _Weight;
        }
        set
        {
            _Weight = value;
        }
    }
    public virtual string BMI
    {
        get
        {
            return _BMI;
        }
        set
        {
            _BMI = value;
        }
    }
    public virtual string CapillaryBloodGlucose
    {
        get
        {
            return _CapillaryBloodGlucose;
        }
        set
        {
            _CapillaryBloodGlucose = value;
        }
    }
    public virtual string RespiratoryRateValue
    {
        get
        {
            return _RespiratoryRateValue;
        }
        set
        {
            _RespiratoryRateValue = value;
        }
    }
    public virtual string RespiratoryRateText
    {
        get
        {
            return _RespiratoryRateText;
        }
        set
        {
            _RespiratoryRateText = value;
        }
    }
    public virtual string OxygenSaturationValue
    {
        get
        {
            return _OxygenSaturationValue;
        }
        set
        {
            _OxygenSaturationValue = value;
        }
    }
    public virtual string OxygenSaturationText
    {
        get
        {
            return _OxygenSaturationText;
        }
        set
        {
            _OxygenSaturationText = value;
        }
    }
    public virtual string OxygenDeviceValue
    {
        get
        {
            return _OxygenDeviceValue;
        }
        set
        {
            _OxygenDeviceValue = value;
        }
    }
    public virtual string OxygenDeviceText
    {
        get
        {
            return _OxygenDeviceText;
        }
        set
        {
            _OxygenDeviceText = value;
        }
    }
    public virtual string BloodPressureValue
    {
        get
        {
            return _BloodPressureValue;
        }
        set
        {
            _BloodPressureValue = value;
        }
    }
    public virtual string BloodPressureText
    {
        get
        {
            return _BloodPressureText;
        }
        set
        {
            _BloodPressureText = value;
        }
    }
    public virtual string HeartRateValue
    {
        get
        {
            return _HeartRateValue;
        }
        set
        {
            _HeartRateValue = value;
        }
    }
    public virtual string HeartRateText
    {
        get
        {
            return _HeartRateText;
        }
        set
        {
            _HeartRateText = value;
        }
    }
    public virtual string PEWSScore
    {
        get
        {
            return _PEWSScore;
        }
        set
        {
            _PEWSScore = value;
        }
    }
    public virtual string PainScore
    {
        get
        {
            return _PainScore;
        }
        set
        {
            _PainScore = value;
        }
    }
    public virtual string BowelsOpenedValue
    {
        get
        {
            return _BowelsOpenedValue;
        }
        set
        {
            _BowelsOpenedValue = value;
        }
    }
    public virtual string BowelsOpenedText
    {
        get
        {
            return _BowelsOpenedText;
        }
        set
        {
            _BowelsOpenedText = value;
        }
    }
    public virtual string NauseaAndVomitingScoreValue
    {
        get
        {
            return _NauseaAndVomitingScoreValue;
        }
        set
        {
            _NauseaAndVomitingScoreValue = value;
        }
    }
    public virtual string NauseaAndVomitingScoreText
    {
        get
        {
            return _NauseaAndVomitingScoreText;
        }
        set
        {
            _NauseaAndVomitingScoreText = value;
        }
    }
    public virtual string UrineOutputValue
    {
        get
        {
            return _UrineOutputValue;
        }
        set
        {
            _UrineOutputValue = value;
        }
    }
    public virtual string UrineOutputText
    {
        get
        {
            return _UrineOutputText;
        }
        set
        {
            _UrineOutputText = value;
        }
    }
    public virtual string VisualInfusionPhlebitisValue
    {
        get
        {
            return _VisualInfusionPhlebitisValue;
        }
        set
        {
            _VisualInfusionPhlebitisValue = value;
        }
    }
    public virtual string VisualInfusionPhlebitisText
    {
        get
        {
            return _VisualInfusionPhlebitisText;
        }
        set
        {
            _VisualInfusionPhlebitisText = value;
        }
    }
    public virtual string OtherComments
    {
        get
        {
            return _OtherComments;
        }
        set
        {
            _OtherComments = value;
        }
    }    
    #endregion Set All Property
    #region All Public Member Function
    public int SavePhysiologicalEarlyWarningScoringDetails()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
          //  int count = Util.GetInt(StockReports.ExecuteScalar(" Select COUNT(*) From Physiological_Early_Warning_Scoring_Chart where TransactionID='" + TransactionID + "'  "));
            if (ID > 0)
            {
             //   StockReports.ExecuteDML(" Update physiological_early_warning_scoring_chart set Status = 0,UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDatetime=NOW() where TransactionID = '" + TransactionID + "' ");
                objSQL.Append(" Update physiological_early_warning_scoring_chart set Weight=@Weight,BMI=@BMI,CapillaryBloodGlucose=@CapillaryBloodGlucose,DATE=@DATE,TIME=@TIME,RespiratoryRateText=@RespiratoryRateText,RespiratoryRateValue=@RespiratoryRateValue,");
                objSQL.Append(" OxygenSaturationText=@OxygenSaturationText,OxygenSaturationValue=@OxygenSaturationValue,InspiredText=@InspiredText,InspiredValue=@InspiredValue,OxygenDeviceText=@OxygenDeviceText,OxygenDeviceValue=@OxygenDeviceValue, ");
                objSQL.Append("TemperatureText=@TemperatureText,TemperatureValue=@TemperatureValue,BloodPressureText=@BloodPressureText,BloodPressureValue=@BloodPressureValue,HeartRateText=@HeartRateText,HeartRateValue=@HeartRateValue, ");
                objSQL.Append(" ConfusedText=@ConfusedText,Confusedvalue=@Confusedvalue,AlertText=@AlertText,AlertValue=@AlertValue,VerbalText=@VerbalText,VerbalValue=@VerbalValue,PainText=@PainText,PainValue=@PainValue, ");
                objSQL.Append(" UnresponsiveText=@UnresponsiveText,UnresponsiveValue=@UnresponsiveValue,PEWSScore=@PEWSScore,PainScore=@PainScore,BowelsOpenedText=@BowelsOpenedText,BowelsOpenedValue=@BowelsOpenedValue, ");
                objSQL.Append(" NauseaAndVomitingScoreText=@NauseaAndVomitingScoreText,NauseaAndVomitingScoreValue=@NauseaAndVomitingScoreValue,UrineOutputText=@UrineOutputText,UrineOutputValue=@UrineOutputValue,VisualInfusionPhlebitisText=@VisualInfusionPhlebitisText, ");
                objSQL.Append(" VisualInfusionPhlebitisValue=@VisualInfusionPhlebitisValue,UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDatetime=NOW() where ID = " + ID + " ");
            }
            else
            {
                objSQL.Append("INSERT INTO physiological_early_warning_scoring_chart ");
                objSQL.Append(" (TransactionID,Weight,BMI,CapillaryBloodGlucose,DATE,TIME,RespiratoryRateText,RespiratoryRateValue, ");
                objSQL.Append(" OxygenSaturationText,OxygenSaturationValue,InspiredText,InspiredValue,OxygenDeviceText,OxygenDeviceValue, ");
                objSQL.Append(" TemperatureText,TemperatureValue,BloodPressureText,BloodPressureValue,HeartRateText,HeartRateValue, ");
                objSQL.Append(" ConfusedText,Confusedvalue,AlertText,AlertValue,VerbalText,VerbalValue,PainText,PainValue,UnresponsiveText,UnresponsiveValue,PEWSScore,PainScore,BowelsOpenedText,BowelsOpenedValue, ");
                objSQL.Append(" NauseaAndVomitingScoreText,NauseaAndVomitingScoreValue,UrineOutputText,UrineOutputValue,VisualInfusionPhlebitisText, ");
                objSQL.Append(" VisualInfusionPhlebitisValue,SignatureName,SignatureNameOfStaffNurseTakingVitals,OtherComments,CreatedDateTime, ");
                objSQL.Append(" CreatedBy,Status) ");
                objSQL.Append(" VALUES (@TransactionID,@Weight,@BMI,@CapillaryBloodGlucose,@DATE,@TIME,@RespiratoryRateText,@RespiratoryRateValue, ");
                objSQL.Append(" @OxygenSaturationText,@OxygenSaturationValue,@InspiredText,@InspiredValue,@OxygenDeviceText,@OxygenDeviceValue, ");
                objSQL.Append(" @TemperatureText,@TemperatureValue,@BloodPressureText,@BloodPressureValue,@HeartRateText,@HeartRateValue, ");
                objSQL.Append(" @ConfusedText,@Confusedvalue,@AlertText,@AlertValue,@VerbalText,@VerbalValue,@PainText,@PainValue,@UnresponsiveText,@UnresponsiveValue,@PEWSScore,@PainScore,@BowelsOpenedText,@BowelsOpenedValue, ");
                objSQL.Append(" @NauseaAndVomitingScoreText,@NauseaAndVomitingScoreValue,@UrineOutputText,@UrineOutputValue,@VisualInfusionPhlebitisText, ");
                objSQL.Append(" @VisualInfusionPhlebitisValue,@SignatureName,@SignatureNameOfStaffNurseTakingVitals,@OtherComments,NOW(), ");
                objSQL.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "',1) ");
            }
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.TransactionID = Util.GetString(TransactionID);
            this.Date = Util.GetString(Date);
            this.Time = Util.GetString(Time);
            this.Weight = Util.GetString(Weight);
            this.BMI = Util.GetString(BMI);
            this.CapillaryBloodGlucose = Util.GetString(CapillaryBloodGlucose);
            this.RespiratoryRateValue = RespiratoryRateValue;
            this.RespiratoryRateText = RespiratoryRateText.Replace("Select", "");
            this.OxygenSaturationValue = Util.GetString(OxygenSaturationValue);
            this.OxygenSaturationText = Util.GetString(OxygenSaturationText.Replace("Select", ""));
            this.InspiredValue = Util.GetString(InspiredValue);
            this.InspiredText = Util.GetString(InspiredText.Replace("Select", ""));
            this.OxygenDeviceValue = Util.GetString(OxygenDeviceValue);
            this.OxygenDeviceText = Util.GetString(OxygenDeviceText.Replace("Select", ""));
            this.TemperatureValue = Util.GetString(TemperatureValue);
            this.TemperatureText = Util.GetString(TemperatureText.Replace("Select", ""));
            this.BloodPressureValue = BloodPressureValue;
            this.BloodPressureText = BloodPressureText.Replace("Select", "");
            this.HeartRateValue = Util.GetString(HeartRateValue);
            this.HeartRateText = Util.GetString(HeartRateText.Replace("Select", ""));

            this.ConfusedText = Util.GetString(ConfusedText.Replace("Select", ""));
            this.Confusedvalue = Util.GetString(Confusedvalue);
            this.AlertText = Util.GetString(AlertText.Replace("Select", ""));
            this.AlertValue = Util.GetString(AlertValue);
            this.VerbalText = Util.GetString(VerbalText.Replace("Select", ""));
            this.VerbalValue = Util.GetString(VerbalValue);
            this.PainText = Util.GetString(PainText);
            this.PainValue = Util.GetString(PainValue);
            this.UnresponsiveText = Util.GetString(UnresponsiveText);
            this.UnresponsiveValue = Util.GetString(UnresponsiveValue);
            

            this.PEWSScore = Util.GetString(PEWSScore);
            this.PainScore = Util.GetString(PainScore);
            this.BowelsOpenedValue = Util.GetString(BowelsOpenedValue);
            this.BowelsOpenedText = Util.GetString(BowelsOpenedText);
            this.NauseaAndVomitingScoreValue = Util.GetString(NauseaAndVomitingScoreValue);
            this.NauseaAndVomitingScoreText = Util.GetString(NauseaAndVomitingScoreText);
            this.UrineOutputValue = Util.GetString(UrineOutputValue);
            this.UrineOutputText = Util.GetString(UrineOutputText);
            this.VisualInfusionPhlebitisValue = Util.GetString(VisualInfusionPhlebitisValue);
            this.VisualInfusionPhlebitisText = Util.GetString(VisualInfusionPhlebitisText);
            this.SignatureName = Util.GetString(SignatureName);
            this.SignatureNameOfStaffNurseTakingVitals = Util.GetString(SignatureNameOfStaffNurseTakingVitals);            
            this.OtherComments = Util.GetString(OtherComments);
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
            new MySqlParameter("@TransactionID", TransactionID),
            new MySqlParameter("@Date", Util.GetDateTime(Date).ToString("yyyy-MM-dd")),
            new MySqlParameter("@Time", Util.GetDateTime(Time).ToString("HH:mm:ss")),
            new MySqlParameter("@Weight", Weight),
            new MySqlParameter("@BMI", BMI),
            new MySqlParameter("@CapillaryBloodGlucose", CapillaryBloodGlucose),
            new MySqlParameter("@RespiratoryRateValue", RespiratoryRateValue),
            new MySqlParameter("@RespiratoryRateText", RespiratoryRateText),
            new MySqlParameter("@OxygenSaturationValue", OxygenSaturationValue),
            new MySqlParameter("@OxygenSaturationText", OxygenSaturationText),
            new MySqlParameter("@InspiredValue", InspiredValue),
            new MySqlParameter("@InspiredText", InspiredText),
            new MySqlParameter("@OxygenDeviceValue", OxygenDeviceValue),
            new MySqlParameter("@OxygenDeviceText", OxygenDeviceText),
            new MySqlParameter("@TemperatureValue", TemperatureValue),
            new MySqlParameter("@TemperatureText", TemperatureText),
            new MySqlParameter("@BloodPressureValue", BloodPressureValue),
            new MySqlParameter("@BloodPressureText", BloodPressureText),
            new MySqlParameter("@HeartRateValue", HeartRateValue),
            new MySqlParameter("@HeartRateText", HeartRateText),

            new MySqlParameter("@ConfusedText", ConfusedText),
            new MySqlParameter("@Confusedvalue", Confusedvalue),
            new MySqlParameter("@AlertText", AlertText),
            new MySqlParameter("@AlertValue", AlertValue),
            new MySqlParameter("@VerbalText", VerbalText),
            new MySqlParameter("@VerbalValue", VerbalValue),
            new MySqlParameter("@PainText", PainText),
            new MySqlParameter("@PainValue", PainValue),
            new MySqlParameter("@UnresponsiveText", UnresponsiveText),
            new MySqlParameter("@UnresponsiveValue", UnresponsiveValue),

            new MySqlParameter("@PEWSScore", PEWSScore),
            new MySqlParameter("@PainScore", PainScore),
            new MySqlParameter("@BowelsOpenedValue", BowelsOpenedValue),
            new MySqlParameter("@BowelsOpenedText", BowelsOpenedText),
            new MySqlParameter("@NauseaAndVomitingScoreValue", NauseaAndVomitingScoreValue),
            new MySqlParameter("@NauseaAndVomitingScoreText", NauseaAndVomitingScoreText),
            new MySqlParameter("@UrineOutputValue", UrineOutputValue),
            new MySqlParameter("@UrineOutputText", UrineOutputText),
            new MySqlParameter("@VisualInfusionPhlebitisValue", VisualInfusionPhlebitisValue),
            new MySqlParameter("@VisualInfusionPhlebitisText", VisualInfusionPhlebitisText),
            new MySqlParameter("@SignatureName", SignatureName),
            new MySqlParameter("@SignatureNameOfStaffNurseTakingVitals", SignatureNameOfStaffNurseTakingVitals),
            new MySqlParameter("@OtherComments", OtherComments));
            
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return RowAffected;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            //Util.WriteLog(ex);
            throw (ex);
        }
    }

    #endregion All Public Member Function
}