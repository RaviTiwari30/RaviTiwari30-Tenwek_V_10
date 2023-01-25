using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Text;
using System.Data;

/// <summary>
/// Summary description for Mortuary_Corpse_Master
/// </summary>
public class Mortuary_Corpse_Master
{
    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _Corpse_ID;
    private string _Patient_ID;
    private string _Transaction_ID;
    private string _FirstName;
    private string _LastName;
    private string _CName;
    private string _Age;
    private string _Gender;
    private DateTime _DeathDate;
    private DateTime _DeathTime;
    private string _DeathType;
    private string _Nationality;
    private string _Religion;
    private string _Locality;
    private string _Address;
    private string _City;
    private string _Country;
    private string _OtherAddress;
    private string _PermitNo;
    private string _Mobile;
    private string _NationalID;
    private string _InfectiousRemark;
    private string _Type;
    private string _PlaceOfDeath;
    private string _HospitalName;
    private string _RelativeName;
    private string _TypeOfRelation;
    private string _RelativeAddress;
    private string _RelativeContact;
    private string _RelativeEmail;
    private string _CreatedBy;
    private int _CentreID;
    private int _HospCentreID;

    #endregion

    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public Mortuary_Corpse_Master()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public Mortuary_Corpse_Master(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion

    #region Set All Property
    public virtual string Location
    {
        get
        {
            return _Location;
        }
        set
        {
            _Location = value;
        }
    }
    public virtual string HospCode
    {
        get
        {
            return _HospCode;
        }
        set
        {
            _HospCode = value;
        }
    }
    public int ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    public string Corpse_ID
    {
        get { return _Corpse_ID; }
        set { _Corpse_ID = value; }
    }

    public string Patient_ID
    {
        get { return _Patient_ID; }
        set { _Patient_ID = value; }
    }

    public string Transaction_ID
    {
        get { return _Transaction_ID; }
        set { _Transaction_ID = value; }
    }
    public string FirstName
    {
        get { return _FirstName; }
        set { _FirstName = value; }
    }
    public string LastName
    {
        get { return _LastName; }
        set { _LastName = value; }
    }
    public string CName
    {
        get { return _CName; }
        set { _CName = value; }
    }
    public string Age
    {
        get { return _Age; }
        set { _Age = value; }
    }
    public string Gender
    {
        get { return _Gender; }
        set { _Gender = value; }
    }
    public DateTime DeathDate
    {
        get { return _DeathDate; }
        set { _DeathDate = value; }
    }
    public DateTime DeathTime
    {
        get { return _DeathTime; }
        set { _DeathTime = value; }
    }

    public string DeathType
    {
        get { return _DeathType; }
        set { _DeathType = value; }
    }

    public string Nationality
    {
        get { return _Nationality; }
        set { _Nationality = value; }
    }
    public string Religion
    {
        get { return _Religion; }
        set { _Religion = value; }
    }

    public string Locality
    {
        get { return _Locality; }
        set { _Locality = value; }
    }
    public string Address
    {
        get { return _Address; }
        set { _Address = value; }
    }
    public string City
    {
        get { return _City; }
        set { _City = value; }
    }
    public string Country
    {
        get { return _Country; }
        set { _Country = value; }
    }
    public string OtherAddress
    {
        get { return _OtherAddress; }
        set { _OtherAddress = value; }
    }

    public string PermitNo
    {
        get { return _PermitNo; }
        set { _PermitNo = value; }
    }
    public string Mobile
    {
        get { return _Mobile; }
        set { _Mobile = value; }
    }

    public string NationalID
    {
        get { return _NationalID; }
        set { _NationalID = value; }
    }
    public string InfectiousRemark
    {
        get { return _InfectiousRemark; }
        set { _InfectiousRemark = value; }
    }
    public string PlaceOfDeath
    {
        get { return _PlaceOfDeath; }
        set { _PlaceOfDeath = value; }
    }
    public string HospitalName
    {
        get { return _HospitalName; }
        set { _HospitalName = value; }
    }

    public string Type
    {
        get { return _Type; }
        set { _Type = value; }
    }
    public string RelativeName
    {
        get { return _RelativeName; }
        set { _RelativeName = value; }
    }
    public string TypeOfRelation
    {
        get { return _TypeOfRelation; }
        set { _TypeOfRelation = value; }
    }
    public string RelativeAddress
    {
        get { return _RelativeAddress; }
        set { _RelativeAddress = value; }
    }
    public string RelativeContact
    {
        get { return _RelativeContact; }
        set { _RelativeContact = value; }
    }
    public string RelativeEmail
    {
        get { return _RelativeEmail; }
        set { _RelativeEmail = value; }
    }
    public string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
    }
    public int CentreID
    {
        get { return _CentreID; }
        set { _CentreID = value; }
    }
    public int HospCentreID
    {
        get { return _HospCentreID; }
        set { _HospCentreID = value; }
    }

