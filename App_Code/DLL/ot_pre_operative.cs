using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public class ot_pre_operative
{
    public ot_pre_operative()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public ot_pre_operative(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private string _Alert;
    private string _Sedated;
    private string _Apprehensive;
    private string _NonResponsive;
    private string _Confused;
    private string _OtherConciousness;
    private string _CommunicationStatus;
    private string _DescribeCS;
    private string _CommentCS;
    private string _Unlabored;
    private string _MinimusDistress;
    private string _Oxygen;
    private string _At;
    private string _LMin;
    private string _LMinTxt;
    private string _EndotrachelTube;
    private string _Tracheostomy;
    private string _Psycho;
    private string _NeedPreOp;
    private string _Appears;
    private string _Alergies;
    private string _SpecifyAlergy;
    private string _BloodAvailability;
    private string _BloodUnit;
    private string _ConfirmedWith;
    private string _PresentAdmission;
    private string _StartedInORPIL;
    private string _PILBy;
    private string _Location;
    private string _IML;
    private string _StartedInORIML;
    private string _IMLBy;
    private string _ArterialLine1;
    private string _Site1;
    private string _ArterialLine2;
    private string _Site2;
    private string _Pain;
    private string _PainComment;
    private string _NoLimitation;
    private string _PainfulJoints;
    private string _PainfulJointsSite;
    private string _JointProsthesis;
    private string _JointProsthesisSite;
    private string _OtherMobility;
    private string _Traction;
    private string _EnterBy;
    private string _PsychoSocial;
    private string _OtherAppears;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Set All Property

    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual string Alert { get { return _Alert; } set { _Alert = value; } }
    public virtual string Sedated { get { return _Sedated; } set { _Sedated = value; } }
    public virtual string Apprehensive { get { return _Apprehensive; } set { _Apprehensive = value; } }
    public virtual string NonResponsive { get { return _NonResponsive; } set { _NonResponsive = value; } }
    public virtual string Confused { get { return _Confused; } set { _Confused = value; } }
    public virtual string OtherConciousness { get { return _OtherConciousness; } set { _OtherConciousness = value; } }
    public virtual string CommunicationStatus { get { return _CommunicationStatus; } set { _CommunicationStatus = value; } }
    public virtual string DescribeCS { get { return _DescribeCS; } set { _DescribeCS = value; } }
    public virtual string CommentCS { get { return _CommentCS; } set { _CommentCS = value; } }
    public virtual string Unlabored { get { return _Unlabored; } set { _Unlabored = value; } }
    public virtual string MinimusDistress { get { return _MinimusDistress; } set { _MinimusDistress = value; } }
    public virtual string Oxygen { get { return _Oxygen; } set { _Oxygen = value; } }
    public virtual string At { get { return _At; } set { _At = value; } }
    public virtual string LMin { get { return _LMin; } set { _LMin = value; } }
    public virtual string LMinTxt { get { return _LMinTxt; } set { _LMinTxt = value; } }
    public virtual string EndotrachelTube { get { return _EndotrachelTube; } set { _EndotrachelTube = value; } }
    public virtual string Tracheostomy { get { return _Tracheostomy; } set { _Tracheostomy = value; } }
    public virtual string Psycho { get { return _Psycho; } set { _Psycho = value; } }
    public virtual string NeedPreOp { get { return _NeedPreOp; } set { _NeedPreOp = value; } }
    public virtual string Appears { get { return _Appears; } set { _Appears = value; } }
    public virtual string Alergies { get { return _Alergies; } set { _Alergies = value; } }
    public virtual string SpecifyAlergy { get { return _SpecifyAlergy; } set { _SpecifyAlergy = value; } }
    public virtual string BloodAvailability { get { return _BloodAvailability; } set { _BloodAvailability = value; } }
    public virtual string BloodUnit { get { return _BloodUnit; } set { _BloodUnit = value; } }
    public virtual string ConfirmedWith { get { return _ConfirmedWith; } set { _ConfirmedWith = value; } }
    public virtual string PresentAdmission { get { return _PresentAdmission; } set { _PresentAdmission = value; } }
    public virtual string StartedInORPIL { get { return _StartedInORPIL; } set { _StartedInORPIL = value; } }
    public virtual string PILBy { get { return _PILBy; } set { _PILBy = value; } }
    public virtual string Location { get { return _Location; } set { _Location = value; } }
    public virtual string IML { get { return _IML; } set { _IML = value; } }
    public virtual string StartedInORIML { get { return _StartedInORIML; } set { _StartedInORIML = value; } }
    public virtual string IMLBy { get { return _IMLBy; } set { _IMLBy = value; } }
    public virtual string ArterialLine1 { get { return _ArterialLine1; } set { _ArterialLine1 = value; } }
    public virtual string Site1 { get { return _Site1; } set { _Site1 = value; } }
    public virtual string ArterialLine2 { get { return _ArterialLine2; } set { _ArterialLine2 = value; } }
    public virtual string Site2 { get { return _Site2; } set { _Site2 = value; } }
    public virtual string Pain { get { return _Pain; } set { _Pain = value; } }
    public virtual string PainComment { get { return _PainComment; } set { _PainComment = value; } }
    public virtual string NoLimitation { get { return _NoLimitation; } set { _NoLimitation = value; } }
    public virtual string PainfulJoints { get { return _PainfulJoints; } set { _PainfulJoints = value; } }
    public virtual string PainfulJointsSite { get { return _PainfulJointsSite; } set { _PainfulJointsSite = value; } }
    public virtual string JointProsthesis { get { return _JointProsthesis; } set { _JointProsthesis = value; } }
    public virtual string JointProsthesisSite { get { return _JointProsthesisSite; } set { _JointProsthesisSite = value; } }
    public virtual string OtherMobility { get { return _OtherMobility; } set { _OtherMobility = value; } }
    public virtual string Traction { get { return _Traction; } set { _Traction = value; } }
    public virtual string EnterBy { get { return _EnterBy; } set { _EnterBy = value; } }
    public virtual string PsychoSocial { get { return _PsychoSocial; } set { _PsychoSocial = value; } }
    public virtual string OtherAppears { get { return _OtherAppears; } set { _OtherAppears = value; } }

    #endregion Set All Property

    #region All Public Member Function

    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("ot_pre_operative_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vAlert", Util.GetString(Alert)));
            cmd.Parameters.Add(new MySqlParameter("@vSedated", Util.GetString(Sedated)));
            cmd.Parameters.Add(new MySqlParameter("@vApprehensive", Util.GetString(Apprehensive)));
            cmd.Parameters.Add(new MySqlParameter("@vNonResponsive", Util.GetString(NonResponsive)));
            cmd.Parameters.Add(new MySqlParameter("@vConfused", Util.GetString(Confused)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherConciousness", Util.GetString(OtherConciousness)));
            cmd.Parameters.Add(new MySqlParameter("@vCommunicationStatus", Util.GetString(CommunicationStatus)));
            cmd.Parameters.Add(new MySqlParameter("@vDescribeCS", Util.GetString(DescribeCS)));
            cmd.Parameters.Add(new MySqlParameter("@vCommentCS", Util.GetString(CommentCS)));
            cmd.Parameters.Add(new MySqlParameter("@vUnlabored", Util.GetString(Unlabored)));
            cmd.Parameters.Add(new MySqlParameter("@vMinimusDistress", Util.GetString(MinimusDistress)));
            cmd.Parameters.Add(new MySqlParameter("@vOxygen", Util.GetString(Oxygen)));
            cmd.Parameters.Add(new MySqlParameter("@vAt", Util.GetString(At)));
            cmd.Parameters.Add(new MySqlParameter("@vLMin", Util.GetString(LMin)));
            cmd.Parameters.Add(new MySqlParameter("@vLMinTxt", Util.GetString(LMinTxt)));
            cmd.Parameters.Add(new MySqlParameter("@vEndotrachelTube", Util.GetString(EndotrachelTube)));
            cmd.Parameters.Add(new MySqlParameter("@vTracheostomy", Util.GetString(Tracheostomy)));
            cmd.Parameters.Add(new MySqlParameter("@vPsycho", Util.GetString(Psycho)));
            cmd.Parameters.Add(new MySqlParameter("@vNeedPreOp", Util.GetString(NeedPreOp)));
            cmd.Parameters.Add(new MySqlParameter("@vAppears", Util.GetString(Appears)));
            cmd.Parameters.Add(new MySqlParameter("@vAlergies", Util.GetString(Alergies)));
            cmd.Parameters.Add(new MySqlParameter("@vSpecifyAlergy", Util.GetString(SpecifyAlergy)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodAvailability", Util.GetString(BloodAvailability)));
            cmd.Parameters.Add(new MySqlParameter("@vBloodUnit", Util.GetString(BloodUnit)));
            cmd.Parameters.Add(new MySqlParameter("@vConfirmedWith", Util.GetString(ConfirmedWith)));
            cmd.Parameters.Add(new MySqlParameter("@vPresentAdmission", Util.GetString(PresentAdmission)));
            cmd.Parameters.Add(new MySqlParameter("@vStartedInORPIL", Util.GetString(StartedInORPIL)));
            cmd.Parameters.Add(new MySqlParameter("@vPILBy", Util.GetString(PILBy)));
            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vIML", Util.GetString(IML)));
            cmd.Parameters.Add(new MySqlParameter("@vStartedInORIML", Util.GetString(StartedInORIML)));
            cmd.Parameters.Add(new MySqlParameter("@vIMLBy", Util.GetString(IMLBy)));
            cmd.Parameters.Add(new MySqlParameter("@vArterialLine1", Util.GetString(ArterialLine1)));
            cmd.Parameters.Add(new MySqlParameter("@vSite1", Util.GetString(Site1)));
            cmd.Parameters.Add(new MySqlParameter("@vArterialLine2", Util.GetString(ArterialLine2)));
            cmd.Parameters.Add(new MySqlParameter("@vSite2", Util.GetString(Site2)));
            cmd.Parameters.Add(new MySqlParameter("@vPain", Util.GetString(Pain)));
            cmd.Parameters.Add(new MySqlParameter("@vPainComment", Util.GetString(PainComment)));
            cmd.Parameters.Add(new MySqlParameter("@vNoLimitation", Util.GetString(NoLimitation)));
            cmd.Parameters.Add(new MySqlParameter("@vPainfulJoints", Util.GetString(PainfulJoints)));
            cmd.Parameters.Add(new MySqlParameter("@vPainfulJointsSite", Util.GetString(PainfulJointsSite)));
            cmd.Parameters.Add(new MySqlParameter("@vJointProsthesis", Util.GetString(JointProsthesis)));
            cmd.Parameters.Add(new MySqlParameter("@vJointProsthesisSite", Util.GetString(JointProsthesisSite)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherMobility", Util.GetString(OtherMobility)));
            cmd.Parameters.Add(new MySqlParameter("@vTraction", Util.GetString(Traction)));
            cmd.Parameters.Add(new MySqlParameter("@vEnterBy", Util.GetString(EnterBy)));
            cmd.Parameters.Add(new MySqlParameter("@vPsychoSocial", Util.GetString(PsychoSocial)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherAppears", Util.GetString(OtherAppears)));

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