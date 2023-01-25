using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class ortho_progress
{
    public ortho_progress()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public ortho_progress(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _Orthoprogress;
    private string _Surgicalprocedure;
    private System.DateTime _Postday;
    private string _Subjective;
    private string _Othertxtsubjective;
    private int _ISAvst;
    private int _ISTemp;
    private string _Temptxt;
    private int _ISotherobjective;
    private string _Othertxtobjective;
    private string _Dressing;
    private int _ISCdai;
    private int _ISSdf;
    private int _ISIncision;
    private int _ISDrain;
    private string _Draintxt;
    private int _ISScant;
    private int _ISModerate;
    private int _ISsd;
    private int _ISincreasing;
    private int _Isstable;
    private int _Decreasing;
    private int _Iserythema;
    private int _IsPurulent;
    private string _Neuro;
    private int _ISncfp;
    private int _IsOtherNeuro;
    private string _EHL;
    private string _TA;
    private string _GS;
    private string _Quads;
    private string _Hamps;
    private string _Ipsoas;
    private int _Isitlt;
    private int _IsDecreased;
    private int _IsDysesthesia;
    private int _Issoft;
    private int _Isothercomp;
    private string _Othercomptxt;
    private int _Isppedis;
    private int _Post;
    private int _Refill;
    private string _Refilltxt;
    private string _Discharge;
    private int _Isctmp;
    private int _Iscptam;
    private int _Iswabt;
    private int _Ispwb;
    private int _Isttwb;
    private int _Isnwb;
    private int _Ispain;
    private string _Paintxt;
    private int _Isdvt;
    private string _Dcttxt;
    private int _Ispertinent;
    private string _Pertinenttxt;
    private int _Isotherplan;
    private string _Otherplantxt;
    private string _Pres;
    private string _Presid;
    private DateTime _Presdate;
    private string _Prestime;
    private string _Attending;
    private string _Attenid;
    private DateTime _Attendate;
    private string _Attentime;
    private string _Userid;
    private DateTime _Entrydate;
    private string _Updateduserid;
    private DateTime _UpdatedDate;

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string Orthoprogress { get { return _Orthoprogress; } set { _Orthoprogress = value; } }
    public virtual string Surgicalprocedure { get { return _Surgicalprocedure; } set { _Surgicalprocedure = value; } }
    public virtual System.DateTime Postday { get { return _Postday; } set { _Postday = value; } }
    public virtual string Subjective { get { return _Subjective; } set { _Subjective = value; } }
    public virtual string Othertxtsubjective { get { return _Othertxtsubjective; } set { _Othertxtsubjective = value; } }
    public virtual int ISAvst { get { return _ISAvst; } set { _ISAvst = value; } }
    public virtual int ISTemp { get { return _ISTemp; } set { _ISTemp = value; } }
    public virtual string Temptxt { get { return _Temptxt; } set { _Temptxt = value; } }
    public virtual int ISotherobjective { get { return _ISotherobjective; } set { _ISotherobjective = value; } }
    public virtual string Othertxtobjective { get { return _Othertxtobjective; } set { _Othertxtobjective = value; } }
    public virtual string Dressing { get { return _Dressing; } set { _Dressing = value; } }
    public virtual int ISCdai { get { return _ISCdai; } set { _ISCdai = value; } }
    public virtual int ISSdf { get { return _ISSdf; } set { _ISSdf = value; } }
    public virtual int ISIncision { get { return _ISIncision; } set { _ISIncision = value; } }
    public virtual int ISDrain { get { return _ISDrain; } set { _ISDrain = value; } }
    public virtual string Draintxt { get { return _Draintxt; } set { _Draintxt = value; } }
    public virtual int ISScant { get { return _ISScant; } set { _ISScant = value; } }
    public virtual int ISModerate { get { return _ISModerate; } set { _ISModerate = value; } }
    public virtual int ISsd { get { return _ISsd; } set { _ISsd = value; } }
    public virtual int ISincreasing { get { return _ISincreasing; } set { _ISincreasing = value; } }
    public virtual int Isstable { get { return _Isstable; } set { _Isstable = value; } }
    public virtual int Decreasing { get { return _Decreasing; } set { _Decreasing = value; } }
    public virtual int Iserythema { get { return _Iserythema; } set { _Iserythema = value; } }
    public virtual int IsPurulent { get { return _IsPurulent; } set { _IsPurulent = value; } }
    public virtual string Neuro { get { return _Neuro; } set { _Neuro = value; } }
    public virtual int ISncfp { get { return _ISncfp; } set { _ISncfp = value; } }
    public virtual int IsOtherNeuro { get { return _IsOtherNeuro; } set { _IsOtherNeuro = value; } }
    public virtual string EHL { get { return _EHL; } set { _EHL = value; } }
    public virtual string TA { get { return _TA; } set { _TA = value; } }
    public virtual string GS { get { return _GS; } set { _GS = value; } }
    public virtual string Quads { get { return _Quads; } set { _Quads = value; } }
    public virtual string Hamps { get { return _Hamps; } set { _Hamps = value; } }
    public virtual string Ipsoas { get { return _Ipsoas; } set { _Ipsoas = value; } }
    public virtual int Isitlt { get { return _Isitlt; } set { _Isitlt = value; } }
    public virtual int IsDecreased { get { return _IsDecreased; } set { _IsDecreased = value; } }
    public virtual int IsDysesthesia { get { return _IsDysesthesia; } set { _IsDysesthesia = value; } }
    public virtual int Issoft { get { return _Issoft; } set { _Issoft = value; } }
    public virtual int Isothercomp { get { return _Isothercomp; } set { _Isothercomp = value; } }
    public virtual string Othercomptxt { get { return _Othercomptxt; } set { _Othercomptxt = value; } }
    public virtual int Isppedis { get { return _Isppedis; } set { _Isppedis = value; } }
    public virtual int Post { get { return _Post; } set { _Post = value; } }
    public virtual int Refill { get { return _Refill; } set { _Refill = value; } }
    public virtual string Refilltxt { get { return _Refilltxt; } set { _Refilltxt = value; } }
    public virtual string Discharge { get { return _Discharge; } set { _Discharge = value; } }
    public virtual int Isctmp { get { return _Isctmp; } set { _Isctmp = value; } }
    public virtual int Iscptam { get { return _Iscptam; } set { _Iscptam = value; } }
    public virtual int Iswabt { get { return _Iswabt; } set { _Iswabt = value; } }
    public virtual int Ispwb { get { return _Ispwb; } set { _Ispwb = value; } }
    public virtual int Isttwb { get { return _Isttwb; } set { _Isttwb = value; } }
    public virtual int Isnwb { get { return _Isnwb; } set { _Isnwb = value; } }
    public virtual int Ispain { get { return _Ispain; } set { _Ispain = value; } }
    public virtual string Paintxt { get { return _Paintxt; } set { _Paintxt = value; } }
    public virtual int Isdvt { get { return _Isdvt; } set { _Isdvt = value; } }
    public virtual string Dcttxt { get { return _Dcttxt; } set { _Dcttxt = value; } }
    public virtual int Ispertinent { get { return _Ispertinent; } set { _Ispertinent = value; } }
    public virtual string Pertinenttxt { get { return _Pertinenttxt; } set { _Pertinenttxt = value; } }
    public virtual int Isotherplan { get { return _Isotherplan; } set { _Isotherplan = value; } }
    public virtual string Otherplantxt { get { return _Otherplantxt; } set { _Otherplantxt = value; } }
    public virtual string Pres { get { return _Pres; } set { _Pres = value; } }
    public virtual string Presid { get { return _Presid; } set { _Presid = value; } }
    public virtual DateTime Presdate { get { return _Presdate; } set { _Presdate = value; } }
    public virtual string Prestime { get { return _Prestime; } set { _Prestime = value; } }
    public virtual string Attending { get { return _Attending; } set { _Attending = value; } }
    public virtual string Attenid { get { return _Attenid; } set { _Attenid = value; } }
    public virtual DateTime Attendate { get { return _Attendate; } set { _Attendate = value; } }
    public virtual string Attentime { get { return _Attentime; } set { _Attentime = value; } }
    public virtual string Userid { get { return _Userid; } set { _Userid = value; } }
    public virtual DateTime Entrydate { get { return _Entrydate; } set { _Entrydate = value; } }
    public virtual string Updateduserid { get { return _Updateduserid; } set { _Updateduserid = value; } }
    public virtual DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("sp_ortho_progress_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vOrthoprogress", Util.GetString(Orthoprogress)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgicalprocedure", Util.GetString(Surgicalprocedure)));
            cmd.Parameters.Add(new MySqlParameter("@vPostday", Util.GetDateTime(Postday)));
            cmd.Parameters.Add(new MySqlParameter("@vSubjective", Util.GetString(Subjective)));
            cmd.Parameters.Add(new MySqlParameter("@vOthertxtsubjective", Util.GetString(Othertxtsubjective)));
            cmd.Parameters.Add(new MySqlParameter("@vISAvst", Util.GetInt(ISAvst)));
            cmd.Parameters.Add(new MySqlParameter("@vISTemp", Util.GetInt(ISTemp)));
            cmd.Parameters.Add(new MySqlParameter("@vTemptxt", Util.GetString(Temptxt)));
            cmd.Parameters.Add(new MySqlParameter("@vISotherobjective", Util.GetInt(ISotherobjective)));
            cmd.Parameters.Add(new MySqlParameter("@vOthertxtobjective", Util.GetString(Othertxtobjective)));
            cmd.Parameters.Add(new MySqlParameter("@vDressing", Util.GetString(Dressing)));
            cmd.Parameters.Add(new MySqlParameter("@vISCdai", Util.GetInt(ISCdai)));
            cmd.Parameters.Add(new MySqlParameter("@vISSdf", Util.GetInt(ISSdf)));
            cmd.Parameters.Add(new MySqlParameter("@vISIncision", Util.GetInt(ISIncision)));
            cmd.Parameters.Add(new MySqlParameter("@vISDrain", Util.GetInt(ISDrain)));
            cmd.Parameters.Add(new MySqlParameter("@vDraintxt", Util.GetString(Draintxt)));
            cmd.Parameters.Add(new MySqlParameter("@vISScant", Util.GetInt(ISScant)));
            cmd.Parameters.Add(new MySqlParameter("@vISModerate", Util.GetInt(ISModerate)));
            cmd.Parameters.Add(new MySqlParameter("@vISsd", Util.GetInt(ISsd)));
            cmd.Parameters.Add(new MySqlParameter("@vISincreasing", Util.GetInt(ISincreasing)));
            cmd.Parameters.Add(new MySqlParameter("@vIsstable", Util.GetInt(Isstable)));
            cmd.Parameters.Add(new MySqlParameter("@vDecreasing", Util.GetInt(Decreasing)));
            cmd.Parameters.Add(new MySqlParameter("@vIserythema", Util.GetInt(Iserythema)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPurulent", Util.GetInt(IsPurulent)));
            cmd.Parameters.Add(new MySqlParameter("@vNeuro", Util.GetString(Neuro)));
            cmd.Parameters.Add(new MySqlParameter("@vISncfp", Util.GetInt(ISncfp)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOtherNeuro", Util.GetInt(IsOtherNeuro)));
            cmd.Parameters.Add(new MySqlParameter("@vEHL", Util.GetString(EHL)));
            cmd.Parameters.Add(new MySqlParameter("@vTA", Util.GetString(TA)));
            cmd.Parameters.Add(new MySqlParameter("@vGS", Util.GetString(GS)));
            cmd.Parameters.Add(new MySqlParameter("@vQuads", Util.GetString(Quads)));
            cmd.Parameters.Add(new MySqlParameter("@vHamps", Util.GetString(Hamps)));
            cmd.Parameters.Add(new MySqlParameter("@vIpsoas", Util.GetString(Ipsoas)));
            cmd.Parameters.Add(new MySqlParameter("@vIsitlt", Util.GetInt(Isitlt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDecreased", Util.GetInt(IsDecreased)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDysesthesia", Util.GetInt(IsDysesthesia)));
            cmd.Parameters.Add(new MySqlParameter("@vIssoft", Util.GetInt(Issoft)));
            cmd.Parameters.Add(new MySqlParameter("@vIsothercomp", Util.GetInt(Isothercomp)));
            cmd.Parameters.Add(new MySqlParameter("@vOthercomptxt", Util.GetString(Othercomptxt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsppedis", Util.GetInt(Isppedis)));
            cmd.Parameters.Add(new MySqlParameter("@vPost", Util.GetInt(Post)));
            cmd.Parameters.Add(new MySqlParameter("@vRefill", Util.GetInt(Refill)));
            cmd.Parameters.Add(new MySqlParameter("@vRefilltxt", Util.GetString(Refilltxt)));
            cmd.Parameters.Add(new MySqlParameter("@vDischarge", Util.GetString(Discharge)));
            cmd.Parameters.Add(new MySqlParameter("@vIsctmp", Util.GetInt(Isctmp)));
            cmd.Parameters.Add(new MySqlParameter("@vIscptam", Util.GetInt(Iscptam)));
            cmd.Parameters.Add(new MySqlParameter("@vIswabt", Util.GetInt(Iswabt)));
            cmd.Parameters.Add(new MySqlParameter("@vIspwb", Util.GetInt(Ispwb)));
            cmd.Parameters.Add(new MySqlParameter("@vIsttwb", Util.GetInt(Isttwb)));
            cmd.Parameters.Add(new MySqlParameter("@vIsnwb", Util.GetInt(Isnwb)));
            cmd.Parameters.Add(new MySqlParameter("@vIspain", Util.GetInt(Ispain)));
            cmd.Parameters.Add(new MySqlParameter("@vPaintxt", Util.GetString(Paintxt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsdvt", Util.GetInt(Isdvt)));
            cmd.Parameters.Add(new MySqlParameter("@vDcttxt", Util.GetString(Dcttxt)));
            cmd.Parameters.Add(new MySqlParameter("@vIspertinent", Util.GetInt(Ispertinent)));
            cmd.Parameters.Add(new MySqlParameter("@vPertinenttxt", Util.GetString(Pertinenttxt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsotherplan", Util.GetInt(Isotherplan)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherplantxt", Util.GetString(Otherplantxt)));
            cmd.Parameters.Add(new MySqlParameter("@vPres", Util.GetString(Pres)));
            cmd.Parameters.Add(new MySqlParameter("@vPresid", Util.GetString(Presid)));
            cmd.Parameters.Add(new MySqlParameter("@vPresdate", Util.GetDateTime(Presdate)));
            cmd.Parameters.Add(new MySqlParameter("@vPrestime", Util.GetString(Prestime)));
            cmd.Parameters.Add(new MySqlParameter("@vAttending", Util.GetString(Attending)));
            cmd.Parameters.Add(new MySqlParameter("@vAttenid", Util.GetString(Attenid)));
            cmd.Parameters.Add(new MySqlParameter("@vAttendate", Util.GetDateTime(Attendate)));
            cmd.Parameters.Add(new MySqlParameter("@vAttentime", Util.GetString(Attentime)));
            cmd.Parameters.Add(new MySqlParameter("@vUserid", Util.GetString(Userid)));
            cmd.Parameters.Add(new MySqlParameter("@vEntrydate", Util.GetDateTime(Entrydate)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateduserid", Util.GetString(Updateduserid)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedDate", Util.GetDateTime(UpdatedDate)));

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

            objSQL.Append("sp_ortho_progress_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

           
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vOrthoprogress", Util.GetString(Orthoprogress)));
            cmd.Parameters.Add(new MySqlParameter("@vSurgicalprocedure", Util.GetString(Surgicalprocedure)));
            cmd.Parameters.Add(new MySqlParameter("@vPostday", Util.GetDateTime(Postday)));
            cmd.Parameters.Add(new MySqlParameter("@vSubjective", Util.GetString(Subjective)));
            cmd.Parameters.Add(new MySqlParameter("@vOthertxtsubjective", Util.GetString(Othertxtsubjective)));
            cmd.Parameters.Add(new MySqlParameter("@vISAvst", Util.GetInt(ISAvst)));
            cmd.Parameters.Add(new MySqlParameter("@vISTemp", Util.GetInt(ISTemp)));
            cmd.Parameters.Add(new MySqlParameter("@vTemptxt", Util.GetString(Temptxt)));
            cmd.Parameters.Add(new MySqlParameter("@vISotherobjective", Util.GetInt(ISotherobjective)));
            cmd.Parameters.Add(new MySqlParameter("@vOthertxtobjective", Util.GetString(Othertxtobjective)));
            cmd.Parameters.Add(new MySqlParameter("@vDressing", Util.GetString(Dressing)));
            cmd.Parameters.Add(new MySqlParameter("@vISCdai", Util.GetInt(ISCdai)));
            cmd.Parameters.Add(new MySqlParameter("@vISSdf", Util.GetInt(ISSdf)));
            cmd.Parameters.Add(new MySqlParameter("@vISIncision", Util.GetInt(ISIncision)));
            cmd.Parameters.Add(new MySqlParameter("@vISDrain", Util.GetInt(ISDrain)));
            cmd.Parameters.Add(new MySqlParameter("@vDraintxt", Util.GetString(Draintxt)));
            cmd.Parameters.Add(new MySqlParameter("@vISScant", Util.GetInt(ISScant)));
            cmd.Parameters.Add(new MySqlParameter("@vISModerate", Util.GetInt(ISModerate)));
            cmd.Parameters.Add(new MySqlParameter("@vISsd", Util.GetInt(ISsd)));
            cmd.Parameters.Add(new MySqlParameter("@vISincreasing", Util.GetInt(ISincreasing)));
            cmd.Parameters.Add(new MySqlParameter("@vIsstable", Util.GetInt(Isstable)));
            cmd.Parameters.Add(new MySqlParameter("@vDecreasing", Util.GetInt(Decreasing)));
            cmd.Parameters.Add(new MySqlParameter("@vIserythema", Util.GetInt(Iserythema)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPurulent", Util.GetInt(IsPurulent)));
            cmd.Parameters.Add(new MySqlParameter("@vNeuro", Util.GetString(Neuro)));
            cmd.Parameters.Add(new MySqlParameter("@vISncfp", Util.GetInt(ISncfp)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOtherNeuro", Util.GetInt(IsOtherNeuro)));
            cmd.Parameters.Add(new MySqlParameter("@vEHL", Util.GetString(EHL)));
            cmd.Parameters.Add(new MySqlParameter("@vTA", Util.GetString(TA)));
            cmd.Parameters.Add(new MySqlParameter("@vGS", Util.GetString(GS)));
            cmd.Parameters.Add(new MySqlParameter("@vQuads", Util.GetString(Quads)));
            cmd.Parameters.Add(new MySqlParameter("@vHamps", Util.GetString(Hamps)));
            cmd.Parameters.Add(new MySqlParameter("@vIpsoas", Util.GetString(Ipsoas)));
            cmd.Parameters.Add(new MySqlParameter("@vIsitlt", Util.GetInt(Isitlt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDecreased", Util.GetInt(IsDecreased)));
            cmd.Parameters.Add(new MySqlParameter("@vIsDysesthesia", Util.GetInt(IsDysesthesia)));
            cmd.Parameters.Add(new MySqlParameter("@vIssoft", Util.GetInt(Issoft)));
            cmd.Parameters.Add(new MySqlParameter("@vIsothercomp", Util.GetInt(Isothercomp)));
            cmd.Parameters.Add(new MySqlParameter("@vOthercomptxt", Util.GetString(Othercomptxt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsppedis", Util.GetInt(Isppedis)));
            cmd.Parameters.Add(new MySqlParameter("@vPost", Util.GetInt(Post)));
            cmd.Parameters.Add(new MySqlParameter("@vRefill", Util.GetInt(Refill)));
            cmd.Parameters.Add(new MySqlParameter("@vRefilltxt", Util.GetString(Refilltxt)));
            cmd.Parameters.Add(new MySqlParameter("@vDischarge", Util.GetString(Discharge)));
            cmd.Parameters.Add(new MySqlParameter("@vIsctmp", Util.GetInt(Isctmp)));
            cmd.Parameters.Add(new MySqlParameter("@vIscptam", Util.GetInt(Iscptam)));
            cmd.Parameters.Add(new MySqlParameter("@vIswabt", Util.GetInt(Iswabt)));
            cmd.Parameters.Add(new MySqlParameter("@vIspwb", Util.GetInt(Ispwb)));
            cmd.Parameters.Add(new MySqlParameter("@vIsttwb", Util.GetInt(Isttwb)));
            cmd.Parameters.Add(new MySqlParameter("@vIsnwb", Util.GetInt(Isnwb)));
            cmd.Parameters.Add(new MySqlParameter("@vIspain", Util.GetInt(Ispain)));
            cmd.Parameters.Add(new MySqlParameter("@vPaintxt", Util.GetString(Paintxt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsdvt", Util.GetInt(Isdvt)));
            cmd.Parameters.Add(new MySqlParameter("@vDcttxt", Util.GetString(Dcttxt)));
            cmd.Parameters.Add(new MySqlParameter("@vIspertinent", Util.GetInt(Ispertinent)));
            cmd.Parameters.Add(new MySqlParameter("@vPertinenttxt", Util.GetString(Pertinenttxt)));
            cmd.Parameters.Add(new MySqlParameter("@vIsotherplan", Util.GetInt(Isotherplan)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherplantxt", Util.GetString(Otherplantxt)));
            cmd.Parameters.Add(new MySqlParameter("@vPres", Util.GetString(Pres)));
            cmd.Parameters.Add(new MySqlParameter("@vPresid", Util.GetString(Presid)));
            cmd.Parameters.Add(new MySqlParameter("@vPresdate", Util.GetDateTime(Presdate)));
            cmd.Parameters.Add(new MySqlParameter("@vPrestime", Util.GetString(Prestime)));
            cmd.Parameters.Add(new MySqlParameter("@vAttending", Util.GetString(Attending)));
            cmd.Parameters.Add(new MySqlParameter("@vAttenid", Util.GetString(Attenid)));
            cmd.Parameters.Add(new MySqlParameter("@vAttendate", Util.GetDateTime(Attendate)));
            cmd.Parameters.Add(new MySqlParameter("@vAttentime", Util.GetString(Attentime)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdateduserid", Util.GetString(Updateduserid)));
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
            // Util.WriteLog(ex);   
            throw (ex);
        }
    }



    #endregion

}
