using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class cpoe_research_hip
{
    public cpoe_research_hip()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_research_hip(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _PatientID;
    private string _HipRight;
    private string _HipLeft;
    private string _HetroRight;
    private string _HetroLeft;
    private string _CementRight;
    private string _CementLeft;
    private string _AcetabularRight;
    private string _AcetabularLeft;
    private string _ScrewsRight;
    private string _ScrewsLeft;
    private string _FemoralRight;
    private string _FemoralLeft;
    private string _AceRight;
    private string _AceLeft;
    private string _FemRight;
    private string _FemLeft;
    private string _EntryBy;


    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string HipRight { get { return _HipRight; } set { _HipRight = value; } }
    public virtual string HipLeft { get { return _HipLeft; } set { _HipLeft = value; } }
    public virtual string HetroRight { get { return _HetroRight; } set { _HetroRight = value; } }
    public virtual string HetroLeft { get { return _HetroLeft; } set { _HetroLeft = value; } }
    public virtual string CementRight { get { return _CementRight; } set { _CementRight = value; } }
    public virtual string CementLeft { get { return _CementLeft; } set { _CementLeft = value; } }
    public virtual string AcetabularRight { get { return _AcetabularRight; } set { _AcetabularRight = value; } }
    public virtual string AcetabularLeft { get { return _AcetabularLeft; } set { _AcetabularLeft = value; } }
    public virtual string ScrewsRight { get { return _ScrewsRight; } set { _ScrewsRight = value; } }
    public virtual string ScrewsLeft { get { return _ScrewsLeft; } set { _ScrewsLeft = value; } }
    public virtual string FemoralRight { get { return _FemoralRight; } set { _FemoralRight = value; } }
    public virtual string FemoralLeft { get { return _FemoralLeft; } set { _FemoralLeft = value; } }
    public virtual string AceRight { get { return _AceRight; } set { _AceRight = value; } }
    public virtual string AceLeft { get { return _AceLeft; } set { _AceLeft = value; } }
    public virtual string FemRight { get { return _FemRight; } set { _FemRight = value; } }
    public virtual string FemLeft { get { return _FemLeft; } set { _FemLeft = value; } }
    public virtual string EntryBy { get { return _EntryBy; } set { _EntryBy = value; } }
  

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_research_hip_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vHipRight", Util.GetString(HipRight)));
            cmd.Parameters.Add(new MySqlParameter("@vHipLeft", Util.GetString(HipLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vHetroRight", Util.GetString(HetroRight)));
            cmd.Parameters.Add(new MySqlParameter("@vHetroLeft", Util.GetString(HetroLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCementRight", Util.GetString(CementRight)));
            cmd.Parameters.Add(new MySqlParameter("@vCementLeft", Util.GetString(CementLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vAcetabularRight", Util.GetString(AcetabularRight)));
            cmd.Parameters.Add(new MySqlParameter("@vAcetabularLeft", Util.GetString(AcetabularLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vScrewsRight", Util.GetString(ScrewsRight)));
            cmd.Parameters.Add(new MySqlParameter("@vScrewsLeft", Util.GetString(ScrewsLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vFemoralRight", Util.GetString(FemoralRight)));
            cmd.Parameters.Add(new MySqlParameter("@vFemoralLeft", Util.GetString(FemoralLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vAceRight", Util.GetString(AceRight)));
            cmd.Parameters.Add(new MySqlParameter("@vAceLeft", Util.GetString(AceLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vFemRight", Util.GetString(FemRight)));
            cmd.Parameters.Add(new MySqlParameter("@vFemLeft", Util.GetString(FemLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", Util.GetString(EntryBy)));
            

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
            // Util.WriteLog(ex);   
            throw (ex);
        }
    }


    public string Update()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_research_hip_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            //cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vHipRight", Util.GetString(HipRight)));
            cmd.Parameters.Add(new MySqlParameter("@vHipLeft", Util.GetString(HipLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vHetroRight", Util.GetString(HetroRight)));
            cmd.Parameters.Add(new MySqlParameter("@vHetroLeft", Util.GetString(HetroLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCementRight", Util.GetString(CementRight)));
            cmd.Parameters.Add(new MySqlParameter("@vCementLeft", Util.GetString(CementLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vAcetabularRight", Util.GetString(AcetabularRight)));
            cmd.Parameters.Add(new MySqlParameter("@vAcetabularLeft", Util.GetString(AcetabularLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vScrewsRight", Util.GetString(ScrewsRight)));
            cmd.Parameters.Add(new MySqlParameter("@vScrewsLeft", Util.GetString(ScrewsLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vFemoralRight", Util.GetString(FemoralRight)));
            cmd.Parameters.Add(new MySqlParameter("@vFemoralLeft", Util.GetString(FemoralLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vAceRight", Util.GetString(AceRight)));
            cmd.Parameters.Add(new MySqlParameter("@vAceLeft", Util.GetString(AceLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vFemRight", Util.GetString(FemRight)));
            cmd.Parameters.Add(new MySqlParameter("@vFemLeft", Util.GetString(FemLeft)));
            //cmd.Parameters.Add(new MySqlParameter("@vEntryBy", Util.GetString(EntryBy)));


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



    #endregion

}
