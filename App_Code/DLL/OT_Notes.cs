using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for OT_Notes
/// </summary>
public class OT_Notes
{
    #region All Memory Variables

    private string _PatientID;
    private string _Transcation_ID;
    private string _LedgerTransactionNO;
    private DateTime _SurgeryBeganDate;
    private DateTime _SurgeryEndDate;
    private string _chkSDSAMS;
    private string _Location;
    private string _PreOpDiagnosis;
    private string _PostOpDiagnosis;
    private string _OperativeProcedures;
    private string _WoundClosure;
    private string _Remarks;
    private string _Anesthesia;
    private string _ImplantsDevices;
    private string _Pathology;
    private string _PathologyEntry;
    private string _Culture;
    private string _CultureLocation;
    private string _Ebl;
    private string _Fluids;
    private string _Drains;
    private string _Type;
    private string _Complication;
    private string _ComplicationEntry;
    private string _UserID;
    private string _procedures;
    private string _UpdateID;
    private DateTime _BornDate;
    private DateTime _BornTime;
    private string _Gender;
    private decimal _Weight;
    private decimal _Height;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public OT_Notes()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public OT_Notes(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

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

    public virtual string Transcation_ID
    {
        get
        {
            return _Transcation_ID;
        }

        set
        {
            _Transcation_ID = value;
        }
    }

    public virtual string LedgerTransactionNO
    {
        get
        {
            return _LedgerTransactionNO;
        }

        set
        {
            _LedgerTransactionNO = value;
        }
    }

    public virtual DateTime SurgeryBeganDate
    {
        get
        {
            return _SurgeryBeganDate;
        }

        set
        {
            _SurgeryBeganDate = value;
        }
    }

    public virtual DateTime SurgeryEndDate
    {
        get
        {
            return _SurgeryEndDate;
        }

        set
        {
            _SurgeryEndDate = value;
        }
    }

    public virtual string chkSDSAMS
    {
        get
        {
            return _chkSDSAMS;
        }

        set
        {
            _chkSDSAMS = value;
        }
    }

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

    public virtual string PreOpDiagnosis
    {
        get
        {
            return _PreOpDiagnosis;
        }

        set
        {
            _PreOpDiagnosis = value;
        }
    }

    public virtual string PostOpDiagnosis
    {
        get
        {
            return _PostOpDiagnosis;
        }

        set
        {
            _PostOpDiagnosis = value;
        }
    }

    public virtual string OperativeProcedures
    {
        get
        {
            return _OperativeProcedures;
        }

        set
        {
            _OperativeProcedures = value;
        }
    }

    public virtual string WoundClosure
    {
        get
        {
            return _WoundClosure;
        }

        set
        {
            _WoundClosure = value;
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

    public virtual string Anesthesia
    {
        get
        {
            return _Anesthesia;
        }

        set
        {
            _Anesthesia = value;
        }
    }

    public virtual string ImplantsDevices
    {
        get
        {
            return _ImplantsDevices;
        }

        set
        {
            _ImplantsDevices = value;
        }
    }

    public virtual string Pathology
    {
        get
        {
            return _Pathology;
        }

        set
        {
            _Pathology = value;
        }
    }

    public virtual string PathologyEntry
    {
        get
        {
            return _PathologyEntry;
        }

        set
        {
            _PathologyEntry = value;
        }
    }

    public virtual string Culture
    {
        get
        {
            return _Culture;
        }

        set
        {
            _Culture = value;
        }
    }

    public virtual string CultureLocation
    {
        get
        {
            return _CultureLocation;
        }

        set
        {
            _CultureLocation = value;
        }
    }

    public virtual string Ebl
    {
        get
        {
            return _Ebl;
        }

        set
        {
            _Ebl = value;
        }
    }

    public virtual string Fluids
    {
        get
        {
            return _Fluids;
        }

        set
        {
            _Fluids = value;
        }
    }

    public virtual string Drains
    {
        get
        {
            return _Drains;
        }

        set
        {
            _Drains = value;
        }
    }

    public virtual string Type
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

    public virtual string Complication
    {
        get
        {
            return _Complication;
        }

        set
        {
            _Complication = value;
        }
    }

    public virtual string ComplicationEntry
    {
        get
        {
            return _ComplicationEntry;
        }

        set
        {
            _ComplicationEntry = value;
        }
    }

    public virtual string UserID
    {
        get
        {
            return _UserID;
        }

        set
        {
            _UserID = value;
        }
    }

    public virtual string procedures
    {
        get
        {
            return _procedures;
        }

        set
        {
            _procedures = value;
        }
    }

    public virtual string UpdateID
    {
        get
        {
            return _UpdateID;
        }

        set
        {
            _UpdateID = value;
        }
    }

    public virtual string Gender
    {
        get
        {
            return _Gender;
        }

        set
        {
            _Gender = value;
        }
    }

    public virtual DateTime BornDate
    {
        get
        {
            return _BornDate;
        }

        set
        {
            _BornDate = value;
        }
    }

    public virtual DateTime BornTime
    {
        get
        {
            return _BornTime;
        }

        set
        {
            _BornTime = value;
        }
    }

    public virtual decimal Weight
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

    public virtual decimal Height
    {
        get
        {
            return _Height;
        }

        set
        {
            _Height = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            int iPkValue;

            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_OtNotes");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@@Identity";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);

            cmd.CommandType = CommandType.StoredProcedure;
            this.PatientID = Util.GetString(PatientID);
            this.Transcation_ID = Util.GetString(Transcation_ID);
            this.LedgerTransactionNO = Util.GetString(LedgerTransactionNO);
            this.SurgeryBeganDate = Util.GetDateTime(SurgeryBeganDate);
            this.SurgeryEndDate = Util.GetDateTime(SurgeryEndDate);
            this.chkSDSAMS = Util.GetString(chkSDSAMS);
            this.Location = Util.GetString(Location);
            this.PreOpDiagnosis = Util.GetString(PreOpDiagnosis);
            this.PostOpDiagnosis = Util.GetString(PostOpDiagnosis);
            this.OperativeProcedures = Util.GetString(OperativeProcedures);
            this.WoundClosure = Util.GetString(WoundClosure);
            this.Remarks = Util.GetString(Remarks);
            this.Anesthesia = Util.GetString(Anesthesia);
            this.ImplantsDevices = Util.GetString(ImplantsDevices);
            this.Pathology = Util.GetString(Pathology);
            this.PathologyEntry = Util.GetString(PathologyEntry);
            this.Culture = Util.GetString(Culture);
            this.CultureLocation = Util.GetString(CultureLocation);
            this.Ebl = Util.GetString(Ebl);
            this.Fluids = Util.GetString(Fluids);
            this.Drains = Util.GetString(Drains);
            this.Type = Util.GetString(Type);
            this.Complication = Util.GetString(Complication);
            this.ComplicationEntry = Util.GetString(ComplicationEntry);
            this.UserID = Util.GetString(UserID);
            this.procedures = Util.GetString(procedures);

            //Deevendra Singh 2016.03.04

            this.Gender = Util.GetString(Gender);
            this.BornDate = Util.GetDateTime(BornDate);
            this.BornTime = Util.GetDateTime(BornTime);
            this.Weight = Util.GetDecimal(Weight);
            this.Height = Util.GetDecimal(Height);

            cmd.Parameters.Add(new MySqlParameter("@_PatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@_Transcation_ID", Transcation_ID));
            cmd.Parameters.Add(new MySqlParameter("@_LedgerTransactionNO", LedgerTransactionNO));
            cmd.Parameters.Add(new MySqlParameter("@_SurgeryBeganDate", SurgeryBeganDate));
            cmd.Parameters.Add(new MySqlParameter("@_SurgeryEndDate", SurgeryEndDate));
            cmd.Parameters.Add(new MySqlParameter("@_chkSDSAMS", chkSDSAMS));
            cmd.Parameters.Add(new MySqlParameter("@_Location", Location));
            cmd.Parameters.Add(new MySqlParameter("@_PreOpDiagnosis", PreOpDiagnosis));
            cmd.Parameters.Add(new MySqlParameter("@_PostOpDiagnosis", PostOpDiagnosis));
            cmd.Parameters.Add(new MySqlParameter("@_OperativeProcedures", OperativeProcedures));
            cmd.Parameters.Add(new MySqlParameter("@_WoundClosure", WoundClosure));
            cmd.Parameters.Add(new MySqlParameter("@_Remarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@_Anesthesia", Anesthesia));

            cmd.Parameters.Add(new MySqlParameter("@_ImplantsDevices", ImplantsDevices));
            cmd.Parameters.Add(new MySqlParameter("@_Pathology", Pathology));
            cmd.Parameters.Add(new MySqlParameter("@_PathologyEntry", PathologyEntry));
            cmd.Parameters.Add(new MySqlParameter("@_Culture", Culture));
            cmd.Parameters.Add(new MySqlParameter("@_CultureLocation", CultureLocation));
            cmd.Parameters.Add(new MySqlParameter("@_Ebl", Ebl));
            cmd.Parameters.Add(new MySqlParameter("@_Fluids", Fluids));
            cmd.Parameters.Add(new MySqlParameter("@_Drains", Drains));
            cmd.Parameters.Add(new MySqlParameter("@_Type", Type));
            cmd.Parameters.Add(new MySqlParameter("@_Complication", Complication));
            cmd.Parameters.Add(new MySqlParameter("@_ComplicationEntry", ComplicationEntry));
            cmd.Parameters.Add(new MySqlParameter("@_UserID", UserID));
            cmd.Parameters.Add(new MySqlParameter("@_procedures", procedures));

            // Devendra Singh 2016.03.03

            cmd.Parameters.Add(new MySqlParameter("@_Gender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@_BornDate", BornDate));
            cmd.Parameters.Add(new MySqlParameter("@_BornTime", BornTime));
            cmd.Parameters.Add(new MySqlParameter("@_Weight", Weight));
            cmd.Parameters.Add(new MySqlParameter("@_Height", Height));

            cmd.Parameters.Add(paramTnxID);

            //cmd.ExecuteNonQuery();

            iPkValue = Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue.ToString();
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

    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_Otnotes_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vTranscation_ID", Util.GetString(Transcation_ID)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNo", Util.GetString(LedgerTransactionNO)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeryBeganDate", Util.GetDateTime(SurgeryBeganDate)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgeryEndDate", Util.GetDateTime(SurgeryEndDate)));
            cmd.Parameters.Add(new MySqlParameter("@vchkSDSAMS", Util.GetString(chkSDSAMS)));
            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vPreOpDiagnosis", Util.GetString(PreOpDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vPostOpDiagnosis", Util.GetString(PostOpDiagnosis)));
            cmd.Parameters.Add(new MySqlParameter("@vOperativeProcedures", Util.GetString(OperativeProcedures)));
            cmd.Parameters.Add(new MySqlParameter("@vWoundClosure", Util.GetString(WoundClosure)));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@vAnesthesia", Util.GetString(Anesthesia)));
            cmd.Parameters.Add(new MySqlParameter("@vImplantsDevices", Util.GetString(ImplantsDevices)));
            cmd.Parameters.Add(new MySqlParameter("@vPathology", Util.GetString(Pathology)));
            cmd.Parameters.Add(new MySqlParameter("@vPathologyEntry", Util.GetString(PathologyEntry)));
            cmd.Parameters.Add(new MySqlParameter("@vCulture", Util.GetString(Culture)));
            cmd.Parameters.Add(new MySqlParameter("@vCultureLocation", Util.GetString(CultureLocation)));
            cmd.Parameters.Add(new MySqlParameter("@vEbl", Util.GetString(Ebl)));
            cmd.Parameters.Add(new MySqlParameter("@vFluids", Util.GetString(Fluids)));
            cmd.Parameters.Add(new MySqlParameter("@vDrains", Util.GetString(Drains)));
            cmd.Parameters.Add(new MySqlParameter("@vType", Util.GetString(Type)));
            cmd.Parameters.Add(new MySqlParameter("@vComplication", Util.GetString(Complication)));
            cmd.Parameters.Add(new MySqlParameter("@vComplicationEntry", Util.GetString(ComplicationEntry)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateID", Util.GetString(UpdateID)));

            // Devendra Singh 2016.03.03

            cmd.Parameters.Add(new MySqlParameter("@vGender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@vBornDate", BornDate));
            cmd.Parameters.Add(new MySqlParameter("@vBornTime", BornTime));
            cmd.Parameters.Add(new MySqlParameter("@vWeight", Weight));
            cmd.Parameters.Add(new MySqlParameter("@vHeight", Height));

            Output = cmd.ExecuteNonQuery().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Output.ToString();
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

    #endregion All Public Member Function
}