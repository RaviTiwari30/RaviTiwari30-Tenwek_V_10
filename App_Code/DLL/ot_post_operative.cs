using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_post_operative
{
    public ot_post_operative()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_post_operative(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _TransferredTO;
    private string _SICU;
    private string _Bed;
    private string _Isolette;
    private string _Stretcher;
    private string _Crib;
    private string _OwnBed;
    private string _Other;
    private string _Endotracheal;
    private string _Nasal;
    private string _O2InUse;
    private string _Oral;
    private string _Trach;
    private string _Color;
    private string _Integrity;
    private string _Temp;
    private string _EnterBy;
    private string _Site;
    private string _TransportedTo;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string TransferredTO { get { return _TransferredTO; } set { _TransferredTO = value; } }
    public virtual string SICU { get { return _SICU; } set { _SICU = value; } }
    public virtual string Bed { get { return _Bed; } set { _Bed = value; } }
    public virtual string Isolette { get { return _Isolette; } set { _Isolette = value; } }
    public virtual string Stretcher { get { return _Stretcher; } set { _Stretcher = value; } }
    public virtual string Crib { get { return _Crib; } set { _Crib = value; } }
    public virtual string OwnBed { get { return _OwnBed; } set { _OwnBed = value; } }
    public virtual string Other { get { return _Other; } set { _Other = value; } }
    public virtual string Endotracheal { get { return _Endotracheal; } set { _Endotracheal = value; } }
    public virtual string Nasal { get { return _Nasal; } set { _Nasal = value; } }
    public virtual string O2InUse { get { return _O2InUse; } set { _O2InUse = value; } }
    public virtual string Oral { get { return _Oral; } set { _Oral = value; } }
    public virtual string Trach { get { return _Trach; } set { _Trach = value; } }
    public virtual string Color { get { return _Color; } set { _Color = value; } }
    public virtual string Integrity { get { return _Integrity; } set { _Integrity = value; } }
    public virtual string Temp { get { return _Temp; } set { _Temp = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }
    public virtual string Site { get { return _Site; } set { _Site = value; } }
    public virtual string TransportedTo { get { return _TransportedTo; } set { _TransportedTo = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_post_operative_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransferredTO", Util.GetString(TransferredTO)));
            cmd.Parameters.Add(new MySqlParameter("@vSICU", Util.GetString(SICU)));
            cmd.Parameters.Add(new MySqlParameter("@vBed", Util.GetString(Bed)));
            cmd.Parameters.Add(new MySqlParameter("@vIsolette", Util.GetString(Isolette)));
            cmd.Parameters.Add(new MySqlParameter("@vStretcher", Util.GetString(Stretcher)));
            cmd.Parameters.Add(new MySqlParameter("@vCrib", Util.GetString(Crib)));
            cmd.Parameters.Add(new MySqlParameter("@vOwnBed", Util.GetString(OwnBed)));
            cmd.Parameters.Add(new MySqlParameter("@vOther", Util.GetString(Other)));
            cmd.Parameters.Add(new MySqlParameter("@vEndotracheal", Util.GetString(Endotracheal)));
            cmd.Parameters.Add(new MySqlParameter("@vNasal", Util.GetString(Nasal)));
            cmd.Parameters.Add(new MySqlParameter("@vO2InUse", Util.GetString(O2InUse)));
            cmd.Parameters.Add(new MySqlParameter("@vOral", Util.GetString(Oral)));
            cmd.Parameters.Add(new MySqlParameter("@vTrach", Util.GetString(Trach)));
            cmd.Parameters.Add(new MySqlParameter("@vColor", Util.GetString(Color)));
            cmd.Parameters.Add(new MySqlParameter("@vIntegrity", Util.GetString(Integrity)));
            cmd.Parameters.Add(new MySqlParameter("@vTemp", Util.GetString(Temp)));
            cmd.Parameters.Add(new MySqlParameter("@vEnterBy", Util.GetString(EnterBy)));
            cmd.Parameters.Add(new MySqlParameter("@vSite", Util.GetString(Site)));
            cmd.Parameters.Add(new MySqlParameter("@vTransportedTo", Util.GetString(TransportedTo)));

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