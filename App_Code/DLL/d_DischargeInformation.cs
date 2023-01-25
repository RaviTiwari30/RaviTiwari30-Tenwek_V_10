using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for d_dischargeinformation
/// Generated using MySqlManager
/// ==========================================================================================
/// Author:              ANKIT
/// Create date:	10/5/2013 1:03:17 AM
/// Description:	This class is intended for inserting, updating, deleting values for d_dischargeinformation table
/// ==========================================================================================
/// </summary>

public class d_dischargeinformation
{
    public d_dischargeinformation()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public d_dischargeinformation(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private int _ID;
    private string _TransactionID;
    private int _IsSurgicalSite;
    private int _IsCoumadinInstruction;
    private int _IsPainManagement;
    private int _IsHeartFailure;
    private int _IsOtherDischarge;
    private string _OtherDischargeInst;
    private string _PhysicalActivity;
    private string _PhysicalActivityMayWalk;
    private string _PhysicalActivityWeightBearing;
    private string _EquipmentProvided;
    private string _EquipmentProvidedOther;
    private string _Nutrition;
    private string _NutritionEducationMaterial;
    private string _DischargeInfoDischargeTo;
    private string _AgencyFacilityname1;
    private string _Phone1;
    private string _AgencyFacilityname2;
    private string _Phone2;
    private string _DischargeVia;
    private string _AccompainedBy;
    private string _PickupTime;
    private string _CompanyName;
    private int _IsFollowUp;
    private string _Dr;
    private string _FollowUpPhone;
    private string _FollowUpDaysWeek;
    private string _FollowUpCall;
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
    public virtual int IsSurgicalSite { get { return _IsSurgicalSite; } set { _IsSurgicalSite = value; } }
    public virtual int IsCoumadinInstruction { get { return _IsCoumadinInstruction; } set { _IsCoumadinInstruction = value; } }
    public virtual int IsPainManagement { get { return _IsPainManagement; } set { _IsPainManagement = value; } }
    public virtual int IsHeartFailure { get { return _IsHeartFailure; } set { _IsHeartFailure = value; } }
    public virtual int IsOtherDischarge { get { return _IsOtherDischarge; } set { _IsOtherDischarge = value; } }
    public virtual string OtherDischargeInst { get { return _OtherDischargeInst; } set { _OtherDischargeInst = value; } }
    public virtual string PhysicalActivity { get { return _PhysicalActivity; } set { _PhysicalActivity = value; } }
    public virtual string PhysicalActivityMayWalk { get { return _PhysicalActivityMayWalk; } set { _PhysicalActivityMayWalk = value; } }
    public virtual string PhysicalActivityWeightBearing { get { return _PhysicalActivityWeightBearing; } set { _PhysicalActivityWeightBearing = value; } }
    public virtual string EquipmentProvided { get { return _EquipmentProvided; } set { _EquipmentProvided = value; } }
    public virtual string EquipmentProvidedOther { get { return _EquipmentProvidedOther; } set { _EquipmentProvidedOther = value; } }
    public virtual string Nutrition { get { return _Nutrition; } set { _Nutrition = value; } }
    public virtual string NutritionEducationMaterial { get { return _NutritionEducationMaterial; } set { _NutritionEducationMaterial = value; } }
    public virtual string DischargeInfoDischargeTo { get { return _DischargeInfoDischargeTo; } set { _DischargeInfoDischargeTo = value; } }
    public virtual string AgencyFacilityname1 { get { return _AgencyFacilityname1; } set { _AgencyFacilityname1 = value; } }
    public virtual string Phone1 { get { return _Phone1; } set { _Phone1 = value; } }
    public virtual string AgencyFacilityname2 { get { return _AgencyFacilityname2; } set { _AgencyFacilityname2 = value; } }
    public virtual string Phone2 { get { return _Phone2; } set { _Phone2 = value; } }
    public virtual string DischargeVia { get { return _DischargeVia; } set { _DischargeVia = value; } }
    public virtual string AccompainedBy { get { return _AccompainedBy; } set { _AccompainedBy = value; } }
    public virtual string PickupTime { get { return _PickupTime; } set { _PickupTime = value; } }
    public virtual string CompanyName { get { return _CompanyName; } set { _CompanyName = value; } }
    public virtual int IsFollowUp { get { return _IsFollowUp; } set { _IsFollowUp = value; } }
    public virtual string Dr { get { return _Dr; } set { _Dr = value; } }
    public virtual string FollowUpPhone { get { return _FollowUpPhone; } set { _FollowUpPhone = value; } }
    public virtual string FollowUpDaysWeek { get { return _FollowUpDaysWeek; } set { _FollowUpDaysWeek = value; } }
    public virtual string FollowUpCall { get { return _FollowUpCall; } set { _FollowUpCall = value; } }
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

            objSQL.Append("d_dischargeinformation_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSurgicalSite", Util.GetInt(IsSurgicalSite)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCoumadinInstruction", Util.GetInt(IsCoumadinInstruction)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPainManagement", Util.GetInt(IsPainManagement)));
            cmd.Parameters.Add(new MySqlParameter("@vIsHeartFailure", Util.GetInt(IsHeartFailure)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOtherDischarge", Util.GetInt(IsOtherDischarge)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherDischargeInst", Util.GetString(OtherDischargeInst)));
            cmd.Parameters.Add(new MySqlParameter("@vPhysicalActivity", Util.GetString(PhysicalActivity)));
            cmd.Parameters.Add(new MySqlParameter("@vPhysicalActivityMayWalk", Util.GetString(PhysicalActivityMayWalk)));
            cmd.Parameters.Add(new MySqlParameter("@vPhysicalActivityWeightBearing", Util.GetString(PhysicalActivityWeightBearing)));
            cmd.Parameters.Add(new MySqlParameter("@vEquipmentProvided", Util.GetString(EquipmentProvided)));
            cmd.Parameters.Add(new MySqlParameter("@vEquipmentProvidedOther", Util.GetString(EquipmentProvidedOther)));
            cmd.Parameters.Add(new MySqlParameter("@vNutrition", Util.GetString(Nutrition)));
            cmd.Parameters.Add(new MySqlParameter("@vNutritionEducationMaterial", Util.GetString(NutritionEducationMaterial)));
            cmd.Parameters.Add(new MySqlParameter("@vDischargeInfoDischargeTo", Util.GetString(DischargeInfoDischargeTo)));
            cmd.Parameters.Add(new MySqlParameter("@vAgencyFacilityname1", Util.GetString(AgencyFacilityname1)));
            cmd.Parameters.Add(new MySqlParameter("@vPhone1", Util.GetString(Phone1)));
            cmd.Parameters.Add(new MySqlParameter("@vAgencyFacilityname2", Util.GetString(AgencyFacilityname2)));
            cmd.Parameters.Add(new MySqlParameter("@vPhone2", Util.GetString(Phone2)));
            cmd.Parameters.Add(new MySqlParameter("@vDischargeVia", Util.GetString(DischargeVia)));
            cmd.Parameters.Add(new MySqlParameter("@vAccompainedBy", Util.GetString(AccompainedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vPickupTime", Util.GetString(PickupTime)));
            cmd.Parameters.Add(new MySqlParameter("@vCompanyName", Util.GetString(CompanyName)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFollowUp", Util.GetInt(IsFollowUp)));
            cmd.Parameters.Add(new MySqlParameter("@vDr", Util.GetString(Dr)));
            cmd.Parameters.Add(new MySqlParameter("@vFollowUpPhone", Util.GetString(FollowUpPhone)));
            cmd.Parameters.Add(new MySqlParameter("@vFollowUpDaysWeek", Util.GetString(FollowUpDaysWeek)));
            cmd.Parameters.Add(new MySqlParameter("@vFollowUpCall", Util.GetString(FollowUpCall)));
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

            objSQL.Append("d_dischargeinformation_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vIsSurgicalSite", Util.GetInt(IsSurgicalSite)));
            cmd.Parameters.Add(new MySqlParameter("@vIsCoumadinInstruction", Util.GetInt(IsCoumadinInstruction)));
            cmd.Parameters.Add(new MySqlParameter("@vIsPainManagement", Util.GetInt(IsPainManagement)));
            cmd.Parameters.Add(new MySqlParameter("@vIsHeartFailure", Util.GetInt(IsHeartFailure)));
            cmd.Parameters.Add(new MySqlParameter("@vIsOtherDischarge", Util.GetInt(IsOtherDischarge)));
            cmd.Parameters.Add(new MySqlParameter("@vOtherDischargeInst", Util.GetString(OtherDischargeInst)));
            cmd.Parameters.Add(new MySqlParameter("@vPhysicalActivity", Util.GetString(PhysicalActivity)));
            cmd.Parameters.Add(new MySqlParameter("@vPhysicalActivityMayWalk", Util.GetString(PhysicalActivityMayWalk)));
            cmd.Parameters.Add(new MySqlParameter("@vPhysicalActivityWeightBearing", Util.GetString(PhysicalActivityWeightBearing)));
            cmd.Parameters.Add(new MySqlParameter("@vEquipmentProvided", Util.GetString(EquipmentProvided)));
            cmd.Parameters.Add(new MySqlParameter("@vEquipmentProvidedOther", Util.GetString(EquipmentProvidedOther)));
            cmd.Parameters.Add(new MySqlParameter("@vNutrition", Util.GetString(Nutrition)));
            cmd.Parameters.Add(new MySqlParameter("@vNutritionEducationMaterial", Util.GetString(NutritionEducationMaterial)));
            cmd.Parameters.Add(new MySqlParameter("@vDischargeInfoDischargeTo", Util.GetString(DischargeInfoDischargeTo)));
            cmd.Parameters.Add(new MySqlParameter("@vAgencyFacilityname1", Util.GetString(AgencyFacilityname1)));
            cmd.Parameters.Add(new MySqlParameter("@vPhone1", Util.GetString(Phone1)));
            cmd.Parameters.Add(new MySqlParameter("@vAgencyFacilityname2", Util.GetString(AgencyFacilityname2)));
            cmd.Parameters.Add(new MySqlParameter("@vPhone2", Util.GetString(Phone2)));
            cmd.Parameters.Add(new MySqlParameter("@vDischargeVia", Util.GetString(DischargeVia)));
            cmd.Parameters.Add(new MySqlParameter("@vAccompainedBy", Util.GetString(AccompainedBy)));
            cmd.Parameters.Add(new MySqlParameter("@vPickupTime", Util.GetString(PickupTime)));
            cmd.Parameters.Add(new MySqlParameter("@vCompanyName", Util.GetString(CompanyName)));
            cmd.Parameters.Add(new MySqlParameter("@vIsFollowUp", Util.GetInt(IsFollowUp)));
            cmd.Parameters.Add(new MySqlParameter("@vDr", Util.GetString(Dr)));
            cmd.Parameters.Add(new MySqlParameter("@vFollowUpPhone", Util.GetString(FollowUpPhone)));
            cmd.Parameters.Add(new MySqlParameter("@vFollowUpDaysWeek", Util.GetString(FollowUpDaysWeek)));
            cmd.Parameters.Add(new MySqlParameter("@vFollowUpCall", Util.GetString(FollowUpCall)));
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
