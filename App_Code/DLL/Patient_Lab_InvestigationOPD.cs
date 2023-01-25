using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class Patient_Lab_InvestigationOPD
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _LabInvestigationOPD_ID;
    private string _labinves_description;
    private string _TransactionID;
    private string _Test_ID;
    private string _Lab_ID;
    private System.DateTime _Date;
    private System.DateTime _Time;
    private string _Investigation_ID;
    private int _Special_Flag;
    private string _LabObservation_ID;
    private int _Result_Flag;
    private string _IsSampleCollected;
    private System.DateTime _SampleDate;
    private string _PatientID;
    private string _LedgerTransactionNo;
    private string _DoctorID;
    private string _Remarks;
    private string _IPNo;
    private int _IsUrgent;
    private int _IsPortable;
    
    private int _CentreID;
    private string _Hospital_ID;
    private int _LedgerTnxID;
    private int _IsOutSource;
    private string _OutSourceBy;
    private DateTime _OutsourceDate;
    private int _OutSourceLabID;
    private string _CurrentAge;
    private int _ReportDispatchModeID;
    private int _Type;
    private string _BarcodeNo;
    private int _BookingCentreID;
    private int _PrePrintedBarcode;
    private string _IPDCaseType_ID;
    private string _Room_ID;
    private string _sampletype;
    private int _SampleTypeID;
    private int _sampleCollectCentreID;
    private string _SampleCollectionBy;
    private DateTime _SampleCollectionDate;
    private string _SampleCollector;
    private DateTime _SampleReceiveDate;
    private string _SampleReceivedBy;
    private string _SampleReceiver;
    private int _HistoCytoSampleDetail;
    private DateTime _SCRequestdatetime;
    private System.DateTime _BookingDate;
    private string _BookingTime;
	
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Patient_Lab_InvestigationOPD()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }

    public Patient_Lab_InvestigationOPD(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string Location
    {
        get
        {
            return _Location;
        }
        set
        {
            _Location = value;
        }
    }

    public virtual string HospCode
    {
        get
        {
            return _HospCode;
        }
        set
        {
            _HospCode = value;
        }
    }

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

    public virtual string LabInvestigationOPD_ID
    {
        get
        {
            return _LabInvestigationOPD_ID;
        }
        set
        {
            _LabInvestigationOPD_ID = value;
        }
    }

    public virtual string labinves_description
    {
        get
        {
            return _labinves_description;
        }
        set
        {
            _labinves_description = value;
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

    public virtual string Test_ID
    {
        get
        {
            return _Test_ID;
        }
        set
        {
            _Test_ID = value;
        }
    }

    public virtual string Lab_ID
    {
        get
        {
            return _Lab_ID;
        }
        set
        {
            _Lab_ID = value;
        }
    }

    public virtual System.DateTime Date
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

    public virtual System.DateTime Time
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

    public virtual string Investigation_ID
    {
        get
        {
            return _Investigation_ID;
        }
        set
        {
            _Investigation_ID = value;
        }
    }

    public virtual int Special_Flag
    {
        get
        {
            return _Special_Flag;
        }
        set
        {
            _Special_Flag = value;
        }
    }

    public virtual string LabObservation_ID
    {
        get
        {
            return _LabObservation_ID;
        }
        set
        {
            _LabObservation_ID = value;
        }
    }

    public virtual int Result_Flag
    {
        get
        {
            return _Result_Flag;
        }
        set
        {
            _Result_Flag = value;
        }
    }

    public virtual string IsSampleCollected
    {
        get
        {
            return _IsSampleCollected;
        }
        set
        {
            _IsSampleCollected = value;
        }
    }

    public virtual DateTime SampleDate
    {
        get
        {
            return _SampleDate;
        }
        set
        {
            _SampleDate = value;
        }
    }

    public virtual string PatientID
    {
        get
        {
            return _PatientID;
        }
        set
        {
            _PatientID = value;
        }
    }

    public virtual string LedgerTransactionNo
    {
        get
        {
            return _LedgerTransactionNo;
        }
        set
        {
            _LedgerTransactionNo = value;
        }
    }

    public virtual string DoctorID
    {
        get
        {
            return _DoctorID;
        }
        set
        {
            _DoctorID = value;
        }
    }

    public virtual string Remarks
    {
        get
        {
            return _Remarks;
        }
        set
        {
            _Remarks = value;
        }
    }

    public virtual int IsUrgent
    {
        get
        {
            return _IsUrgent;
        }
        set
        {
            _IsUrgent = value;
        }
    }

    public virtual int IsPortable
    {
        get
        {
            return _IsPortable;
        }
        set
        {
            _IsPortable = value;
        }
    }

    public virtual string IPNo
    {
        get
        {
            return _IPNo;
        }
        set
        {
            _IPNo = value;
        }
    }

    public virtual int CentreID
    {
        get
        {
            return _CentreID;
        }
        set
        {
            _CentreID = value;
        }
    }

    public virtual string Hospital_ID
    {
        get
        {
            return _Hospital_ID;
        }
        set
        {
            _Hospital_ID = value;
        }
    }

    public virtual int LedgerTnxID
    {
        get
        {
            return _LedgerTnxID;
        }
        set
        {
            _LedgerTnxID = value;
        }
    }

    public virtual int IsOutSource
    {
        get
        {
            return _IsOutSource;
        }
        set
        {
            _IsOutSource = value;
        }
    }

    public virtual string OutSourceBy
    {
        get
        {
            return _OutSourceBy;
        }
        set
        {
            _OutSourceBy = value;
        }
    }

    public virtual DateTime OutsourceDate
    {
        get
        {
            return _OutsourceDate;
        }
        set
        {
            _OutsourceDate = value;
        }
    }

    public virtual int OutSourceLabID
    {
        get
        {
            return _OutSourceLabID;
        }
        set
        {
            _OutSourceLabID = value;
        }
    }


    public virtual int ReportDispatchModeID
    {
        get
        {
            return _ReportDispatchModeID;
        }
        set
        {
            _ReportDispatchModeID = value;
        }
    }

    public virtual string CurrentAge
    {
        get
        {
            return _CurrentAge;
        }
        set
        {
            _CurrentAge = value;
        }
    }
    public virtual int Type
    {
        get
        {
            return _Type;
        }
        set
        {
            _Type = value;
        }
    }
     public virtual string BarcodeNo
    {
        get
        {
            return _BarcodeNo;
        }
        set
        {
            _BarcodeNo = value;
        }
    }
     public virtual int BookingCentreID
     {
         get
         {
             return _BookingCentreID;
         }
         set
         {
             _BookingCentreID = value;
         }
     }
     public virtual int PrePrintedBarcode
     {
         get
         {
             return _PrePrintedBarcode;
         }
         set
         {
             _PrePrintedBarcode = value;
         }
     }

     public virtual string IPDCaseTypeID { get { return _IPDCaseType_ID; } set { _IPDCaseType_ID = value; } }
     public virtual string RoomID { get { return _Room_ID; } set { _Room_ID = value; } }
     public virtual string sampletype { get { return _sampletype; } set { _sampletype = value; } }
     public virtual int SampleTypeID { get { return _SampleTypeID; } set { _SampleTypeID = value; } }
     public virtual int sampleCollectCentreID { get { return _sampleCollectCentreID; } set { _sampleCollectCentreID = value; } }
     public virtual string SampleCollectionBy { get { return _SampleCollectionBy; } set { _SampleCollectionBy = value; } }
     public virtual DateTime SampleCollectionDate { get { return _SampleCollectionDate; } set { _SampleCollectionDate = value; } }
     public virtual string SampleCollector { get { return _SampleCollector; } set { _SampleCollector = value; } }
     public virtual DateTime SampleReceiveDate { get { return _SampleReceiveDate; } set { _SampleReceiveDate = value; } }
     public virtual string SampleReceivedBy { get { return _SampleReceivedBy; } set { _SampleReceivedBy = value; } }
     public virtual string SampleReceiver { get { return _SampleReceiver; } set { _SampleReceiver = value; } }
     public virtual int HistoCytoSampleDetail { get { return _HistoCytoSampleDetail; } set { _HistoCytoSampleDetail = value; } }
     public DateTime SCRequestdatetime
     {
         get { return _SCRequestdatetime; }
         set { _SCRequestdatetime = value; }
     }

     public virtual System.DateTime BookingDate { get { return _BookingDate; } set { _BookingDate = value; } }

     public virtual string BookingTime { get { return _BookingTime; } set { _BookingTime = value; } }


    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Lab_InvestigationOPD");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ID";
            paramTnxID.MySqlDbType = MySqlDbType.Int32;
            paramTnxID.Size = 10;
            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;
            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.TransactionID = Util.GetString(TransactionID);
            this.Lab_ID = Util.GetString(Lab_ID);
            this.Date = Util.GetDateTime(Date);
            this.Time = Util.GetDateTime(Time);
            this.Investigation_ID = Util.GetString(Investigation_ID);
            this.Special_Flag = Util.GetInt(Special_Flag);
            this.LabObservation_ID = Util.GetString(LabObservation_ID);
            this.Result_Flag = Util.GetInt(Result_Flag);
            this.IsSampleCollected = Util.GetString(IsSampleCollected);
            this.SampleDate = Util.GetDateTime(SampleDate);
            this.PatientID = Util.GetString(PatientID);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.DoctorID = Util.GetString(DoctorID);
            this.Remarks = Util.GetString(Remarks);
            this.IsUrgent = Util.GetInt(IsUrgent);
            this.IsPortable = Util.GetInt(IsPortable);
            this.IPNo = Util.GetString(IPNo);
            this.CentreID = Util.GetInt(CentreID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.LedgerTnxID = Util.GetInt(LedgerTnxID);
            this.IsOutSource = Util.GetInt(IsOutSource);
            this.OutSourceBy = Util.GetString(OutSourceBy);
            this.OutsourceDate = Util.GetDateTime(OutsourceDate);
            this.OutSourceLabID = Util.GetInt(OutSourceLabID);
            this.CurrentAge = Util.GetString(CurrentAge);
            this.ReportDispatchModeID = Util.GetInt(ReportDispatchModeID);
            this.Type = Util.GetInt(Type);
            this.BarcodeNo = Util.GetString(BarcodeNo);
            this.BookingCentreID = Util.GetInt(BookingCentreID);
            this.PrePrintedBarcode = Util.GetInt(PrePrintedBarcode);
            this.IPDCaseTypeID = Util.GetString(IPDCaseTypeID);
            this.RoomID = Util.GetString(RoomID);
            this.sampletype = Util.GetString(sampletype);
            this.SampleTypeID = Util.GetInt(SampleTypeID);
            this.sampleCollectCentreID = Util.GetInt(sampleCollectCentreID);
            this.SampleCollectionBy = Util.GetString(SampleCollectionBy);
            this.SampleCollectionDate = Util.GetDateTime(SampleCollectionDate);
            this.SampleCollector = Util.GetString(SampleCollector);
            this.SampleReceiveDate = Util.GetDateTime(SampleReceiveDate);
            this.SampleReceivedBy = Util.GetString(SampleReceivedBy);
            this.SampleReceiver = Util.GetString(SampleReceiver);
            this.HistoCytoSampleDetail = Util.GetInt(HistoCytoSampleDetail);
            this.BookingDate = Util.GetDateTime(BookingDate);
            this.BookingTime = Util.GetString(BookingTime);
            this.SCRequestdatetime = Util.GetDateTime(SCRequestdatetime);
			
            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Tran_ID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@Lab_ID", Lab_ID));
            cmd.Parameters.Add(new MySqlParameter("@iDate", Date));
            cmd.Parameters.Add(new MySqlParameter("@iTime", Time));
            cmd.Parameters.Add(new MySqlParameter("@Investigation_ID", Investigation_ID));
            cmd.Parameters.Add(new MySqlParameter("@SpecialFlag", Special_Flag));
            cmd.Parameters.Add(new MySqlParameter("@Observation_ID", LabObservation_ID));
            cmd.Parameters.Add(new MySqlParameter("@Result_Flag", Result_Flag));
            cmd.Parameters.Add(new MySqlParameter("@IsSampleCollected", IsSampleCollected));
            cmd.Parameters.Add(new MySqlParameter("@SampleDate", SampleDate));
            cmd.Parameters.Add(new MySqlParameter("@PatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@DoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@Remarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@IsUrgent", Util.GetString(IsUrgent)));
            cmd.Parameters.Add(new MySqlParameter("@IsPortable", Util.GetString(IsPortable)));
            
            cmd.Parameters.Add(new MySqlParameter("@IPNo", Util.GetString(IPNo)));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", Util.GetInt(CentreID)));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Util.GetString(Hospital_ID)));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTnxID", Util.GetInt(LedgerTnxID)));
            cmd.Parameters.Add(new MySqlParameter("@IsOutSource", Util.GetInt(IsOutSource)));
            cmd.Parameters.Add(new MySqlParameter("@OutSourceBy", Util.GetString(OutSourceBy)));
            cmd.Parameters.Add(new MySqlParameter("@OutsourceDate", Util.GetDateTime(OutsourceDate)));
            cmd.Parameters.Add(new MySqlParameter("@OutSourceLabID", Util.GetInt(OutSourceLabID)));
            cmd.Parameters.Add(new MySqlParameter("@CurrentAge", Util.GetString(CurrentAge)));
            cmd.Parameters.Add(new MySqlParameter("@vReportDispatchModeID", Util.GetString(ReportDispatchModeID)));
            cmd.Parameters.Add(new MySqlParameter("@vType", Type));
            cmd.Parameters.Add(new MySqlParameter("@vBarcodeNo", BarcodeNo));
            cmd.Parameters.Add(new MySqlParameter("@vBookingCentreID", BookingCentreID));
            cmd.Parameters.Add(new MySqlParameter("@vPrePrintedBarcode", PrePrintedBarcode));
            cmd.Parameters.Add(new MySqlParameter("@vIPDCaseTypeID", IPDCaseTypeID));
            cmd.Parameters.Add(new MySqlParameter("@vRoomID", RoomID));
            cmd.Parameters.Add(new MySqlParameter("@vsampletype", sampletype));
            cmd.Parameters.Add(new MySqlParameter("@vSampleTypeID", SampleTypeID));

            cmd.Parameters.Add(new MySqlParameter("@vsampleCollectCentreID", sampleCollectCentreID));
            cmd.Parameters.Add(new MySqlParameter("@vSampleCollectionBy", SampleCollectionBy));
            cmd.Parameters.Add(new MySqlParameter("@vSampleCollectionDate", SampleCollectionDate));
            cmd.Parameters.Add(new MySqlParameter("@vSampleCollector", SampleCollector));
            cmd.Parameters.Add(new MySqlParameter("@vSampleReceiveDate", SampleReceiveDate));
            cmd.Parameters.Add(new MySqlParameter("@vSampleReceivedBy", SampleReceivedBy));
            cmd.Parameters.Add(new MySqlParameter("@vSampleReceiver", SampleReceiver));
            cmd.Parameters.Add(new MySqlParameter("@vHistoCytoSampleDetail", HistoCytoSampleDetail));
            cmd.Parameters.Add(new MySqlParameter("@vBookingDate", BookingDate));
            cmd.Parameters.Add(new MySqlParameter("@vBookingTime", BookingTime));
            cmd.Parameters.Add(new MySqlParameter("@vSCRequestdatetime", SCRequestdatetime));
			
            cmd.Parameters.Add(paramTnxID);

            iPkValue = Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);
            throw (ex);
        }
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE patient_labinvestigation_OPD SET Result_Flag=?, labinves_description =? WHERE LabInvestigationOPD_ID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Result_Flag", Result_Flag),
                new MySqlParameter("@labinves_description", labinves_description),
                new MySqlParameter("@LabInvestigationOPD_ID", LabInvestigationOPD_ID));

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

    public int Delete(int iPkValue)
    {
        this.LabInvestigationOPD_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM patient_labinvestigation_OPD WHERE LabInvestigationOPD_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("LabInvestigationOPD_ID", LabInvestigationOPD_ID));
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return iRetValue;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);
            throw (ex);
        }
    }

    public bool Load()
    {
        DataTable dtTemp;

        try
        {
            string sSQL = "SELECT * FROM patient_labinvestigation_OPD WHERE LabInvestigationOPD_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@LabInvestigationOPD_ID", LabInvestigationOPD_ID)).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
                this.SetProperties(dtTemp);
                return true;
            }
            else
                return false;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            // Util.WriteLog(ex);
            string sParams = "LabInvestigationOPD_ID=" + this.LabInvestigationOPD_ID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }
    }

    public bool Load(int iPkValue)
    {
        this.LabInvestigationOPD_ID = iPkValue.ToString();
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.HospCode]);
        this.LabInvestigationOPD_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.LabInvestigationOPD_ID]);
        this.TransactionID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.TransactionID]);
        this.Test_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.Test_ID]);
        this.Lab_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.Lab_ID]);
        this.Date = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.Date]);
        this.Time = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.Time]);
        this.Investigation_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.Investigation_ID]);
        this.Special_Flag = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.Special_Flag]);
        this.LabObservation_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.LabObservation_ID]);
        this.Result_Flag = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.Result_Flag]);
        this.IsSampleCollected = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.IsSampleCollected]);
        this.SampleDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.SampleDate]);
        this.PatientID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.PatientID]);
        this.LedgerTransactionNo = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.LedgerTransactionNo]);
        this.DoctorID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.DoctorID]);
        this.Remarks = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationOPD.Remarks]);
    }

    #endregion Helper Private Function
}