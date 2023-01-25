using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class Patient_Lab_InvestigationIPD
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;

    private string _LabInvestigationIPD_ID;
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
    private int _Round_No;
    private string _IsSampleCollected;
    private System.DateTime _SampleDate;
    private string _LedgerTransactionNo;
    private string _LedgerTnxID;
    private string _PatientID;
    private string _SampleType;
    private string _DoctorID;
    private string _Remarks;

    private int _IsUrgent;
    private int _IsOutSource;
    private string _OutSourceBy;
    private DateTime _OutsourceDate;
    private string _Hospital_Id;
    private int _CentreID;
    private int _OutSourceLabID;
    private string _IPDCaseType_ID;
    private string _Room_ID;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Patient_Lab_InvestigationIPD()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        this.Location = AllGlobalFunction.Location;
        this.HospCode = AllGlobalFunction.HospCode;
    }

    public Patient_Lab_InvestigationIPD(MySqlTransaction objTrans)
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

    public virtual string LabInvestigationIPD_ID
    {
        get
        {
            return _LabInvestigationIPD_ID;
        }
        set
        {
            _LabInvestigationIPD_ID = value;
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

    public virtual int Round_No
    {
        get
        {
            return _Round_No;
        }
        set
        {
            _Round_No = value;
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

    public virtual string LedgerTnxID
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

    public virtual string SampleType
    {
        get
        {
            return _SampleType;
        }
        set
        {
            _SampleType = value;
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

    public virtual string Hospital_Id { get { return _Hospital_Id; } set { _Hospital_Id = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual string IPDCaseType_ID { get { return _IPDCaseType_ID; } set { _IPDCaseType_ID = value; } }
    public virtual string Room_ID { get { return _Room_ID; } set { _Room_ID = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Lab_InvestigationIPD");
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
            this.LabObservation_ID = Util.GetString(LabObservation_ID);
            this.Result_Flag = Util.GetInt(Result_Flag);
            this.IsSampleCollected = Util.GetString(IsSampleCollected);
            this.SampleDate = Util.GetDateTime(SampleDate);
            this.LedgerTransactionNo = Util.GetString(LedgerTransactionNo);
            this.LedgerTnxID = Util.GetString(LedgerTnxID);
            this.PatientID = Util.GetString(PatientID);
            this.SampleType = Util.GetString(SampleType);
            this.DoctorID = Util.GetString(DoctorID);
            this.Remarks = Util.GetString(Remarks);
            this.IsUrgent = Util.GetInt(IsUrgent);
            this.IsOutSource = Util.GetInt(IsOutSource);
            this.OutSourceBy = Util.GetString(OutSourceBy);
            this.OutsourceDate = Util.GetDateTime(OutsourceDate);
            this.Hospital_Id = Util.GetString(Hospital_Id);
            this.CentreID = Util.GetInt(CentreID);
            this.OutSourceLabID = Util.GetInt(OutSourceLabID);
            this.IPDCaseType_ID = Util.GetString(IPDCaseType_ID);
            this.Room_ID = Util.GetString(Room_ID);
            cmd.Parameters.Add(new MySqlParameter("@Loc", Location));
            cmd.Parameters.Add(new MySqlParameter("@Hosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@Tran_ID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@iLab_ID", Lab_ID));
            cmd.Parameters.Add(new MySqlParameter("@iDate", Date));
            cmd.Parameters.Add(new MySqlParameter("@iTime", Time));
            cmd.Parameters.Add(new MySqlParameter("@iInvestigation_ID", Investigation_ID));
            cmd.Parameters.Add(new MySqlParameter("@iObservation_ID", LabObservation_ID));
            cmd.Parameters.Add(new MySqlParameter("@iResult_Flag", Result_Flag));
            cmd.Parameters.Add(new MySqlParameter("@iIsSampleCollected", IsSampleCollected));
            cmd.Parameters.Add(new MySqlParameter("@iSampleDate", SampleDate));
            cmd.Parameters.Add(new MySqlParameter("@iLedgerTransactionNo", LedgerTransactionNo));
            cmd.Parameters.Add(new MySqlParameter("@iLedgerTnxID", LedgerTnxID));
            cmd.Parameters.Add(new MySqlParameter("@iPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@iSampleType", SampleType));
            cmd.Parameters.Add(new MySqlParameter("@iDoctorID", DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@Remarks", Remarks));

            cmd.Parameters.Add(new MySqlParameter("@IsUrgent", IsUrgent));
            cmd.Parameters.Add(new MySqlParameter("@IsOutSource", IsOutSource));
            cmd.Parameters.Add(new MySqlParameter("@OutSourceBy", OutSourceBy));
            cmd.Parameters.Add(new MySqlParameter("@OutsourceDate", OutsourceDate));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_Id", Hospital_Id));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@OutSourceLabID", OutSourceLabID));
            cmd.Parameters.Add(new MySqlParameter("@IPDCaseType_ID", IPDCaseType_ID));
            cmd.Parameters.Add(new MySqlParameter("@Room_ID", Room_ID));

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
            throw (ex);
        }
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE patient_labinvestigation_ipd SET Result_Flag=? , labinves_description =? WHERE LabInvestigationIPD_ID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                new MySqlParameter("@Result_Flag", Result_Flag),
                new MySqlParameter("@labinves_description", labinves_description),
                new MySqlParameter("@LabInvestigationIPD_ID", LabInvestigationIPD_ID));

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
            throw (ex);
        }
    }

    public int Delete(int iPkValue)
    {
        this.LabInvestigationIPD_ID = iPkValue.ToString();
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM patient_labinvestigation_ipd WHERE LabInvestigationIPD_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("LabInvestigationIPD_ID", LabInvestigationIPD_ID));
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

            throw (ex);
        }
    }

    public bool Load()
    {
        DataTable dtTemp;

        try
        {
            string sSQL = "SELECT * FROM patient_labinvestigation_ipd WHERE LabInvestigationIPD_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@LabInvestigationIPD_ID", LabInvestigationIPD_ID)).Tables[0];

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

            string sParams = "LabInvestigationIPD_ID=" + this.LabInvestigationIPD_ID.ToString();
            throw (ex);
        }
    }

    public bool Load(int iPkValue)
    {
        this.LabInvestigationIPD_ID = iPkValue.ToString();
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Location = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.Location]);
        this.HospCode = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.HospCode]);
        this.LabInvestigationIPD_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.LabInvestigationIPD_ID]);
        this.TransactionID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.TransactionID]);
        this.Test_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.Test_ID]);
        this.Lab_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.Lab_ID]);
        this.Date = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.Date]);
        this.Time = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.Time]);
        this.Investigation_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.Investigation_ID]);
        this.Special_Flag = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.Special_Flag]);
        this.LabObservation_ID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.LabObservation_ID]);
        this.Result_Flag = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.Result_Flag]);
        this.Round_No = Util.GetInt(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.Round_No]);
        this.IsSampleCollected = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.IsSampleCollected]);
        this.SampleDate = Util.GetDateTime(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.SampleDate]);
        this.LedgerTransactionNo = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.LedgerTransactionNo]);
        this.PatientID = Util.GetString(dtTemp.Rows[0][AllTables.Patient_Lab_InvestigationIPD.PatientID]);
    }

    #endregion Helper Private Function
}