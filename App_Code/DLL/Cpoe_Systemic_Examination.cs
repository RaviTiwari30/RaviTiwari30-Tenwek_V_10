using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Cpoe_Systemic_Examination
/// </summary>
public class Cpoe_Systemic_Examination
{
    #region All Memory Variables

    private string _ID;
    private string _PatientID;
    private string _TransactionID;
    private string _CardiovascularChk;
    private string _CardiovascularSymp;
    private string _CardiovascularSign;
    private string _RespiratoryChk;
    private string _RespiratorySymp;
    private string _RespiratorySign;
    private string _AbdomenChk;
    private string _AbdomenSymp;
    private string _AbdomenSign;
    private string _GenitoUrinaryChk;
    private string _GenitoUrinarySymp;
    private string _GenitoUrinarySign;
    private string _NervousChk;
    private string _NervousSymp;
    private string _NervousSign;
    private string _BonesChk;
    private string _BonesSymp;
    private string _BonesSign;
    private string _HaematologyChk;
    private string _HaematologySymp;
    private string _HaematologySign;
    private string _ArterialChk;
    private string _ArterialSymp;
    private string _ArterialSign;
    private string _VenousChk;
    private string _VenousSymp;
    private string _VenousSign;
    private string _BreastChk;
    private string _BreastSymp;
    private string _BreastSign;
    private string _ThyroidChk;
    private string _ThyroidSymp;
    private string _ThyroidSign;
    private string _EntryBy;
    private string _UpdateBy;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor
    public Cpoe_Systemic_Examination()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Cpoe_Systemic_Examination(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public string ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    public string PatientID
    {
        get { return _PatientID; }
        set { _PatientID = value; }
    }

    public string TransactionID
    {
        get { return _TransactionID; }
        set { _TransactionID = value; }
    }

    public string CardiovascularChk
    {
        get { return _CardiovascularChk; }
        set { _CardiovascularChk = value; }
    }

    public string CardiovascularSymp
    {
        get { return _CardiovascularSymp; }
        set { _CardiovascularSymp = value; }
    }

    public string CardiovascularSign
    {
        get { return _CardiovascularSign; }
        set { _CardiovascularSign = value; }
    }

    public string RespiratoryChk
    {
        get { return _RespiratoryChk; }
        set { _RespiratoryChk = value; }
    }

    public string RespiratorySymp
    {
        get { return _RespiratorySymp; }
        set { _RespiratorySymp = value; }
    }

    public string RespiratorySign
    {
        get { return _RespiratorySign; }
        set { _RespiratorySign = value; }
    }

    public string AbdomenChk
    {
        get { return _AbdomenChk; }
        set { _AbdomenChk = value; }
    }

    public string AbdomenSymp
    {
        get { return _AbdomenSymp; }
        set { _AbdomenSymp = value; }
    }

    public string AbdomenSign
    {
        get { return _AbdomenSign; }
        set { _AbdomenSign = value; }
    }

    public string GenitoUrinaryChk
    {
        get { return _GenitoUrinaryChk; }
        set { _GenitoUrinaryChk = value; }
    }

    public string GenitoUrinarySymp
    {
        get { return _GenitoUrinarySymp; }
        set { _GenitoUrinarySymp = value; }
    }

    public string GenitoUrinarySign
    {
        get { return _GenitoUrinarySign; }
        set { _GenitoUrinarySign = value; }
    }

    public string NervousChk
    {
        get { return _NervousChk; }
        set { _NervousChk = value; }
    }

    public string NervousSymp
    {
        get { return _NervousSymp; }
        set { _NervousSymp = value; }
    }

    public string NervousSign
    {
        get { return _NervousSign; }
        set { _NervousSign = value; }
    }

    public string BonesChk
    {
        get { return _BonesChk; }
        set { _BonesChk = value; }
    }

    public string BonesSymp
    {
        get { return _BonesSymp; }
        set { _BonesSymp = value; }
    }

    public string BonesSign
    {
        get { return _BonesSign; }
        set { _BonesSign = value; }
    }

    public string HaematologyChk
    {
        get { return _HaematologyChk; }
        set { _HaematologyChk = value; }
    }

    public string HaematologySymp
    {
        get { return _HaematologySymp; }
        set { _HaematologySymp = value; }
    }

    public string HaematologySign
    {
        get { return _HaematologySign; }
        set { _HaematologySign = value; }
    }

    public string ArterialChk
    {
        get { return _ArterialChk; }
        set { _ArterialChk = value; }
    }

    public string ArterialSymp
    {
        get { return _ArterialSymp; }
        set { _ArterialSymp = value; }
    }

    public string ArterialSign
    {
        get { return _ArterialSign; }
        set { _ArterialSign = value; }
    }

    public string VenousChk
    {
        get { return _VenousChk; }
        set { _VenousChk = value; }
    }

    public string VenousSymp
    {
        get { return _VenousSymp; }
        set { _VenousSymp = value; }
    }

    public string VenousSign
    {
        get { return _VenousSign; }
        set { _VenousSign = value; }
    }

    public string BreastChk
    {
        get { return _BreastChk; }
        set { _BreastChk = value; }
    }

    public string BreastSymp
    {
        get { return _BreastSymp; }
        set { _BreastSymp = value; }
    }

    public string BreastSign
    {
        get { return _BreastSign; }
        set { _BreastSign = value; }
    }

    public string ThyroidChk
    {
        get { return _ThyroidChk; }
        set { _ThyroidChk = value; }
    }

    public string ThyroidSymp
    {
        get { return _ThyroidSymp; }
        set { _ThyroidSymp = value; }
    }

    public string ThyroidSign
    {
        get { return _ThyroidSign; }
        set { _ThyroidSign = value; }
    }

    public string EntryBy
    {
        get { return _EntryBy; }
        set { _EntryBy = value; }
    }

    public string UpdateBy
    {
        get { return _UpdateBy; }
        set { _UpdateBy = value; }
    }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Cpoe_Systemic_Examination");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.CardiovascularChk = Util.GetString(CardiovascularChk);
            this.CardiovascularSymp = Util.GetString(CardiovascularSymp);
            this.CardiovascularSign = Util.GetString(CardiovascularSign);
            this.RespiratoryChk = Util.GetString(RespiratoryChk);
            this.RespiratorySymp = Util.GetString(RespiratorySymp);
            this.RespiratorySign = Util.GetString(RespiratorySign);
            this.AbdomenChk = Util.GetString(AbdomenChk);
            this.AbdomenSymp = Util.GetString(AbdomenSymp);
            this.AbdomenSign = Util.GetString(AbdomenSign);
            this.GenitoUrinaryChk = Util.GetString(GenitoUrinaryChk);
            this.GenitoUrinarySymp = Util.GetString(GenitoUrinarySymp);
            this.GenitoUrinarySign = Util.GetString(GenitoUrinarySign);
            this.NervousChk = Util.GetString(NervousChk);
            this.NervousSymp = Util.GetString(NervousSymp);
            this.NervousSign = Util.GetString(NervousSign);
            this.BonesChk = Util.GetString(BonesChk);
            this.BonesSymp = Util.GetString(BonesSymp);
            this.BonesSign = Util.GetString(BonesSign);
            this.HaematologyChk = Util.GetString(HaematologyChk);
            this.HaematologySymp = Util.GetString(HaematologySymp);
            this.HaematologySign = Util.GetString(HaematologySign);
            this.ArterialChk = Util.GetString(ArterialChk);
            this.ArterialSymp = Util.GetString(ArterialSymp);
            this.ArterialSign = Util.GetString(ArterialSign);
            this.VenousChk = Util.GetString(VenousChk);
            this.VenousSymp = Util.GetString(VenousSymp);
            this.VenousSign = Util.GetString(VenousSign);
            this.BreastChk = Util.GetString(BreastChk);
            this.BreastSymp = Util.GetString(BreastSymp);
            this.BreastSign = Util.GetString(BreastSign);
            this.ThyroidChk = Util.GetString(ThyroidChk);
            this.ThyroidSymp = Util.GetString(ThyroidSymp);
            this.ThyroidSign = Util.GetString(ThyroidSign);
            this.EntryBy = Util.GetString(EntryBy);

            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vCardiovascularChk", CardiovascularChk));
            cmd.Parameters.Add(new MySqlParameter("@vCardiovascularSymp", CardiovascularSymp));
            cmd.Parameters.Add(new MySqlParameter("@vCardiovascularSign", CardiovascularSign));
            cmd.Parameters.Add(new MySqlParameter("@vRespiratoryChk", RespiratoryChk));
            cmd.Parameters.Add(new MySqlParameter("@vRespiratorySymp", RespiratorySymp));
            cmd.Parameters.Add(new MySqlParameter("@vRespiratorySign", RespiratorySign));
            cmd.Parameters.Add(new MySqlParameter("@vAbdomenChk", AbdomenChk));
            cmd.Parameters.Add(new MySqlParameter("@vAbdomenSymp", AbdomenSymp));
            cmd.Parameters.Add(new MySqlParameter("@vAbdomenSign", AbdomenSign));
            cmd.Parameters.Add(new MySqlParameter("@vGenitoUrinaryChk", GenitoUrinaryChk));
            cmd.Parameters.Add(new MySqlParameter("@vGenitoUrinarySymp", GenitoUrinarySymp));
            cmd.Parameters.Add(new MySqlParameter("@vGenitoUrinarySign", GenitoUrinarySign));
            cmd.Parameters.Add(new MySqlParameter("@vNervousChk", NervousChk));
            cmd.Parameters.Add(new MySqlParameter("@vNervousSymp", NervousSymp));
            cmd.Parameters.Add(new MySqlParameter("@vNervousSign", NervousSign));
            cmd.Parameters.Add(new MySqlParameter("@vBonesChk", BonesChk));
            cmd.Parameters.Add(new MySqlParameter("@vBonesSymp", BonesSymp));
            cmd.Parameters.Add(new MySqlParameter("@vBonesSign", BonesSign));
            cmd.Parameters.Add(new MySqlParameter("@vHaematologyChk", HaematologyChk));
            cmd.Parameters.Add(new MySqlParameter("@vHaematologySymp", HaematologySymp));
            cmd.Parameters.Add(new MySqlParameter("@vHaematologySign", HaematologySign));
            cmd.Parameters.Add(new MySqlParameter("@vArterialChk", ArterialChk));
            cmd.Parameters.Add(new MySqlParameter("@vArterialSymp", ArterialSymp));
            cmd.Parameters.Add(new MySqlParameter("@vArterialSign", ArterialSign));
            cmd.Parameters.Add(new MySqlParameter("@vVenousChk", VenousChk));
            cmd.Parameters.Add(new MySqlParameter("@vVenousSymp", VenousSymp));
            cmd.Parameters.Add(new MySqlParameter("@vVenousSign", VenousSign));
            cmd.Parameters.Add(new MySqlParameter("@vBreastChk", BreastChk));
            cmd.Parameters.Add(new MySqlParameter("@vBreastSymp", BreastSymp));
            cmd.Parameters.Add(new MySqlParameter("@vBreastSign", BreastSign));
            cmd.Parameters.Add(new MySqlParameter("@vThyroidChk", ThyroidChk));
            cmd.Parameters.Add(new MySqlParameter("@vThyroidSymp", ThyroidSymp));
            cmd.Parameters.Add(new MySqlParameter("@vThyroidSign", ThyroidSign));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", EntryBy));

            this.ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return this.ID;
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
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Update_Cpoe_Systemic_Examination");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.ID = Util.GetString(ID);
            this.PatientID = Util.GetString(PatientID);
            this.TransactionID = Util.GetString(TransactionID);
            this.CardiovascularChk = Util.GetString(CardiovascularChk);
            this.CardiovascularSymp = Util.GetString(CardiovascularSymp);
            this.CardiovascularSign = Util.GetString(CardiovascularSign);
            this.RespiratoryChk = Util.GetString(RespiratoryChk);
            this.RespiratorySymp = Util.GetString(RespiratorySymp);
            this.RespiratorySign = Util.GetString(RespiratorySign);
            this.AbdomenChk = Util.GetString(AbdomenChk);
            this.AbdomenSymp = Util.GetString(AbdomenSymp);
            this.AbdomenSign = Util.GetString(AbdomenSign);
            this.GenitoUrinaryChk = Util.GetString(GenitoUrinaryChk);
            this.GenitoUrinarySymp = Util.GetString(GenitoUrinarySymp);
            this.GenitoUrinarySign = Util.GetString(GenitoUrinarySign);
            this.NervousChk = Util.GetString(NervousChk);
            this.NervousSymp = Util.GetString(NervousSymp);
            this.NervousSign = Util.GetString(NervousSign);
            this.BonesChk = Util.GetString(BonesChk);
            this.BonesSymp = Util.GetString(BonesSymp);
            this.BonesSign = Util.GetString(BonesSign);
            this.HaematologyChk = Util.GetString(HaematologyChk);
            this.HaematologySymp = Util.GetString(HaematologySymp);
            this.HaematologySign = Util.GetString(HaematologySign);
            this.ArterialChk = Util.GetString(ArterialChk);
            this.ArterialSymp = Util.GetString(ArterialSymp);
            this.ArterialSign = Util.GetString(ArterialSign);
            this.VenousChk = Util.GetString(VenousChk);
            this.VenousSymp = Util.GetString(VenousSymp);
            this.VenousSign = Util.GetString(VenousSign);
            this.BreastChk = Util.GetString(BreastChk);
            this.BreastSymp = Util.GetString(BreastSymp);
            this.BreastSign = Util.GetString(BreastSign);
            this.ThyroidChk = Util.GetString(ThyroidChk);
            this.ThyroidSymp = Util.GetString(ThyroidSymp);
            this.ThyroidSign = Util.GetString(ThyroidSign);
            this.UpdateBy = Util.GetString(UpdateBy);

            cmd.Parameters.Add(new MySqlParameter("@vID", ID));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", TransactionID));
            cmd.Parameters.Add(new MySqlParameter("@vCardiovascularChk", CardiovascularChk));
            cmd.Parameters.Add(new MySqlParameter("@vCardiovascularSymp", CardiovascularSymp));
            cmd.Parameters.Add(new MySqlParameter("@vCardiovascularSign", CardiovascularSign));
            cmd.Parameters.Add(new MySqlParameter("@vRespiratoryChk", RespiratoryChk));
            cmd.Parameters.Add(new MySqlParameter("@vRespiratorySymp", RespiratorySymp));
            cmd.Parameters.Add(new MySqlParameter("@vRespiratorySign", RespiratorySign));
            cmd.Parameters.Add(new MySqlParameter("@vAbdomenChk", AbdomenChk));
            cmd.Parameters.Add(new MySqlParameter("@vAbdomenSymp", AbdomenSymp));
            cmd.Parameters.Add(new MySqlParameter("@vAbdomenSign", AbdomenSign));
            cmd.Parameters.Add(new MySqlParameter("@vGenitoUrinaryChk", GenitoUrinaryChk));
            cmd.Parameters.Add(new MySqlParameter("@vGenitoUrinarySymp", GenitoUrinarySymp));
            cmd.Parameters.Add(new MySqlParameter("@vGenitoUrinarySign", GenitoUrinarySign));
            cmd.Parameters.Add(new MySqlParameter("@vNervousChk", NervousChk));
            cmd.Parameters.Add(new MySqlParameter("@vNervousSymp", NervousSymp));
            cmd.Parameters.Add(new MySqlParameter("@vNervousSign", NervousSign));
            cmd.Parameters.Add(new MySqlParameter("@vBonesChk", BonesChk));
            cmd.Parameters.Add(new MySqlParameter("@vBonesSymp", BonesSymp));
            cmd.Parameters.Add(new MySqlParameter("@vBonesSign", BonesSign));
            cmd.Parameters.Add(new MySqlParameter("@vHaematologyChk", HaematologyChk));
            cmd.Parameters.Add(new MySqlParameter("@vHaematologySymp", HaematologySymp));
            cmd.Parameters.Add(new MySqlParameter("@vHaematologySign", HaematologySign));
            cmd.Parameters.Add(new MySqlParameter("@vArterialChk", ArterialChk));
            cmd.Parameters.Add(new MySqlParameter("@vArterialSymp", ArterialSymp));
            cmd.Parameters.Add(new MySqlParameter("@vArterialSign", ArterialSign));
            cmd.Parameters.Add(new MySqlParameter("@vVenousChk", VenousChk));
            cmd.Parameters.Add(new MySqlParameter("@vVenousSymp", VenousSymp));
            cmd.Parameters.Add(new MySqlParameter("@vVenousSign", VenousSign));
            cmd.Parameters.Add(new MySqlParameter("@vBreastChk", BreastChk));
            cmd.Parameters.Add(new MySqlParameter("@vBreastSymp", BreastSymp));
            cmd.Parameters.Add(new MySqlParameter("@vBreastSign", BreastSign));
            cmd.Parameters.Add(new MySqlParameter("@vThyroidChk", ThyroidChk));
            cmd.Parameters.Add(new MySqlParameter("@vThyroidSymp", ThyroidSymp));
            cmd.Parameters.Add(new MySqlParameter("@vThyroidSign", ThyroidSign));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateBy", UpdateBy));

            int rows = cmd.ExecuteNonQuery();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return rows;
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

    #endregion All Public Member Function
}