    #endregion

    #region All Public Member Function
    public string Insert()
    {
        try
        {

            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Corpse_Master");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@vCorpse_ID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.Location;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.Patient_ID = Util.GetString(Patient_ID);
            this.Transaction_ID = Util.GetString(Transaction_ID);
            this.FirstName = Util.GetString(FirstName);
            this.LastName = Util.GetString(LastName);
            this.CName = Util.GetString(CName);
            this.Age = Util.GetString(Age);
            this.Gender = Util.GetString(Gender);
            this.DeathDate = Util.GetDateTime(DeathDate);
            this.DeathTime = Util.GetDateTime(DeathTime);
            this.DeathType = Util.GetString(DeathType);
            this.Nationality = Util.GetString(Nationality);
            this.Religion = Util.GetString(Religion);
            this.Locality = Util.GetString(Locality);
            this.Address = Util.GetString(Address);
            this.City = Util.GetString(City);
            this.Country = Util.GetString(Country);
            this.OtherAddress = Util.GetString(OtherAddress);
            this.Type = Util.GetString(Type);
            this.PlaceOfDeath = Util.GetString(PlaceOfDeath);
            this.HospitalName = Util.GetString(HospitalName);
            this.RelativeName = Util.GetString(RelativeName);
            this.TypeOfRelation = Util.GetString(TypeOfRelation);
            this.RelativeAddress = Util.GetString(RelativeAddress);
            this.RelativeContact = Util.GetString(RelativeContact);
            this.RelativeEmail = Util.GetString(RelativeEmail);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.CentreID = Util.GetInt(CentreID);
            this.HospCentreID = Util.GetInt(HospCentreID);
            this.PermitNo = Util.GetString(PermitNo);
            this.Mobile = Util.GetString(Mobile);
            this.NationalID = Util.GetString(NationalID);
            this.InfectiousRemark = Util.GetString(InfectiousRemark);


            cmd.Parameters.Add(new MySqlParameter("@vLoc", Location));
            cmd.Parameters.Add(new MySqlParameter("@vHosp", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@vPatient_ID", Patient_ID));
            cmd.Parameters.Add(new MySqlParameter("@vTransaction_ID", Transaction_ID));
            cmd.Parameters.Add(new MySqlParameter("@vFirstName", FirstName));
            cmd.Parameters.Add(new MySqlParameter("@vLastName", LastName));
            cmd.Parameters.Add(new MySqlParameter("@vCName", CName));
            cmd.Parameters.Add(new MySqlParameter("@vAge", Age));
            cmd.Parameters.Add(new MySqlParameter("@vGender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@vDeathDate", DeathDate));
            cmd.Parameters.Add(new MySqlParameter("@vDeathTime", DeathTime));
            cmd.Parameters.Add(new MySqlParameter("@vDeathType", DeathType));
            cmd.Parameters.Add(new MySqlParameter("@vNationality", Nationality));
            cmd.Parameters.Add(new MySqlParameter("@vReligion", Religion));
            cmd.Parameters.Add(new MySqlParameter("@vLocality", Locality));
            cmd.Parameters.Add(new MySqlParameter("@vAddress", Address));
            cmd.Parameters.Add(new MySqlParameter("@vCity", City));
            cmd.Parameters.Add(new MySqlParameter("@vCountry", Country));
            cmd.Parameters.Add(new MySqlParameter("@vOtherAddress", OtherAddress));
            cmd.Parameters.Add(new MySqlParameter("@vType", Type));
            cmd.Parameters.Add(new MySqlParameter("@vPlaceOfDeath", PlaceOfDeath));
            cmd.Parameters.Add(new MySqlParameter("@vHospitalName", HospitalName));
            cmd.Parameters.Add(new MySqlParameter("@vRelativeName", RelativeName));
            cmd.Parameters.Add(new MySqlParameter("@vTypeOfRelation", TypeOfRelation));
            cmd.Parameters.Add(new MySqlParameter("@vRelativeAddress", RelativeAddress));
            cmd.Parameters.Add(new MySqlParameter("@vRelativeContact", RelativeContact));
            cmd.Parameters.Add(new MySqlParameter("@vRelativeEmail", RelativeEmail));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospCentreID", HospCentreID));

            cmd.Parameters.Add(new MySqlParameter("@vPermitNo", PermitNo));
            cmd.Parameters.Add(new MySqlParameter("@vMobile", Mobile));
            cmd.Parameters.Add(new MySqlParameter("@vNationalID", NationalID));
            cmd.Parameters.Add(new MySqlParameter("@vInfectiousRemark", InfectiousRemark));
            cmd.Parameters.Add(paramTnxID);

            Corpse_ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Corpse_ID;
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

    //public int Update()
    //{
    //    try
    //    {
    //        int RowAffected;
    //        StringBuilder objSQL = new StringBuilder();
    //        objSQL.Append("UPDATE ipd_casetype_master SET Name = ?,Description=?, Creator_Id = ?, Creator_Date = ?,No_Of_Round=?,IsActive=? WHERE IPDCaseType_ID = ? ");

    //        if (IsLocalConn)
    //        {
    //            this.objCon.Open();
    //            this.objTrans = this.objCon.BeginTransaction();
    //        }
    //        this.Location = AllGlobalFunction.Location;
    //        this.HospCode = AllGlobalFunction.HospCode;

    //        this.Location = Util.GetString(Location);
    //        this.HospCode = Util.GetString(HospCode);
    //        this.IPDCaseType_ID = Util.GetString(IPDCaseType_ID);
    //        this.Name = Util.GetString(Name);
    //        this.Description = Util.GetString(Description);
    //        this.Ownership = Util.GetString(Ownership);
    //        this.Creator_Id = Util.GetString(Creator_Id);
    //        this.Creator_Date = Util.GetDateTime(Creator_Date);
    //        this.No_Of_Round = Util.GetInt(No_Of_Round);
    //        this.IsActive = Util.GetInt(IsActive);
    //        RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

    //            new MySqlParameter("@Name", Name),
    //            new MySqlParameter("@Description", Description),
    //            new MySqlParameter("@Creator_Id", Creator_Id),
    //            new MySqlParameter("@Creator_Date", Creator_Date),
    //            new MySqlParameter("@No_Of_Round", No_Of_Round),
    //            new MySqlParameter("@IsActive", IsActive),
    //            new MySqlParameter("@IPDCaseType_ID", IPDCaseType_ID));


    //        if (IsLocalConn)
    //        {
    //            this.objTrans.Commit();
    //            this.objCon.Close();
    //        }
    //        return RowAffected;

    //    }
    //    catch (Exception ex)
    //    {
    //        if (IsLocalConn)
    //        {
    //            if (objTrans != null) this.objTrans.Rollback();
    //            if (objCon.State == ConnectionState.Open) objCon.Close();
    //        }
    //        //Util.WriteLog(ex);
    //        throw (ex);
    //    }

    //}
    #endregion All Public Member Function
}