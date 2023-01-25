using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class cpoe_neurological_analysis
{
    public cpoe_neurological_analysis()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public cpoe_neurological_analysis(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables
    private int _ID;
    private string _PatientID;
    private string _TransactionID;
    private string _IsNeurologicalExam;
    private string _MuscleR1;
    private string _MuscleR2;
    private string _MuscleR3;
    private string _MuscleR4;
    private string _MuscleR5;
    private string _MuscleR6;
    private string _MuscleR7;
    private string _MuscleR8;
    private string _MuscleR9;
    private string _MuscleR10;
    private string _MuscleL1;
    private string _MuscleL2;
    private string _MuscleL3;
    private string _MuscleL4;
    private string _MuscleL5;
    private string _MuscleL6;
    private string _MuscleL7;
    private string _MuscleL8;
    private string _MuscleL9;
    private string _MuscleL10;
    private string _DermatoneR1;
    private string _DermatoneR2;
    private string _DermatoneR3;
    private string _DermatoneR4;
    private string _DermatoneR5;
    private string _DermatoneR6;
    private string _DermatoneR7;
    private string _DermatoneR8;
    private string _DermatoneR9;
    private string _DermatoneR10;
    private string _DermatoneR11;
    private string _DermatoneR12;
    private string _DermatoneL1;
    private string _DermatoneL2;
    private string _DermatoneL3;
    private string _DermatoneL4;
    private string _DermatoneL5;
    private string _DermatoneL6;
    private string _DermatoneL7;
    private string _DermatoneL8;
    private string _DermatoneL9;
    private string _DermatoneL10;
    private string _DermatoneL11;
    private string _DermatoneL12;
    private string _IsPersonalsensation;
    private string _IsRectal;
    private string _ReflexesR1;
    private string _ReflexesR2;
    private string _ReflexesR3;
    private string _ReflexesR4;
    private string _ReflexesL1;
    private string _ReflexesL2;
    private string _ReflexesL3;
    private string _ReflexesL4;
    private string _IsAnkleClonus;
    private string _IsAnkleClonusR1;
    private string _IsAnkleClonusR2;
    private string _IsAnkleClonusL1;
    private string _IsAnkleClonusL2;
    private string _CreatedBy;
    private DateTime _CreatedDate;
    private string _UpdatedBy;
    private DateTime _UpdatedDate;
    private string _Note;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string IsNeurologicalExam { get { return _IsNeurologicalExam; } set { _IsNeurologicalExam = value; } }
    public virtual string MuscleR1 { get { return _MuscleR1; } set { _MuscleR1 = value; } }
    public virtual string MuscleR2 { get { return _MuscleR2; } set { _MuscleR2 = value; } }
    public virtual string MuscleR3 { get { return _MuscleR3; } set { _MuscleR3 = value; } }
    public virtual string MuscleR4 { get { return _MuscleR4; } set { _MuscleR4 = value; } }
    public virtual string MuscleR5 { get { return _MuscleR5; } set { _MuscleR5 = value; } }
    public virtual string MuscleR6 { get { return _MuscleR6; } set { _MuscleR6 = value; } }
    public virtual string MuscleR7 { get { return _MuscleR7; } set { _MuscleR7 = value; } }
    public virtual string MuscleR8 { get { return _MuscleR8; } set { _MuscleR8 = value; } }
    public virtual string MuscleR9 { get { return _MuscleR9; } set { _MuscleR9 = value; } }
    public virtual string MuscleR10 { get { return _MuscleR10; } set { _MuscleR10 = value; } }
    public virtual string MuscleL1 { get { return _MuscleL1; } set { _MuscleL1 = value; } }
    public virtual string MuscleL2 { get { return _MuscleL2; } set { _MuscleL2 = value; } }
    public virtual string MuscleL3 { get { return _MuscleL3; } set { _MuscleL3 = value; } }
    public virtual string MuscleL4 { get { return _MuscleL4; } set { _MuscleL4 = value; } }
    public virtual string MuscleL5 { get { return _MuscleL5; } set { _MuscleL5 = value; } }
    public virtual string MuscleL6 { get { return _MuscleL6; } set { _MuscleL6 = value; } }
    public virtual string MuscleL7 { get { return _MuscleL7; } set { _MuscleL7 = value; } }
    public virtual string MuscleL8 { get { return _MuscleL8; } set { _MuscleL8 = value; } }
    public virtual string MuscleL9 { get { return _MuscleL9; } set { _MuscleL9 = value; } }
    public virtual string MuscleL10 { get { return _MuscleL10; } set { _MuscleL10 = value; } }
    public virtual string DermatoneR1 { get { return _DermatoneR1; } set { _DermatoneR1 = value; } }
    public virtual string DermatoneR2 { get { return _DermatoneR2; } set { _DermatoneR2 = value; } }
    public virtual string DermatoneR3 { get { return _DermatoneR3; } set { _DermatoneR3 = value; } }
    public virtual string DermatoneR4 { get { return _DermatoneR4; } set { _DermatoneR4 = value; } }
    public virtual string DermatoneR5 { get { return _DermatoneR5; } set { _DermatoneR5 = value; } }
    public virtual string DermatoneR6 { get { return _DermatoneR6; } set { _DermatoneR6 = value; } }
    public virtual string DermatoneR7 { get { return _DermatoneR7; } set { _DermatoneR7 = value; } }
    public virtual string DermatoneR8 { get { return _DermatoneR8; } set { _DermatoneR8 = value; } }
    public virtual string DermatoneR9 { get { return _DermatoneR9; } set { _DermatoneR9 = value; } }
    public virtual string DermatoneR10 { get { return _DermatoneR10; } set { _DermatoneR10 = value; } }
    public virtual string DermatoneR11 { get { return _DermatoneR11; } set { _DermatoneR11 = value; } }
    public virtual string DermatoneR12 { get { return _DermatoneR12; } set { _DermatoneR12 = value; } }
    public virtual string DermatoneL1 { get { return _DermatoneL1; } set { _DermatoneL1 = value; } }
    public virtual string DermatoneL2 { get { return _DermatoneL2; } set { _DermatoneL2 = value; } }
    public virtual string DermatoneL3 { get { return _DermatoneL3; } set { _DermatoneL3 = value; } }
    public virtual string DermatoneL4 { get { return _DermatoneL4; } set { _DermatoneL4 = value; } }
    public virtual string DermatoneL5 { get { return _DermatoneL5; } set { _DermatoneL5 = value; } }
    public virtual string DermatoneL6 { get { return _DermatoneL6; } set { _DermatoneL6 = value; } }
    public virtual string DermatoneL7 { get { return _DermatoneL7; } set { _DermatoneL7 = value; } }
    public virtual string DermatoneL8 { get { return _DermatoneL8; } set { _DermatoneL8 = value; } }
    public virtual string DermatoneL9 { get { return _DermatoneL9; } set { _DermatoneL9 = value; } }
    public virtual string DermatoneL10 { get { return _DermatoneL10; } set { _DermatoneL10 = value; } }
    public virtual string DermatoneL11 { get { return _DermatoneL11; } set { _DermatoneL11 = value; } }
    public virtual string DermatoneL12 { get { return _DermatoneL12; } set { _DermatoneL12 = value; } }
    public virtual string IsPersonalsensation { get { return _IsPersonalsensation; } set { _IsPersonalsensation = value; } }
    public virtual string IsRectal { get { return _IsRectal; } set { _IsRectal = value; } }
    public virtual string ReflexesR1 { get { return _ReflexesR1; } set { _ReflexesR1 = value; } }
    public virtual string ReflexesR2 { get { return _ReflexesR2; } set { _ReflexesR2 = value; } }
    public virtual string ReflexesR3 { get { return _ReflexesR3; } set { _ReflexesR3 = value; } }
    public virtual string ReflexesR4 { get { return _ReflexesR4; } set { _ReflexesR4 = value; } }
    public virtual string ReflexesL1 { get { return _ReflexesL1; } set { _ReflexesL1 = value; } }
    public virtual string ReflexesL2 { get { return _ReflexesL2; } set { _ReflexesL2 = value; } }
    public virtual string ReflexesL3 { get { return _ReflexesL3; } set { _ReflexesL3 = value; } }
    public virtual string ReflexesL4 { get { return _ReflexesL4; } set { _ReflexesL4 = value; } }
    public virtual string IsAnkleClonus { get { return _IsAnkleClonus; } set { _IsAnkleClonus = value; } }
    public virtual string IsAnkleClonusR1 { get { return _IsAnkleClonusR1; } set { _IsAnkleClonusR1 = value; } }
    public virtual string IsAnkleClonusR2 { get { return _IsAnkleClonusR2; } set { _IsAnkleClonusR2 = value; } }
    public virtual string IsAnkleClonusL1 { get { return _IsAnkleClonusL1; } set { _IsAnkleClonusL1 = value; } }
    public virtual string IsAnkleClonusL2 { get { return _IsAnkleClonusL2; } set { _IsAnkleClonusL2 = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    public virtual DateTime CreatedDate { get { return _CreatedDate; } set { _CreatedDate = value; } }
    public virtual string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
    public virtual DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }
    public virtual string Note { get { return _Note; } set { _Note = value; } }
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("cpoe_neurological_analysis_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNeurologicalExam", Util.GetString(IsNeurologicalExam)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR1", Util.GetString(MuscleR1)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR2", Util.GetString(MuscleR2)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR3", Util.GetString(MuscleR3)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR4", Util.GetString(MuscleR4)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR5", Util.GetString(MuscleR5)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR6", Util.GetString(MuscleR6)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR7", Util.GetString(MuscleR7)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR8", Util.GetString(MuscleR8)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR9", Util.GetString(MuscleR9)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR10", Util.GetString(MuscleR10)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL1", Util.GetString(MuscleL1)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL2", Util.GetString(MuscleL2)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL3", Util.GetString(MuscleL3)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL4", Util.GetString(MuscleL4)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL5", Util.GetString(MuscleL5)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL6", Util.GetString(MuscleL6)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL7", Util.GetString(MuscleL7)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL8", Util.GetString(MuscleL8)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL9", Util.GetString(MuscleL9)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL10", Util.GetString(MuscleL10)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR1", Util.GetString(DermatoneR1)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR2", Util.GetString(DermatoneR2)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR3", Util.GetString(DermatoneR3)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR4", Util.GetString(DermatoneR4)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR5", Util.GetString(DermatoneR5)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR6", Util.GetString(DermatoneR6)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR7", Util.GetString(DermatoneR7)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR8", Util.GetString(DermatoneR8)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR9", Util.GetString(DermatoneR9)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR10", Util.GetString(DermatoneR10)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR11", Util.GetString(DermatoneR11)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR12", Util.GetString(DermatoneR12)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL1", Util.GetString(DermatoneL1)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL2", Util.GetString(DermatoneL2)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL3", Util.GetString(DermatoneL3)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL4", Util.GetString(DermatoneL4)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL5", Util.GetString(DermatoneL5)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL6", Util.GetString(DermatoneL6)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL7", Util.GetString(DermatoneL7)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL8", Util.GetString(DermatoneL8)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL9", Util.GetString(DermatoneL9)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL10", Util.GetString(DermatoneL10)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL11", Util.GetString(DermatoneL11)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL12", Util.GetString(DermatoneL12)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPersonalsensation", Util.GetString(IsPersonalsensation)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRectal", Util.GetString(IsRectal)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesR1", Util.GetString(ReflexesR1)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesR2", Util.GetString(ReflexesR2)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesR3", Util.GetString(ReflexesR3)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesR4", Util.GetString(ReflexesR4)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesL1", Util.GetString(ReflexesL1)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesL2", Util.GetString(ReflexesL2)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesL3", Util.GetString(ReflexesL3)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesL4", Util.GetString(ReflexesL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnkleClonus", Util.GetString(IsAnkleClonus)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnkleClonusR1", Util.GetString(IsAnkleClonusR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnkleClonusR2", Util.GetString(IsAnkleClonusR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnkleClonusL1", Util.GetString(IsAnkleClonusL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnkleClonusL2", Util.GetString(IsAnkleClonusL2)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedDate", Util.GetDateTime(CreatedDate)));
            cmd.Parameters.Add(new MySqlParameter("@vNote", Util.GetString(Note)));
            Output = cmd.ExecuteScalar().ToString();

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

            throw (ex);
        }
    }

    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_neurological_analysis_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsNeurologicalExam", Util.GetString(IsNeurologicalExam)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR1", Util.GetString(MuscleR1)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR2", Util.GetString(MuscleR2)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR3", Util.GetString(MuscleR3)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR4", Util.GetString(MuscleR4)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR5", Util.GetString(MuscleR5)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR6", Util.GetString(MuscleR6)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR7", Util.GetString(MuscleR7)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR8", Util.GetString(MuscleR8)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR9", Util.GetString(MuscleR9)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleR10", Util.GetString(MuscleR10)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL1", Util.GetString(MuscleL1)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL2", Util.GetString(MuscleL2)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL3", Util.GetString(MuscleL3)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL4", Util.GetString(MuscleL4)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL5", Util.GetString(MuscleL5)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL6", Util.GetString(MuscleL6)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL7", Util.GetString(MuscleL7)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL8", Util.GetString(MuscleL8)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL9", Util.GetString(MuscleL9)));
            cmd.Parameters.Add(new MySqlParameter("@vMuscleL10", Util.GetString(MuscleL10)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR1", Util.GetString(DermatoneR1)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR2", Util.GetString(DermatoneR2)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR3", Util.GetString(DermatoneR3)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR4", Util.GetString(DermatoneR4)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR5", Util.GetString(DermatoneR5)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR6", Util.GetString(DermatoneR6)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR7", Util.GetString(DermatoneR7)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR8", Util.GetString(DermatoneR8)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR9", Util.GetString(DermatoneR9)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR10", Util.GetString(DermatoneR10)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR11", Util.GetString(DermatoneR11)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneR12", Util.GetString(DermatoneR12)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL1", Util.GetString(DermatoneL1)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL2", Util.GetString(DermatoneL2)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL3", Util.GetString(DermatoneL3)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL4", Util.GetString(DermatoneL4)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL5", Util.GetString(DermatoneL5)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL6", Util.GetString(DermatoneL6)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL7", Util.GetString(DermatoneL7)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL8", Util.GetString(DermatoneL8)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL9", Util.GetString(DermatoneL9)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL10", Util.GetString(DermatoneL10)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL11", Util.GetString(DermatoneL11)));
            cmd.Parameters.Add(new MySqlParameter("@vDermatoneL12", Util.GetString(DermatoneL12)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPersonalsensation", Util.GetString(IsPersonalsensation)));
            cmd.Parameters.Add(new MySqlParameter("@vIsRectal", Util.GetString(IsRectal)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesR1", Util.GetString(ReflexesR1)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesR2", Util.GetString(ReflexesR2)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesR3", Util.GetString(ReflexesR3)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesR4", Util.GetString(ReflexesR4)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesL1", Util.GetString(ReflexesL1)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesL2", Util.GetString(ReflexesL2)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesL3", Util.GetString(ReflexesL3)));
            cmd.Parameters.Add(new MySqlParameter("@vReflexesL4", Util.GetString(ReflexesL4)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnkleClonus", Util.GetString(IsAnkleClonus)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnkleClonusR1", Util.GetString(IsAnkleClonusR1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnkleClonusR2", Util.GetString(IsAnkleClonusR2)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnkleClonusL1", Util.GetString(IsAnkleClonusL1)));
            cmd.Parameters.Add(new MySqlParameter("@vIsAnkleClonusL2", Util.GetString(IsAnkleClonusL2)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedDate", Util.GetDateTime(UpdatedDate)));

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

            throw (ex);
        }
    }
    #endregion
}
