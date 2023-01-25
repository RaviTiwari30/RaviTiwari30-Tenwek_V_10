using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;


public class d_Surgery_Site_care
{
    public d_Surgery_Site_care()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public d_Surgery_Site_care(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private int _IsStaples;
    private string _Staples;
    private string _CastCareInstruction;
    private string _AdditionalInstruction;
    private string _UserID;
    private DateTime _EnteryDate;
    private string _UpdateBy;
    private DateTime _UpdateDate;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual int IsStaples { get { return _IsStaples; } set { _IsStaples = value; } }
    public virtual string Staples { get { return _Staples; } set { _Staples = value; } }
    public virtual string CastCareInstruction { get { return _CastCareInstruction; } set { _CastCareInstruction = value; } }
    public virtual string AdditionalInstruction { get { return _AdditionalInstruction; } set { _AdditionalInstruction = value; } }
    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
    public virtual DateTime EnteryDate { get { return _EnteryDate; } set { _EnteryDate = value; } }
    public virtual string UpdateBy { get { return _UpdateBy; } set { _UpdateBy = value; } }
    public virtual DateTime UpdateDate { get { return _UpdateDate; } set { _UpdateDate = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("d_SurgicalSiteCare_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStaples", Util.GetInt(IsStaples)));
            cmd.Parameters.Add(new MySqlParameter("@vStaples", Util.GetString(Staples)));
            cmd.Parameters.Add(new MySqlParameter("@vCastCareInstruction", Util.GetString(CastCareInstruction)));
            cmd.Parameters.Add(new MySqlParameter("@vAdditionalInstruction", Util.GetString(AdditionalInstruction)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vEnteryDate", Util.GetDateTime(EnteryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));

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

            objSQL.Append("d_SurgicalSiteCare_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsStaples", Util.GetInt(IsStaples)));
            cmd.Parameters.Add(new MySqlParameter("@vStaples", Util.GetString(Staples)));
            cmd.Parameters.Add(new MySqlParameter("@vCastCareInstruction", Util.GetString(CastCareInstruction)));
            cmd.Parameters.Add(new MySqlParameter("@vAdditionalInstruction", Util.GetString(AdditionalInstruction)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vEnteryDate", Util.GetDateTime(EnteryDate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", Util.GetString(UpdateBy)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateDate", Util.GetDateTime(UpdateDate)));
            Output = cmd.ExecuteNonQuery().ToString();

            //Output = cmd.ExecuteScalar().ToString();

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
