#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
#endregion All Namespaces


public class BabyChart
{
    #region All Memory Variables
    private string _TransactionID;
    private string _BloodGroup;
    private string _ObstetricHistory;
    private string _FamilyHistory;
    private string _MedicalHistory;
    private string _LMP;
    private string _EDDByDate;
    private string _EDDByScan;
    private string _AntenatalCare;
    private string _BookingDate;
    private string _SmokesPerDay;
    private string _Alcohol;
    private string _DurationOfLabourFirstStage;
    private string _DurationOfLabourSecondStage;
    private string _DurationOfLabourThirdStage;
    private string _AntenatalProblemsAndDrugs;
    private string _Amnio;
    private string _Result;
    private string _AntenalSteroids;
    private string _Placenta;
    private string _DeliveryMode;
    private string _Indication;
    private string _Length;
    private string _OFC;
    private string _GestationDate;
    private string _GestationScan;
    private string _Dubowitz;
    private string _ApgarScoreFirst;
    private string _ApgarScoreSecond;
    private string _ApgarScoreThird;
    private string _ColourFirst;
    private string _ColourSecond;
    private string _ColourThird;
    private string _HeartRateFirst;
    private string _HeartRateSecond;
    private string _HeartRateThird;
    private string _RespirationFirst;
    private string _RespirationSecond;
    private string _RespirationThird;
    private string _ToneFirst;
    private string _ToneSecond;
    private string _ToneThird;
    private string _ResponseFirst;
    private string _ResponseSecond;
    private string _ResponseThird;
    private string _TotalFirst;
    private string _TotalSecond;
    private string _TotalThird;
    private string _Resuscitation;
    private string _VitaminKGiven;
    private string _DATE;
    private string _DrExamining;
    private string _HeadSuturesFontanelles;
    private string _Hips;
    private string _Eyes;
    private string _Genitalia;
    private string _Ears;
    private string _Testes;
    private string _Palate;
    private string _Spine;
    private string _Neck;
    private string _LowerLimbs;
    private string _UpperLimbs;
    private string _Skin;
    private string _RSChest;
    private string _Tone;
    private string _CVS;
    private string _Movement;
    private string _Abdomen;
    private string _Moro;
    private string _FemoralPulses;
    private string _Grasp;
    private string _Anus;
    private string _Suck;
    private string _Comments;
    private string _MembranesRuptured;
    private string _Weight;
    private string _EyeOintmentGiven;
	 private string _babyUHID;
    private string _gender;
    private string _BabyID;
    private string _BtnType;
    private string _BabyChartID;

    private int _GaWeek;
    private int _GaDays;



    #endregion All Memory Variables
    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables
    #region Overloaded Constructor

