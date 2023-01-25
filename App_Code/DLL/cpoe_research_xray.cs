using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;



public class cpoe_research_xray
{
    public cpoe_research_xray()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public cpoe_research_xray(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _AntoRight;
    private string _AntoLeft;
    private string _LessFemurRight;
    private string _LessFemurLeft;
    private string _LessAPRight;
    private string _LessAPLeft;
    private string _LessLateralRight;
    private string _LessLateralLeft;
    private string _LessScrewsRight;
    private string _LessScrewsLeft;
    private string _LessSkylineRight;
    private string _LessSkylineLeft;
    private string _CementedFemurRight;
    private string _CementedFemurLeft;
    private string _CementedAPRight;
    private string _CementedAPLeft;
    private string _CementedLateralRight;
    private string _CementedLateralLeft;
    private string _CementedSkylineRight;
    private string _CementedSkylineLeft;
    private string _LooseFemurRight;
    private string _LooseFemurLeft;
    private string _LooseTlbiaRight;
    private string _LooseTlbiaLeft;
    private string _LoosePatellaRight;
    private string _LoosePatellaLeft;
    private string _ReRight;
    private string _ReLeft;
    private string _ProRight;
    private string _ProLeft;
    private string _EnteryBy;
    private DateTime _EntryDate;
    private string _UpdatedBy;
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
    public virtual string AntoRight { get { return _AntoRight; } set { _AntoRight = value; } }
    public virtual string AntoLeft { get { return _AntoLeft; } set { _AntoLeft = value; } }
    public virtual string LessFemurRight { get { return _LessFemurRight; } set { _LessFemurRight = value; } }
    public virtual string LessFemurLeft { get { return _LessFemurLeft; } set { _LessFemurLeft = value; } }
    public virtual string LessAPRight { get { return _LessAPRight; } set { _LessAPRight = value; } }
    public virtual string LessAPLeft { get { return _LessAPLeft; } set { _LessAPLeft = value; } }
    public virtual string LessLateralRight { get { return _LessLateralRight; } set { _LessLateralRight = value; } }
    public virtual string LessLateralLeft { get { return _LessLateralLeft; } set { _LessLateralLeft = value; } }
    public virtual string LessScrewsRight { get { return _LessScrewsRight; } set { _LessScrewsRight = value; } }
    public virtual string LessScrewsLeft { get { return _LessScrewsLeft; } set { _LessScrewsLeft = value; } }
    public virtual string LessSkylineRight { get { return _LessSkylineRight; } set { _LessSkylineRight = value; } }
    public virtual string LessSkylineLeft { get { return _LessSkylineLeft; } set { _LessSkylineLeft = value; } }
    public virtual string CementedFemurRight { get { return _CementedFemurRight; } set { _CementedFemurRight = value; } }
    public virtual string CementedFemurLeft { get { return _CementedFemurLeft; } set { _CementedFemurLeft = value; } }
    public virtual string CementedAPRight { get { return _CementedAPRight; } set { _CementedAPRight = value; } }
    public virtual string CementedAPLeft { get { return _CementedAPLeft; } set { _CementedAPLeft = value; } }
    public virtual string CementedLateralRight { get { return _CementedLateralRight; } set { _CementedLateralRight = value; } }
    public virtual string CementedLateralLeft { get { return _CementedLateralLeft; } set { _CementedLateralLeft = value; } }
    public virtual string CementedSkylineRight { get { return _CementedSkylineRight; } set { _CementedSkylineRight = value; } }
    public virtual string CementedSkylineLeft { get { return _CementedSkylineLeft; } set { _CementedSkylineLeft = value; } }
    public virtual string LooseFemurRight { get { return _LooseFemurRight; } set { _LooseFemurRight = value; } }
    public virtual string LooseFemurLeft { get { return _LooseFemurLeft; } set { _LooseFemurLeft = value; } }
    public virtual string LooseTlbiaRight { get { return _LooseTlbiaRight; } set { _LooseTlbiaRight = value; } }
    public virtual string LooseTlbiaLeft { get { return _LooseTlbiaLeft; } set { _LooseTlbiaLeft = value; } }
    public virtual string LoosePatellaRight { get { return _LoosePatellaRight; } set { _LoosePatellaRight = value; } }
    public virtual string LoosePatellaLeft { get { return _LoosePatellaLeft; } set { _LoosePatellaLeft = value; } }
    public virtual string ReRight { get { return _ReRight; } set { _ReRight = value; } }
    public virtual string ReLeft { get { return _ReLeft; } set { _ReLeft = value; } }
    public virtual string ProRight { get { return _ProRight; } set { _ProRight = value; } }
    public virtual string ProLeft { get { return _ProLeft; } set { _ProLeft = value; } }
    public virtual string EnteryBy { get { return _EnteryBy; } set { _EnteryBy = value; } }
    public virtual DateTime EntryDate { get { return _EntryDate; } set { _EntryDate = value; } }
    public virtual string UpdatedBy { get { return _UpdatedBy; } set { _UpdatedBy = value; } }
    public virtual DateTime UpdatedDate { get { return _UpdatedDate; } set { _UpdatedDate = value; } }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("cpoe_research_xray_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vAntoRight", Util.GetString(AntoRight)));
            cmd.Parameters.Add(new MySqlParameter("@vAntoLeft", Util.GetString(AntoLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLessFemurRight", Util.GetString(LessFemurRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLessFemurLeft", Util.GetString(LessFemurLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLessAPRight", Util.GetString(LessAPRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLessAPLeft", Util.GetString(LessAPLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLessLateralRight", Util.GetString(LessLateralRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLessLateralLeft", Util.GetString(LessLateralLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLessScrewsRight", Util.GetString(LessScrewsRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLessScrewsLeft", Util.GetString(LessScrewsLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLessSkylineRight", Util.GetString(LessSkylineRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLessSkylineLeft", Util.GetString(LessSkylineLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedFemurRight", Util.GetString(CementedFemurRight)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedFemurLeft", Util.GetString(CementedFemurLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedAPRight", Util.GetString(CementedAPRight)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedAPLeft", Util.GetString(CementedAPLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedLateralRight", Util.GetString(CementedLateralRight)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedLateralLeft", Util.GetString(CementedLateralLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedSkylineRight", Util.GetString(CementedSkylineRight)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedSkylineLeft", Util.GetString(CementedSkylineLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLooseFemurRight", Util.GetString(LooseFemurRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLooseFemurLeft", Util.GetString(LooseFemurLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLooseTlbiaRight", Util.GetString(LooseTlbiaRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLooseTlbiaLeft", Util.GetString(LooseTlbiaLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLoosePatellaRight", Util.GetString(LoosePatellaRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLoosePatellaLeft", Util.GetString(LoosePatellaLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vReRight", Util.GetString(ReRight)));
            cmd.Parameters.Add(new MySqlParameter("@vReLeft", Util.GetString(ReLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vProRight", Util.GetString(ProRight)));
            cmd.Parameters.Add(new MySqlParameter("@vProLeft", Util.GetString(ProLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vEnteryBy", Util.GetString(EnteryBy)));
            

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

            objSQL.Append("cpoe_research_xray_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vAntoRight", Util.GetString(AntoRight)));
            cmd.Parameters.Add(new MySqlParameter("@vAntoLeft", Util.GetString(AntoLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLessFemurRight", Util.GetString(LessFemurRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLessFemurLeft", Util.GetString(LessFemurLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLessAPRight", Util.GetString(LessAPRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLessAPLeft", Util.GetString(LessAPLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLessLateralRight", Util.GetString(LessLateralRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLessLateralLeft", Util.GetString(LessLateralLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLessScrewsRight", Util.GetString(LessScrewsRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLessScrewsLeft", Util.GetString(LessScrewsLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLessSkylineRight", Util.GetString(LessSkylineRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLessSkylineLeft", Util.GetString(LessSkylineLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedFemurRight", Util.GetString(CementedFemurRight)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedFemurLeft", Util.GetString(CementedFemurLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedAPRight", Util.GetString(CementedAPRight)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedAPLeft", Util.GetString(CementedAPLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedLateralRight", Util.GetString(CementedLateralRight)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedLateralLeft", Util.GetString(CementedLateralLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedSkylineRight", Util.GetString(CementedSkylineRight)));
            cmd.Parameters.Add(new MySqlParameter("@vCementedSkylineLeft", Util.GetString(CementedSkylineLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLooseFemurRight", Util.GetString(LooseFemurRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLooseFemurLeft", Util.GetString(LooseFemurLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLooseTlbiaRight", Util.GetString(LooseTlbiaRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLooseTlbiaLeft", Util.GetString(LooseTlbiaLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vLoosePatellaRight", Util.GetString(LoosePatellaRight)));
            cmd.Parameters.Add(new MySqlParameter("@vLoosePatellaLeft", Util.GetString(LoosePatellaLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vReRight", Util.GetString(ReRight)));
            cmd.Parameters.Add(new MySqlParameter("@vReLeft", Util.GetString(ReLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vProRight", Util.GetString(ProRight)));
            cmd.Parameters.Add(new MySqlParameter("@vProLeft", Util.GetString(ProLeft)));
            cmd.Parameters.Add(new MySqlParameter("@vUpdatedBy", Util.GetString(UpdatedBy)));
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
