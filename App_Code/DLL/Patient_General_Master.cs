using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Patient_General_Master
/// </summary>
public class Patient_General_Master
{
    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    public Patient_General_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Patient_General_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private string _CustomerID;
    private string _Title;
    private string _Name;
    private string _Age;
    private string _Gender;
    private string _ContactNo;
    private string _Address;
    private string _Ledgertrnxno;
    private string _Hospital_ID;
    private int _CentreID;

    #endregion All Memory Variables

    #region set All Property

    public virtual string CustomerID { get { return _CustomerID; } set { _CustomerID = value; } }
    public virtual string Title { get { return _Title; } set { _Title = value; } }
    public virtual string Name { get { return _Name; } set { _Name = value; } }
    public virtual string Age { get { return _Age; } set { _Age = value; } }
    public virtual string Gender { get { return _Gender; } set { _Gender = value; } }
    public virtual string ContactNo { get { return _ContactNo; } set { _ContactNo = value; } }
    public virtual string Address { get { return _Address; } set { _Address = value; } }
    public virtual string Ledgertrnxno { get { return _Ledgertrnxno; } set { _Ledgertrnxno = value; } }
    public virtual string Hospital_ID { get { return _Hospital_ID; } set { _Hospital_ID = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }

    #endregion set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("Insert_GeneralPatient");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@CustomerID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(paramTnxID);
            cmd.Parameters.Add(new MySqlParameter("@Title", Util.GetString(Title)));
            cmd.Parameters.Add(new MySqlParameter("@NAME", Util.GetString(Name)));
            cmd.Parameters.Add(new MySqlParameter("@Age", Util.GetString(Age)));
            cmd.Parameters.Add(new MySqlParameter("@Gender", Util.GetString(Gender)));
            cmd.Parameters.Add(new MySqlParameter("@ContactNo", Util.GetString(ContactNo)));
            cmd.Parameters.Add(new MySqlParameter("@ADDRESS", Util.GetString(Address)));
            cmd.Parameters.Add(new MySqlParameter("@AgainstLedgerTnxNo", Util.GetString(Ledgertrnxno)));
            cmd.Parameters.Add(new MySqlParameter("@Hospital_ID", Util.GetString(Hospital_ID)));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", Util.GetInt(CentreID)));
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

    #endregion All Public Member Function
}