    public BabyChart()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        //this.TransactionID = "LHSP1";
    }

    public BabyChart(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor
    #region Set All Property

    public virtual string Spine
    {
        get
        {
            return _Spine;
        }
        set
        {
            _Spine = value;
        }
    }
    public virtual string MembranesRuptured
    {
        get
        {
            return _MembranesRuptured;
        }
        set
        {
            _MembranesRuptured = value;
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
    public virtual string BloodGroup
    {
        get
        {
            return _BloodGroup;
        }
        set
        {
            _BloodGroup = value;
        }
    }

    public virtual string ObstetricHistory
    {
        get
        {
            return _ObstetricHistory;
        }
        set
        {
            _ObstetricHistory = value;
        }
    }

    public virtual string FamilyHistory
    {
        get
        {
            return _FamilyHistory;
        }
        set
        {
            _FamilyHistory = value;
        }
    }

    public virtual string MedicalHistory
    {
        get
        {
            return _MedicalHistory;
        }
        set
        {
            _MedicalHistory = value;
        }
    }

    public virtual string LMP
    {
        get
        {
            return _LMP;
        }
        set
        {
            _LMP = value;
        }
    }

    public virtual string EDDByDate
    {
        get
        {
            return _EDDByDate;
        }
        set
        {
            _EDDByDate = value;
        }
    }
    public virtual string EDDByScan
    {
        get
        {
            return _EDDByScan;
        }
        set
        {
            _EDDByScan = value;
        }
    }

    public virtual string AntenatalCare
    {
        get
        {
            return _AntenatalCare;
        }
        set
        {
            _AntenatalCare = value;
        }
    }
    public virtual string BookingDate
    {
        get
        {
            return _BookingDate;
        }
        set
        {
            _BookingDate = value;
        }
    }

    public virtual string SmokesPerDay
    {
        get
        {
            return _SmokesPerDay;
        }
        set
        {
            _SmokesPerDay = value;
        }
    }

    public virtual string Alcohol
    {
        get
        {
            return _Alcohol;
        }
        set
        {
            _Alcohol = value;
        }
    }

    public virtual string DurationOfLabourFirstStage
    {
        get
        {
            return _DurationOfLabourFirstStage;
        }
        set
        {
            _DurationOfLabourFirstStage = value;
        }
    }

    public virtual string DurationOfLabourSecondStage
    {
        get
        {
            return _DurationOfLabourSecondStage;
        }
        set
        {
            _DurationOfLabourSecondStage = value;
        }
    }

    public virtual string DurationOfLabourThirdStage
    {
        get
        {
            return _DurationOfLabourThirdStage;
        }
        set
        {
            _DurationOfLabourThirdStage = value;
        }
    }
    public virtual string AntenatalProblemsAndDrugs
    {
        get
        {
            return _AntenatalProblemsAndDrugs;
        }
        set
        {
            _AntenatalProblemsAndDrugs = value;
        }
    }
    public virtual string Amnio
    {
        get
        {
            return _Amnio;
        }
        set
        {
            _Amnio = value;
        }
    }
    public virtual string Result
    {
        get
        {
            return _Result;
        }
        set
        {
            _Result = value;
        }
    }
    public virtual string AntenalSteroids
    {
        get
        {
            return _AntenalSteroids;
        }
        set
        {
            _AntenalSteroids = value;
        }
    }
    public virtual string Placenta
    {
        get
        {
            return _Placenta;
        }
        set
        {
            _Placenta = value;
        }
    }
    public virtual string DeliveryMode
    {
        get
        {
            return _DeliveryMode;
        }
        set
        {
            _DeliveryMode = value;
        }
    }
    public virtual string Indication
    {
        get
        {
            return _Indication;
        }
        set
        {
            _Indication = value;
        }
    }
    public virtual string Length
    {
        get
        {
            return _Length;
        }
        set
        {
            _Length = value;
        }
    }
    public virtual string OFC
    {
        get
        {
            return _OFC;
        }
        set
        {
            _OFC = value;
        }
    }
    public virtual string GestationDate
    {
        get
        {
            return _GestationDate;
        }
        set
        {
            _GestationDate = value;
        }
    }
    public virtual string GestationScan
    {
        get
        {
            return _GestationScan;
        }
        set
        {
            _GestationScan = value;
        }
    }
    public virtual string Dubowitz
    {
        get
        {
            return _Dubowitz;
        }
        set
        {
            _Dubowitz = value;
        }
    }
    public virtual string ApgarScoreFirst
    {
        get
        {
            return _ApgarScoreFirst;
        }
        set
        {
            _ApgarScoreFirst = value;
        }
    }
    public virtual string ApgarScoreSecond
    {
        get
        {
            return _ApgarScoreSecond;
        }
        set
        {
            _ApgarScoreSecond = value;
        }
    }
    public virtual string ApgarScoreThird
    {
        get
        {
            return _ApgarScoreThird;
        }
        set
        {
            _ApgarScoreThird = value;
        }
    }
    public virtual string ColourFirst
    {
        get
        {
            return _ColourFirst;
        }
        set
        {
            _ColourFirst = value;
        }
    }
    public virtual string ColourSecond
    {
        get
        {
            return _ColourSecond;
        }
        set
        {
            _ColourSecond = value;
        }
    }
    public virtual string ColourThird
    {
        get
        {
            return _ColourThird;
        }
        set
        {
            _ColourThird = value;
        }
    }
    public virtual string HeartRateFirst
    {
        get
        {
            return _HeartRateFirst;
        }
        set
        {
            _HeartRateFirst = value;
        }
    }
    public virtual string HeartRateSecond
    {
        get
        {
            return _HeartRateSecond;
        }
        set
        {
            _HeartRateSecond = value;
        }
    }
    public virtual string HeartRateThird
    {
        get
        {
            return _HeartRateThird;
        }
        set
        {
            _HeartRateThird = value;
        }
    }
    public virtual string RespirationFirst
    {
        get
        {
            return _RespirationFirst;
        }
        set
        {
            _RespirationFirst = value;
        }
    }
    public virtual string RespirationSecond
    {
        get
        {
            return _RespirationSecond;
        }
        set
        {
            _RespirationSecond = value;
        }
    }
    public virtual string RespirationThird
    {
        get
        {
            return _RespirationThird;
        }
        set
        {
            _RespirationThird = value;
        }
    }
    public virtual string ToneFirst
    {
        get
        {
            return _ToneFirst;
        }
        set
        {
            _ToneFirst = value;
        }
    }
    public virtual string ToneSecond
    {
        get
        {
            return _ToneSecond;
        }
        set
        {
            _ToneSecond = value;
        }
    }
    public virtual string ToneThird
    {
        get
        {
            return _ToneThird;
        }
        set
        {
            _ToneThird = value;
        }
    }
    public virtual string ResponseFirst
    {
        get
        {
            return _ResponseFirst;
        }
        set
        {
            _ResponseFirst = value;
        }
    }
    public virtual string ResponseSecond
    {
        get
        {
            return _ResponseSecond;
        }
        set
        {
            _ResponseSecond = value;
        }
    }
    public virtual string ResponseThird
    {
        get
        {
            return _ResponseThird;
        }
        set
        {
            _ResponseThird = value;
        }
    }
    public virtual string TotalFirst
    {
        get
        {
            return _TotalFirst;
        }
        set
        {
            _TotalFirst = value;
        }
    }
    public virtual string TotalSecond
    {
        get
        {
            return _TotalSecond;
        }
        set
        {
            _TotalSecond = value;
        }
    }
    public virtual string TotalThird
    {
        get
        {
            return _TotalThird;
        }
        set
        {
            _TotalThird = value;
        }
    }
    public virtual string Resuscitation
    {
        get
        {
            return _Resuscitation;
        }
        set
        {
            _Resuscitation = value;
        }
    }
    public virtual string VitaminKGiven
    {
        get
        {
            return _VitaminKGiven;
        }
        set
        {
            _VitaminKGiven = value;
        }
    }
    public virtual string DATE
    {
        get
        {
            return _DATE;
        }
        set
        {
            _DATE = value;
        }
    }
    public virtual string DrExamining
    {
        get
        {
            return _DrExamining;
        }
        set
        {
            _DrExamining = value;
        }
    }
    public virtual string HeadSuturesFontanelles
    {
        get
        {
            return _HeadSuturesFontanelles;
        }
        set
        {
            _HeadSuturesFontanelles = value;
        }
    }
    public virtual string Hips
    {
        get
        {
            return _Hips;
        }
        set
        {
            _Hips = value;
        }
    }
    public virtual string Eyes
    {
        get
        {
            return _Eyes;
        }
        set
        {
            _Eyes = value;
        }
    }
    public virtual string Genitalia
    {
        get
        {
            return _Genitalia;
        }
        set
        {
            _Genitalia = value;
        }
    }
    public virtual string Ears
    {
        get
        {
            return _Ears;
        }
        set
        {
            _Ears = value;
        }
    }
    public virtual string Testes
    {
        get
        {
            return _Testes;
        }
        set
        {
            _Testes = value;
        }
    }
    public virtual string Palate
    {
        get
        {
            return _Palate;
        }
        set
        {
            _Palate = value;
        }
    }
    public virtual string Neck
    {
        get
        {
            return _Neck;
        }
        set
        {
            _Neck = value;
        }
    }
    public virtual string LowerLimbs
    {
        get
        {
            return _LowerLimbs;
        }
        set
        {
            _LowerLimbs = value;
        }
    }
    public virtual string UpperLimbs
    {
        get
        {
            return _UpperLimbs;
        }
        set
        {
            _UpperLimbs = value;
        }
    }
    public virtual string Skin
    {
        get
        {
            return _Skin;
        }
        set
        {
            _Skin = value;
        }
    }
    public virtual string RSChest
    {
        get
        {
            return _RSChest;
        }
        set
        {
            _RSChest = value;
        }
    }
    public virtual string Tone
    {
        get
        {
            return _Tone;
        }
        set
        {
            _Tone = value;
        }
    }
    public virtual string CVS
    {
        get
        {
            return _CVS;
        }
        set
        {
            _CVS = value;
        }
    }
    public virtual string Movement
    {
        get
        {
            return _Movement;
        }
        set
        {
            _Movement = value;
        }
    }
    public virtual string Abdomen
    {
        get
        {
            return _Abdomen;
        }
        set
        {
            _Abdomen = value;
        }
    }
    public virtual string Moro
    {
        get
        {
            return _Moro;
        }
        set
        {
            _Moro = value;
        }
    }
    public virtual string FemoralPulses
    {
        get
        {
            return _FemoralPulses;
        }
        set
        {
            _FemoralPulses = value;
        }
    }
    public virtual string Grasp
    {
        get
        {
            return _Grasp;
        }
        set
        {
            _Grasp = value;
        }
    }
    public virtual string Anus
    {
        get
        {
            return _Anus;
        }
        set
        {
            _Anus = value;
        }
    }
    public virtual string Suck
    {
        get
        {
            return _Suck;
        }
        set
        {
            _Suck = value;
        }
    }
    public virtual string Comments
    {
        get
        {
            return _Comments;
        }
        set
        {
            _Comments = value;
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

    public virtual string EyeOintmentGiven
    {
        get
        {
            return _EyeOintmentGiven;
        }
        set
        {
            _EyeOintmentGiven = value;
        }
    }
public virtual string babyUHID
    {
        get
        {
            return _babyUHID;
        }
        set
        {
            _babyUHID = value;
        }
    }
    public virtual string gender
    {
        get
        {
            return _gender;
        }
        set
        {
            _gender = value;
        }
    }

    public virtual string BabyID
    {
        get
        {
            return _BabyID;
        }
        set
        {
            _BabyID = value;
        }
    }
    public virtual string BtnType
    {
        get
        {
            return _BtnType;
        }
        set
        {
            _BtnType = value;
        }
    }
    public virtual string BabyChartID
    {
        get
        {
            return _BabyChartID;
        }
        set
        {
            _BabyChartID = value;
        }
    }

    public virtual int GaWeek
    {
        get
        {
            return _GaWeek;
        }
        set
        {
            _GaWeek = value;
        }
    }

    public virtual int GaDays
    {
        get
        {
            return _GaDays;
        }
        set
        {
            _GaDays = value;
        }
    }

    #endregion Set All Property
    #region All Public Member Function
    public int Insert()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            int count=0;
            if (BabyChartID != "")
            {
                count = Util.GetInt(StockReports.ExecuteScalar("Select COUNT(*) From baby_chart where TransactionID='" + TransactionID + "' and ID='" + BabyChartID + "' "));
            }
           
           if (count > 0)
            {
                objSQL.Append(" Update baby_chart set BloodGroup=@BloodGroup,ObstetricHistory=@ObstetricHistory,FamilyHistory=@FamilyHistory,MedicalHistory=@MedicalHistory,LMP=@LMP,EDDByDate=@EDDByDate,EDDByScan=@EDDByScan,AntenatalCare=@AntenatalCare,BookingDate=@BookingDate, ");
                objSQL.Append(" SmokesPerDay=@SmokesPerDay,Alcohol=@Alcohol,DurationOfLabourFirstStage=@DurationOfLabourFirstStage,DurationOfLabourSecondStage=@DurationOfLabourSecondStage,DurationOfLabourThirdStage=@DurationOfLabourThirdStage,AntenatalProblemsAndDrugs=@AntenatalProblemsAndDrugs, ");
                objSQL.Append(" Amnio=@Amnio,Result=@Result,AntenalSteroids=@AntenalSteroids,MembranesRuptured=@MembranesRuptured,Placenta=@Placenta,DeliveryMode=@DeliveryMode,Indication=@Indication,LENGTH=@Length,OFC=@OFC,GestationDate=@GestationDate,GestationScan=@GestationScan,Dubowitz=@Dubowitz,ApgarScoreFirst=@ApgarScoreFirst, ");
                objSQL.Append(" ApgarScoreSecond=@ApgarScoreSecond,ApgarScoreThird=@ApgarScoreThird,ColourFirst=@ColourFirst,ColourSecond=@ColourSecond,ColourThird=@ColourThird,HeartRateFirst=@HeartRateFirst,HeartRateSecond=@HeartRateSecond,HeartRateThird=@HeartRateThird,RespirationFirst=@RespirationFirst, ");
                objSQL.Append(" RespirationSecond=@RespirationSecond,RespirationThird=@RespirationThird,ToneFirst=@ToneFirst,ToneSecond=@ToneSecond,ToneThird=@ToneThird,ResponseFirst=@ResponseFirst,ResponseSecond=@ResponseSecond,ResponseThird=@ResponseThird,TotalFirst=@TotalFirst,TotalSecond=@TotalSecond, ");
                objSQL.Append(" TotalThird=@TotalThird,Resuscitation=@Resuscitation,VitaminKGiven=@VitaminKGiven,DATE=@DATE,DrExamining=@DrExamining,HeadSuturesFontanelles=@HeadSuturesFontanelles,Hips=@Hips,Eyes=@Eyes,Genitalia=@Genitalia,Ears=@Ears,Testes=@Testes,Palate=@Palate,Spine=@Spine,Neck=@Neck, ");
                objSQL.Append(" LowerLimbs=@LowerLimbs,UpperLimbs=@UpperLimbs,Skin=@Skin,RSChest=@RSChest,Tone=@Tone,CVS=@CVS,Movement=@Movement,Abdomen=@Abdomen,Moro=@Moro,FemoralPulses=@FemoralPulses,Grasp=@Grasp,Anus=@Anus,Suck=@Suck,Comments=@Comments,Weight=@Weight,EyeOintmentGiven=@EyeOintmentGiven,BabyGender=@BabyGender,GaWeek=@GaWeek,GaDays=@GaDays ");
                objSQL.Append(" where TransactionID = @TransactionID and ID='"+BabyChartID+"'");
            }
            else
            {
                objSQL.Append(" INSERT INTO baby_chart(TransactionID,BloodGroup,ObstetricHistory,FamilyHistory,MedicalHistory,LMP,EDDByDate,EDDByScan,AntenatalCare,BookingDate, ");
                objSQL.Append(" SmokesPerDay,Alcohol,DurationOfLabourFirstStage,DurationOfLabourSecondStage,DurationOfLabourThirdStage,AntenatalProblemsAndDrugs, ");
                objSQL.Append(" Amnio,Result,AntenalSteroids,MembranesRuptured,Placenta,DeliveryMode,Indication,LENGTH,OFC,GestationDate,GestationScan,Dubowitz,ApgarScoreFirst, ");
                objSQL.Append(" ApgarScoreSecond,ApgarScoreThird,ColourFirst,ColourSecond,ColourThird,HeartRateFirst,HeartRateSecond,HeartRateThird,RespirationFirst, ");
                objSQL.Append(" RespirationSecond,RespirationThird,ToneFirst,ToneSecond,ToneThird,ResponseFirst,ResponseSecond,ResponseThird,TotalFirst,TotalSecond, ");
                objSQL.Append(" TotalThird,Resuscitation,VitaminKGiven,DATE,DrExamining,HeadSuturesFontanelles,Hips,Eyes,Genitalia,Ears,Testes,Palate,Spine,Neck, ");
                objSQL.Append(" LowerLimbs,UpperLimbs,Skin,RSChest,Tone,CVS,Movement,Abdomen,Moro,FemoralPulses,Grasp,Anus,Suck,Comments,Weight,EyeOintmentGiven,BabyUHID,BabyGender,GaWeek,GaDays) ");
                objSQL.Append(" VALUES ( @TransactionID,@BloodGroup,@ObstetricHistory,@FamilyHistory,@MedicalHistory,@LMP,@EDDByDate,@EDDByScan,@AntenatalCare,@BookingDate,@SmokesPerDay,@Alcohol,@DurationOfLabourFirstStage,@DurationOfLabourSecondStage,@DurationOfLabourThirdStage,@AntenatalProblemsAndDrugs,@Amnio,@MembranesRuptured,@Result,@AntenalSteroids,@Placenta,@DeliveryMode,@Indication,@Length,@OFC,@GestationDate,@GestationScan,@Dubowitz,@ApgarScoreFirst,@ApgarScoreSecond,@ApgarScoreThird,@ColourFirst,@ColourSecond,@ColourThird,@HeartRateFirst,@HeartRateSecond,@HeartRateThird,@RespirationFirst,@RespirationSecond,@RespirationThird,@ToneFirst,@ToneSecond,@ToneThird,@ResponseFirst,@ResponseSecond,@ResponseThird,@TotalFirst,@TotalSecond,@TotalThird,@Resuscitation,@VitaminKGiven,@DATE,@DrExamining,@HeadSuturesFontanelles,@Hips,@Eyes,@Genitalia,@Ears,@Testes,@Palate,@Spine,@Neck,@LowerLimbs,@UpperLimbs,@Skin,@RSChest,@Tone,@CVS,@Movement,@Abdomen,@Moro,@FemoralPulses,@Grasp,@Anus,@Suck,@Comments,@Weight,@EyeOintmentGiven,@BabyUHID,@BabyGender,@GaWeek,@GaDays) ");
            }

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.TransactionID = Util.GetString(TransactionID);
            this.BloodGroup = Util.GetString(BloodGroup);
            this.ObstetricHistory = Util.GetString(ObstetricHistory);
            this.FamilyHistory = Util.GetString(FamilyHistory);
            this.MedicalHistory = Util.GetString(MedicalHistory);
            this.LMP = Util.GetString(LMP);
            this.EDDByDate = EDDByDate;
            this.EDDByScan = Util.GetString(EDDByScan);
            this.AntenatalCare = Util.GetString(AntenatalCare);
            this.BookingDate = BookingDate;
            this.SmokesPerDay = Util.GetString(SmokesPerDay);
            this.Alcohol = Util.GetString(Alcohol);
            this.DurationOfLabourFirstStage = Util.GetString(DurationOfLabourFirstStage);
            this.DurationOfLabourSecondStage = Util.GetString(DurationOfLabourSecondStage);
            this.DurationOfLabourThirdStage = Util.GetString(DurationOfLabourThirdStage);
            this.AntenatalProblemsAndDrugs = Util.GetString(AntenatalProblemsAndDrugs);
            this.Amnio = Util.GetString(Amnio);
            this.Result = Util.GetString(Result);
            this.AntenalSteroids = Util.GetString(AntenalSteroids);
            this.MembranesRuptured = Util.GetString(MembranesRuptured);
            this.Placenta = Util.GetString(Placenta);
            this.DeliveryMode = Util.GetString(DeliveryMode);
            this.Indication = Util.GetString(Indication);
            this.Length = Util.GetString(Length);
            this.OFC = Util.GetString(OFC);
            this.GestationDate = GestationDate;
            this.GestationScan = Util.GetString(GestationScan);
            this.Dubowitz = Util.GetString(Dubowitz);
            this.ApgarScoreFirst = Util.GetString(ApgarScoreFirst);
            this.ApgarScoreSecond = Util.GetString(ApgarScoreSecond);
            this.ApgarScoreThird = Util.GetString(ApgarScoreThird);
            this.ColourFirst = Util.GetString(ColourFirst);
            this.ColourSecond = Util.GetString(ColourSecond);
            this.ColourThird = Util.GetString(ColourThird);
            this.HeartRateFirst = Util.GetString(HeartRateFirst);
            this.HeartRateSecond = Util.GetString(HeartRateSecond);
            this.HeartRateThird = Util.GetString(HeartRateThird);
            this.RespirationFirst = Util.GetString(RespirationFirst);
            this.RespirationSecond = Util.GetString(RespirationSecond);
            this.RespirationThird = Util.GetString(RespirationThird);
            this.ToneFirst = Util.GetString(ToneFirst);
            this.ToneSecond = Util.GetString(ToneSecond);
            this.ToneThird = Util.GetString(ToneThird);
            this.ResponseFirst = Util.GetString(ResponseFirst);
            this.ResponseSecond = Util.GetString(ResponseSecond);
            this.ResponseThird = Util.GetString(ResponseThird);
            this.TotalFirst = Util.GetString(TotalFirst);
            this.TotalSecond = Util.GetString(TotalSecond);
            this.TotalThird = Util.GetString(TotalThird);
            this.Resuscitation = Util.GetString(Resuscitation);
            this.VitaminKGiven = Util.GetString(VitaminKGiven);
            this.DATE = DATE;
            this.HeadSuturesFontanelles = Util.GetString(HeadSuturesFontanelles);
            this.Hips = Util.GetString(Hips);
            this.Eyes = Util.GetString(Eyes);
            this.Genitalia = Util.GetString(Genitalia);
            this.Ears = Util.GetString(Ears);
            this.Testes = Util.GetString(Testes);
            this.Palate = Util.GetString(Palate);
            this.Spine = Util.GetString(Spine);
            this.Neck = Util.GetString(Neck);
            this.LowerLimbs = Util.GetString(LowerLimbs);
            this.UpperLimbs = Util.GetString(UpperLimbs);
            this.Skin = Util.GetString(Skin);
            this.RSChest = Util.GetString(RSChest);
            this.Tone = Util.GetString(Tone);
            this.CVS = Util.GetString(CVS);
            this.Movement = Util.GetString(Movement);
            this.Abdomen = Util.GetString(Abdomen);
            this.Moro = Util.GetString(Moro);
            this.FemoralPulses = Util.GetString(FemoralPulses);
            this.Grasp = Util.GetString(Grasp);
            this.Anus = Util.GetString(Anus);
            this.Suck = Util.GetString(Suck);
            this.Comments = Util.GetString(Comments);
            this.Weight = Util.GetString(Weight);
            this.EyeOintmentGiven = Util.GetString(EyeOintmentGiven);
			this.babyUHID = Util.GetString(babyUHID);
            this.gender = Util.GetString(gender);
            this.GaWeek = Util.GetInt(GaWeek);
            this.GaDays = Util.GetInt(GaDays);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
            new MySqlParameter("@TransactionID", TransactionID),
            new MySqlParameter("@BloodGroup", BloodGroup),
            new MySqlParameter("@ObstetricHistory", ObstetricHistory),
            new MySqlParameter("@FamilyHistory", FamilyHistory),
            new MySqlParameter("@MedicalHistory", MedicalHistory),
            new MySqlParameter("@LMP", LMP),
            new MySqlParameter("@EDDByDate", Util.GetDateTime(EDDByDate).ToString("yyyy-MM-dd")),
            new MySqlParameter("@EDDByScan", EDDByScan),
            new MySqlParameter("@AntenatalCare", AntenatalCare),
            new MySqlParameter("@BookingDate", Util.GetDateTime(BookingDate).ToString("yyyy-MM-dd")),
            new MySqlParameter("@SmokesPerDay", SmokesPerDay),
            new MySqlParameter("@Alcohol", Alcohol),
            new MySqlParameter("@DurationOfLabourFirstStage", DurationOfLabourFirstStage),
            new MySqlParameter("@DurationOfLabourSecondStage", DurationOfLabourSecondStage),
            new MySqlParameter("@DurationOfLabourThirdStage", DurationOfLabourThirdStage),
            new MySqlParameter("@AntenatalProblemsAndDrugs", AntenatalProblemsAndDrugs),
            new MySqlParameter("@Amnio", Amnio),
            new MySqlParameter("@Result", Result),
            new MySqlParameter("@MembranesRuptured", MembranesRuptured),
            new MySqlParameter("@AntenalSteroids", AntenalSteroids),
            new MySqlParameter("@Placenta", Placenta),
            new MySqlParameter("@DeliveryMode", DeliveryMode),
            new MySqlParameter("@Indication", Indication),
            new MySqlParameter("@Length", Length),
            new MySqlParameter("@OFC", OFC),
            new MySqlParameter("@GestationDate", Util.GetDateTime(GestationDate).ToString("yyyy-MM-dd")),
            new MySqlParameter("@GestationScan", GestationScan),
            new MySqlParameter("@Dubowitz", Dubowitz),
            new MySqlParameter("@ApgarScoreFirst", ApgarScoreFirst),
            new MySqlParameter("@ApgarScoreSecond", ApgarScoreSecond),
            new MySqlParameter("@ApgarScoreThird", ApgarScoreThird),
            new MySqlParameter("@ColourFirst", ColourFirst),
            new MySqlParameter("@ColourSecond", ColourSecond),
            new MySqlParameter("@ColourThird", ColourThird),
            new MySqlParameter("@HeartRateFirst", HeartRateFirst),
            new MySqlParameter("@HeartRateSecond", HeartRateSecond),
            new MySqlParameter("@HeartRateThird", HeartRateThird),
            new MySqlParameter("@RespirationFirst", RespirationFirst),
            new MySqlParameter("@RespirationSecond", RespirationSecond),
            new MySqlParameter("@RespirationThird", RespirationThird),
            new MySqlParameter("@ToneFirst", ToneFirst),
            new MySqlParameter("@ToneSecond", ToneSecond),
            new MySqlParameter("@ToneThird", ToneThird),
            new MySqlParameter("ResponseFirst", ResponseFirst),
            new MySqlParameter("@ResponseSecond", ResponseSecond),
            new MySqlParameter("@ResponseThird", ResponseThird),
            new MySqlParameter("@TotalFirst", TotalFirst),
            new MySqlParameter("@TotalSecond", TotalSecond),
            new MySqlParameter("@TotalThird", TotalThird),
            new MySqlParameter("@Resuscitation", Resuscitation),
            new MySqlParameter("@VitaminKGiven", VitaminKGiven),
            new MySqlParameter("@DATE", Util.GetDateTime(DATE).ToString("yyyy-MM-dd")),
            new MySqlParameter("@DrExamining", DrExamining),
            new MySqlParameter("@HeadSuturesFontanelles", HeadSuturesFontanelles),
            new MySqlParameter("@Hips", Hips),
            new MySqlParameter("@Eyes", Eyes),
            new MySqlParameter("@Genitalia", Genitalia),
            new MySqlParameter("@Ears", Ears),
            new MySqlParameter("@Testes", Testes),
            new MySqlParameter("@Palate", Palate),
            new MySqlParameter("@Spine", Spine),
            new MySqlParameter("@Neck", Neck),
            new MySqlParameter("@LowerLimbs", LowerLimbs),
            new MySqlParameter("@UpperLimbs", UpperLimbs),
            new MySqlParameter("@Skin", Skin),
            new MySqlParameter("@RSChest", RSChest),
            new MySqlParameter("@Tone", Tone),
            new MySqlParameter("@CVS", CVS),
            new MySqlParameter("@Movement", Movement),
            new MySqlParameter("@Abdomen", Abdomen),
            new MySqlParameter("@Moro", Moro),
            new MySqlParameter("@FemoralPulses", FemoralPulses),
            new MySqlParameter("@Grasp", Grasp),
            new MySqlParameter("@Anus", Anus),
            new MySqlParameter("@Suck", Suck),
            new MySqlParameter("@Comments", Comments),
            new MySqlParameter("@Weight", Weight),
            new MySqlParameter("@EyeOintmentGiven", EyeOintmentGiven),
			 new MySqlParameter("@BabyUHID", babyUHID),  
            new MySqlParameter("@BabyGender", gender),

             new MySqlParameter("@GaWeek", GaWeek),
            new MySqlParameter("@GaDays", GaDays)); 
			          

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