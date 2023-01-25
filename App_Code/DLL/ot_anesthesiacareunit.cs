using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_anesthesiacareunit
{
    public ot_anesthesiacareunit()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_anesthesiacareunit(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private string _TransactionID;
    private int _TimeID;
    private string _IVF;
    private string _BLDPROD;
    private string _NSaline;
    private string _DRIPS;
    private string _RunningIVTotal;
    private string _PO;
    private string _CompleteRunningTotal;
    private string _Urine;
    private string _RunningTotal;
    private string _ConstaVac1;
    private string _ConstaVac2;
    private string _Hgb;
    private string _Sodium;
    private string _CI;
    private string _BUN;
    private string _Glucose;
    private string _PT;
    private string _CPK;
    private string _Troponin;
    private string _ROUTEO2FLOW;
    private string _ABG;
    private string _pCO2;
    private string _pO2;
    private string _O2;
    private string _BaseEx;
    private string _EnterBy;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual int TimeID { get { return _TimeID; } set { _TimeID = value; } }
    public virtual string IVF { get { return _IVF; } set { _IVF = value; } }
    public virtual string BLDPROD { get { return _BLDPROD; } set { _BLDPROD = value; } }
    public virtual string NSaline { get { return _NSaline; } set { _NSaline = value; } }
    public virtual string DRIPS { get { return _DRIPS; } set { _DRIPS = value; } }
    public virtual string RunningIVTotal { get { return _RunningIVTotal; } set { _RunningIVTotal = value; } }
    public virtual string PO { get { return _PO; } set { _PO = value; } }
    public virtual string CompleteRunningTotal { get { return _CompleteRunningTotal; } set { _CompleteRunningTotal = value; } }
    public virtual string Urine { get { return _Urine; } set { _Urine = value; } }
    public virtual string RunningTotal { get { return _RunningTotal; } set { _RunningTotal = value; } }
    public virtual string ConstaVac1 { get { return _ConstaVac1; } set { _ConstaVac1 = value; } }
    public virtual string ConstaVac2 { get { return _ConstaVac2; } set { _ConstaVac2 = value; } }
    public virtual string Hgb { get { return _Hgb; } set { _Hgb = value; } }
    public virtual string Sodium { get { return _Sodium; } set { _Sodium = value; } }
    public virtual string CI { get { return _CI; } set { _CI = value; } }
    public virtual string BUN { get { return _BUN; } set { _BUN = value; } }
    public virtual string Glucose { get { return _Glucose; } set { _Glucose = value; } }
    public virtual string PT { get { return _PT; } set { _PT = value; } }
    public virtual string CPK { get { return _CPK; } set { _CPK = value; } }
    public virtual string Troponin { get { return _Troponin; } set { _Troponin = value; } }
    public virtual string ROUTEO2FLOW { get { return _ROUTEO2FLOW; } set { _ROUTEO2FLOW = value; } }
    public virtual string ABG { get { return _ABG; } set { _ABG = value; } }
    public virtual string pCO2 { get { return _pCO2; } set { _pCO2 = value; } }
    public virtual string pO2 { get { return _pO2; } set { _pO2 = value; } }
    public virtual string O2 { get { return _O2; } set { _O2 = value; } }
    public virtual string BaseEx { get { return _BaseEx; } set { _BaseEx = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_anesthesiacareunit_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vTimeID", Util.GetInt(TimeID)));
            cmd.Parameters.Add(new MySqlParameter("@vIVF", Util.GetString(IVF)));
            cmd.Parameters.Add(new MySqlParameter("@vBLDPROD", Util.GetString(BLDPROD)));
            cmd.Parameters.Add(new MySqlParameter("@vNSaline", Util.GetString(NSaline)));
            cmd.Parameters.Add(new MySqlParameter("@vDRIPS", Util.GetString(DRIPS)));
            cmd.Parameters.Add(new MySqlParameter("@vRunningIVTotal", Util.GetString(RunningIVTotal)));
            cmd.Parameters.Add(new MySqlParameter("@vPO", Util.GetString(PO)));
            cmd.Parameters.Add(new MySqlParameter("@vCompleteRunningTotal", Util.GetString(CompleteRunningTotal)));
            cmd.Parameters.Add(new MySqlParameter("@vUrine", Util.GetString(Urine)));
            cmd.Parameters.Add(new MySqlParameter("@vRunningTotal", Util.GetString(RunningTotal)));
            cmd.Parameters.Add(new MySqlParameter("@vConstaVac1", Util.GetString(ConstaVac1)));
            cmd.Parameters.Add(new MySqlParameter("@vConstaVac2", Util.GetString(ConstaVac2)));
            cmd.Parameters.Add(new MySqlParameter("@vHgb", Util.GetString(Hgb)));
            cmd.Parameters.Add(new MySqlParameter("@vSodium", Util.GetString(Sodium)));
            cmd.Parameters.Add(new MySqlParameter("@vCI", Util.GetString(CI)));
            cmd.Parameters.Add(new MySqlParameter("@vBUN", Util.GetString(BUN)));
            cmd.Parameters.Add(new MySqlParameter("@vGlucose", Util.GetString(Glucose)));
            cmd.Parameters.Add(new MySqlParameter("@vPT", Util.GetString(PT)));
            cmd.Parameters.Add(new MySqlParameter("@vCPK", Util.GetString(CPK)));
            cmd.Parameters.Add(new MySqlParameter("@vTroponin", Util.GetString(Troponin)));
            cmd.Parameters.Add(new MySqlParameter("@vROUTEO2FLOW", Util.GetString(ROUTEO2FLOW)));
            cmd.Parameters.Add(new MySqlParameter("@vABG", Util.GetString(ABG)));
            cmd.Parameters.Add(new MySqlParameter("@vpCO2", Util.GetString(pCO2)));
            cmd.Parameters.Add(new MySqlParameter("@vpO2", Util.GetString(pO2)));
            cmd.Parameters.Add(new MySqlParameter("@vO2", Util.GetString(O2)));
            cmd.Parameters.Add(new MySqlParameter("@vBaseEx", Util.GetString(BaseEx)));
            cmd.Parameters.Add(new MySqlParameter("@vEnterBy", Util.GetString(EnterBy)));

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