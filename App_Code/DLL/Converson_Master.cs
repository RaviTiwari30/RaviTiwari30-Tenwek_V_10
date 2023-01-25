using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for converson_master
/// Generated using MySqlManager
/// ==========================================================================================
/// Author:
/// Create date:	12-04-2013 15:20:49
/// Description:	This class is intended for inserting, updating, deleting values for converson_master table
/// ==========================================================================================
/// </summary>

public class Converson_Master
{
    public Converson_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Converson_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private int _S_CountryID;
    private string _S_Currency;
    private string _S_Notation;
    private int _B_CountryID;
    private string _B_Currency;
    private string _B_Notation;
    private decimal _Selling_Base;
    private decimal _Selling_Specific;
    private decimal _Buying_Base;
    private decimal _Buying_Specific;
    //private DateTime _ApplyOnDate;
    private DateTime _Date;
    private string _UserID;
    private decimal _Round;
    private decimal _MinCurrency;
    
    //private string _UpdateByID;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual int S_CountryID { get { return _S_CountryID; } set { _S_CountryID = value; } }
    public virtual string S_Currency { get { return _S_Currency; } set { _S_Currency = value; } }
    public virtual string S_Notation { get { return _S_Notation; } set { _S_Notation = value; } }
    public virtual int B_CountryID { get { return _B_CountryID; } set { _B_CountryID = value; } }
    public virtual string B_Currency { get { return _B_Currency; } set { _B_Currency = value; } }
    public virtual string B_Notation { get { return _B_Notation; } set { _B_Notation = value; } }
    public virtual decimal Selling_Base { get { return _Selling_Base; } set { _Selling_Base = value; } }
    public virtual decimal Selling_Specific { get { return _Selling_Specific; } set { _Selling_Specific = value; } }
    public virtual decimal Buying_Base { get { return _Buying_Base; } set { _Buying_Base = value; } }
    public virtual decimal Buying_Specific { get { return _Buying_Specific; } set { _Buying_Specific = value; } }
    //public virtual DateTime ApplyOnDate_date { get { return _ApplyOnDate; } set { _ApplyOnDate = value; } }
    public virtual DateTime Date { get { return _Date; } set { _Date = value; } }
    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
    public virtual decimal Round { get { return _Round; } set { _Round = value; } }
    public virtual decimal MinCurrency { get { return _MinCurrency; } set { _MinCurrency = value; } }
    
    //public virtual string UpdateByID { get { return _UpdateByID; } set { _UpdateByID = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("converson_master_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vS_CountryID", Util.GetInt(S_CountryID)));
            cmd.Parameters.Add(new MySqlParameter("@vS_Currency", Util.GetString(S_Currency)));
            cmd.Parameters.Add(new MySqlParameter("@vS_Notation", Util.GetString(S_Notation)));
            cmd.Parameters.Add(new MySqlParameter("@vB_CountryID", Util.GetInt(B_CountryID)));
            cmd.Parameters.Add(new MySqlParameter("@vB_Currency",  Util.GetString(B_Currency)));
            cmd.Parameters.Add(new MySqlParameter("@vB_Notation",  Util.GetString(B_Notation)));
            cmd.Parameters.Add(new MySqlParameter("@vSelling_Base", Util.GetDecimal(Selling_Base)));
            cmd.Parameters.Add(new MySqlParameter("@vSelling_Specific", Util.GetDecimal(Selling_Specific)));
            cmd.Parameters.Add(new MySqlParameter("@vBuying_Base", Util.GetDecimal(Buying_Base)));
            cmd.Parameters.Add(new MySqlParameter("@vBuying_Specific", Util.GetDecimal(Buying_Specific)));
           // cmd.Parameters.Add(new MySqlParameter("@_ApplyOnDate", _ApplyOnDate));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vRound", Util.GetDecimal(Round)));
            cmd.Parameters.Add(new MySqlParameter("@vMinCurrency", Util.GetDecimal(MinCurrency)));

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

            objSQL.Append("converson_master_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.Add(new MySqlParameter("@_ID", _ID));
            cmd.Parameters.Add(new MySqlParameter("@_S_CountryID", _S_CountryID));
            cmd.Parameters.Add(new MySqlParameter("@_S_Currency", _S_Currency));
            cmd.Parameters.Add(new MySqlParameter("@_S_Notation", _S_Notation));
            //cmd.Parameters.Add(new MySqlParameter("@_B_CountryID", _B_CountryID));
            cmd.Parameters.Add(new MySqlParameter("@_B_Currency", _B_Currency));
            cmd.Parameters.Add(new MySqlParameter("@_B_Notation", _B_Notation));
            cmd.Parameters.Add(new MySqlParameter("@_Selling_Base", _Selling_Base));
            cmd.Parameters.Add(new MySqlParameter("@_Selling_Specific", _Selling_Specific));
            cmd.Parameters.Add(new MySqlParameter("@_Buying_Base", _Buying_Base));
            cmd.Parameters.Add(new MySqlParameter("@_Buying_Specific", _Buying_Specific));
            //cmd.Parameters.Add(new MySqlParameter("@_ApplyOnDate", _Date));
            cmd.Parameters.Add(new MySqlParameter("@_Date", _Date));
            cmd.Parameters.Add(new MySqlParameter("@_UserID", _UserID));
            //cmd.Parameters.Add(new MySqlParameter("@_UpdateDate", _UpdateDate));
            //cmd.Parameters.Add(new MySqlParameter("@_UpdateByID", _UpdateByID));

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


    public string Delete()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("converson_master_delete");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@_ID", _ID));

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

    #endregion

}
