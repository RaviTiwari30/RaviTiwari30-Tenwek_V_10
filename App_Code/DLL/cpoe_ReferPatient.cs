using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


public class cpoe_ReferPatient
{
	 #region All Memory Variables

    private string _TransactionID;
    private string _PatientID;
    private string _DoctorID;
    private string _Contraindications;
    private string _Exercise;
    private string _Instruction;
    private string _Modalities;
    private string _Hydrotherapy;
    private string _AdditionalOrders;
    private string _TreatmentGoals;
    private string _Treat;
    private string _week;
    private string _Industrial;
    private string _Comment;
    private string _CreatedBy;
    #endregion
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public cpoe_ReferPatient()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
      

	}
    public cpoe_ReferPatient(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
    #region Set All Property

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
    public virtual string Contraindications
    {
        get
        {
            return _Contraindications;
        }
        set
        {
            _Contraindications = value;
        }
    }
    public virtual string Exercise
    {
        get
        {
            return _Exercise;
        }
        set
        {
            _Exercise = value;
        }
    }

    public virtual string Instruction
    {
        get
        {
            return _Instruction;
        }
        set
        {
            _Instruction = value;
        }
    }

    public virtual string Modalities
    {
        get
        {
            return _Modalities;
        }
        set
        {
            _Modalities = value;
        }
    }
    public virtual string Hydrotherapy
    {
        get
        {
            return _Hydrotherapy;
        }
        set
        {
            _Hydrotherapy = value;
        }
    }

    public virtual string AdditionalOrders
    {
        get
        {
            return _AdditionalOrders;
        }
        set
        {
            _AdditionalOrders = value;
        }
    }
    public virtual string TreatmentGoals
    {
        get
        {
            return _TreatmentGoals;
        }
        set
        {
            _TreatmentGoals = value;
        }
    }
    public virtual string Treat
    {
        get
        {
            return _Treat;
        }
        set
        {
            _Treat = value;
        }
    }
    public virtual string week
    {
        get
        {
            return _week;
        }
        set
        {
            _week = value;
        }
    }
    public virtual string Industrial
    {
        get
        {
            return _Industrial;
        }
        set
        {
            _Industrial = value;
        }
    }
    public virtual string Comment
    {
        get
        {
            return _Comment;
        }
        set
        {
            _Comment = value;
        }
    }
    public virtual string CreatedBy
    {
        get
        {
            return _CreatedBy;
        }
        set
        {
            _CreatedBy = value;
        }
    }
    #endregion
    #region All Public Member Function
    public string Insert()
    {
        try
        {
            string iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("cpoe_ReferPatientInsert");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new
                MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@identity";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

          

            this.TransactionID = Util.GetString(TransactionID);
            this.PatientID = Util.GetString(PatientID);
            this.DoctorID = Util.GetString(DoctorID);
            this.Contraindications = Util.GetString(Contraindications);
            this.Exercise = Util.GetString(Exercise);
            this.Instruction = Util.GetString(Instruction);
            this.Modalities = Util.GetString(Modalities);
            this.Hydrotherapy = Util.GetString(Hydrotherapy);
            this.AdditionalOrders = Util.GetString(AdditionalOrders);
            this.TreatmentGoals = Util.GetString(TreatmentGoals);
            this.Treat = Util.GetString(Treat);
            this.week = Util.GetString(week);
            this.Industrial = Util.GetString(Industrial);
            this.Comment = Util.GetString(Comment);
            this.CreatedBy = Util.GetString(CreatedBy);


            //MySqlHelper.ExecuteNonQuery(objTrans, CommandType.StoredProcedure, objSQL.ToString(),


            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@vContraindications", Contraindications));
            cmd.Parameters.Add(new MySqlParameter("@vExercise", Exercise));
            cmd.Parameters.Add(new MySqlParameter("@vInstruction", Instruction));
            cmd.Parameters.Add(new MySqlParameter("@vModalities", Modalities));
            cmd.Parameters.Add(new MySqlParameter("@vHydrotherapy", Hydrotherapy));
            cmd.Parameters.Add(new MySqlParameter("@vAdditionalOrders", AdditionalOrders));
            cmd.Parameters.Add(new MySqlParameter("@vTreatmentGoals", TreatmentGoals));
            cmd.Parameters.Add(new MySqlParameter("@vTreat", Treat));
            cmd.Parameters.Add(new MySqlParameter("@vweek", week));
            cmd.Parameters.Add(new MySqlParameter("@vIndustrial", Industrial));
            cmd.Parameters.Add(new MySqlParameter("@vComment", Comment));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(paramTnxID);

            iPkValue = Util.GetString(cmd.ExecuteScalar());

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
    #endregion

}
