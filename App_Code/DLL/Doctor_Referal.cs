using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for doctor_referal
/// Generated using MySqlManager
/// ==========================================================================================
/// Author:
/// Create date:	4/20/2013 3:38:35 PM
/// Description:	This class is intended for inserting, updating, deleting values for doctor_referal table
/// ==========================================================================================
/// </summary>

public class doctor_referal
{
    public doctor_referal()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public doctor_referal(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #region All Memory Variables

    private string _Location;
    private string _HospCode;
    private int _ID;
    private string _DoctorID;
    private string _Title;
    private string _Name;
    private string _IMARegistartionNo;
    private string _RegistrationOf;
    private string _RegistrationYear;
    private string _ProfesionalSummary;
    private string _Designation;
    private string _Phone1;
    private string _Phone2;
    private string _Phone3;
    private string _Mobile;
    private string _House_No;
    private string _Street_Name;
    private string _Locality;
    private string _State;
    private string _City;
    private string _StateRegion;
    private string _CountryRegion;
    private string _Pincode;
    private string _Gender;
    private string _Email;
    private string _PorfilePageID;
    private string _Degree;
    private string _Specialization;
    private string _UserName;
    private string _Password;
    private string _DocDateTime;
    private int _IsVisible;
    private int _IsActive;
    private int _DocType;
    private string _CreatedBy;
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual string Location { get { return _Location; } set { _Location = value; } }
    public virtual string HospCode { get { return _HospCode; } set { _HospCode = value; } }
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string DoctorID { get { return _DoctorID; } set { _DoctorID = value; } }
    public virtual string Title { get { return _Title; } set { _Title = value; } }
    public virtual string Name { get { return _Name; } set { _Name = value; } }
    public virtual string IMARegistartionNo { get { return _IMARegistartionNo; } set { _IMARegistartionNo = value; } }
    public virtual string RegistrationOf { get { return _RegistrationOf; } set { _RegistrationOf = value; } }
    public virtual string RegistrationYear { get { return _RegistrationYear; } set { _RegistrationYear = value; } }
    public virtual string ProfesionalSummary { get { return _ProfesionalSummary; } set { _ProfesionalSummary = value; } }
    public virtual string Designation { get { return _Designation; } set { _Designation = value; } }
    public virtual string Phone1 { get { return _Phone1; } set { _Phone1 = value; } }
    public virtual string Phone2 { get { return _Phone2; } set { _Phone2 = value; } }
    public virtual string Phone3 { get { return _Phone3; } set { _Phone3 = value; } }
    public virtual string Mobile { get { return _Mobile; } set { _Mobile = value; } }
    public virtual string House_No { get { return _House_No; } set { _House_No = value; } }
    public virtual string Street_Name { get { return _Street_Name; } set { _Street_Name = value; } }
    public virtual string Locality { get { return _Locality; } set { _Locality = value; } }
    public virtual string State { get { return _State; } set { _State = value; } }
    public virtual string City { get { return _City; } set { _City = value; } }
    public virtual string StateRegion { get { return _StateRegion; } set { _StateRegion = value; } }
    public virtual string CountryRegion { get { return _CountryRegion; } set { _CountryRegion = value; } }
    public virtual string Pincode { get { return _Pincode; } set { _Pincode = value; } }
    public virtual string Gender { get { return _Gender; } set { _Gender = value; } }
    public virtual string Email { get { return _Email; } set { _Email = value; } }
    public virtual string PorfilePageID { get { return _PorfilePageID; } set { _PorfilePageID = value; } }
    public virtual string Degree { get { return _Degree; } set { _Degree = value; } }
    public virtual string Specialization { get { return _Specialization; } set { _Specialization = value; } }
    public virtual string UserName { get { return _UserName; } set { _UserName = value; } }
    public virtual string Password { get { return _Password; } set { _Password = value; } }
    public virtual string DocDateTime { get { return _DocDateTime; } set { _DocDateTime = value; } }
    public virtual int IsVisible { get { return _IsVisible; } set { _IsVisible = value; } }
    public virtual int IsActive { get { return _IsActive; } set { _IsActive = value; } }
    public virtual int DocType { get { return _DocType; } set { _DocType = value; } }
    public virtual string CreatedBy { get { return _CreatedBy; } set { _CreatedBy = value; } }
    #endregion

    #region All Public Member Function
    public string Insert()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("doctor_referal_insert");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vHospCode", Util.GetString(HospCode)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@vTitle", Util.GetString(Title)));
            cmd.Parameters.Add(new MySqlParameter("@vName", Util.GetString(Name)));
            cmd.Parameters.Add(new MySqlParameter("@vIMARegistartionNo", Util.GetString(IMARegistartionNo)));
            cmd.Parameters.Add(new MySqlParameter("@vRegistrationOf", Util.GetString(RegistrationOf)));
            cmd.Parameters.Add(new MySqlParameter("@vRegistrationYear", Util.GetString(RegistrationYear)));
            cmd.Parameters.Add(new MySqlParameter("@vProfesionalSummary", Util.GetString(ProfesionalSummary)));
            cmd.Parameters.Add(new MySqlParameter("@vDesignation", Util.GetString(Designation)));
            cmd.Parameters.Add(new MySqlParameter("@vPhone1", Util.GetString(Phone1)));
            cmd.Parameters.Add(new MySqlParameter("@vPhone2", Util.GetString(Phone2)));
            cmd.Parameters.Add(new MySqlParameter("@vPhone3", Util.GetString(Phone3)));
            cmd.Parameters.Add(new MySqlParameter("@vMobile", Util.GetString(Mobile)));
            cmd.Parameters.Add(new MySqlParameter("@vHouse_No", Util.GetString(House_No)));
            cmd.Parameters.Add(new MySqlParameter("@vStreet_Name", Util.GetString(Street_Name)));
            cmd.Parameters.Add(new MySqlParameter("@vLocality", Util.GetString(Locality)));
            cmd.Parameters.Add(new MySqlParameter("@vState", Util.GetString(State)));
            cmd.Parameters.Add(new MySqlParameter("@vCity", Util.GetString(City)));
            cmd.Parameters.Add(new MySqlParameter("@vStateRegion", Util.GetString(StateRegion)));
            cmd.Parameters.Add(new MySqlParameter("@vCountryRegion", Util.GetString(CountryRegion)));
            cmd.Parameters.Add(new MySqlParameter("@vPincode", Util.GetString(Pincode)));
            cmd.Parameters.Add(new MySqlParameter("@vGender", Util.GetString(Gender)));
            cmd.Parameters.Add(new MySqlParameter("@vEmail", Util.GetString(Email)));
            cmd.Parameters.Add(new MySqlParameter("@vPorfilePageID", Util.GetString(PorfilePageID)));
            cmd.Parameters.Add(new MySqlParameter("@vDegree", Util.GetString(Degree)));
            cmd.Parameters.Add(new MySqlParameter("@vSpecialization", Util.GetString(Specialization)));
            cmd.Parameters.Add(new MySqlParameter("@vUserName", Util.GetString(UserName)));
            cmd.Parameters.Add(new MySqlParameter("@vPassword", Util.GetString(Password)));
            cmd.Parameters.Add(new MySqlParameter("@vDocDateTime", Util.GetString(DocDateTime)));
            cmd.Parameters.Add(new MySqlParameter("@vIsVisible", Util.GetInt(IsVisible)));
            cmd.Parameters.Add(new MySqlParameter("@vIsActive", 1));
            cmd.Parameters.Add(new MySqlParameter("@vDocType", Util.GetInt(DocType)));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", Util.GetString(CreatedBy)));

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

            objSQL.Append("doctor_referal_update");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vLocation", Util.GetString(Location)));
            cmd.Parameters.Add(new MySqlParameter("@vHospCode", Util.GetString(HospCode)));
            cmd.Parameters.Add(new MySqlParameter("@vID", Util.GetInt(ID)));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", Util.GetString(DoctorID)));
            cmd.Parameters.Add(new MySqlParameter("@vTitle", Util.GetString(Title)));
            cmd.Parameters.Add(new MySqlParameter("@vName", Util.GetString(Name)));
            cmd.Parameters.Add(new MySqlParameter("@vIMARegistartionNo", Util.GetString(IMARegistartionNo)));
            cmd.Parameters.Add(new MySqlParameter("@vRegistrationOf", Util.GetString(RegistrationOf)));
            cmd.Parameters.Add(new MySqlParameter("@vRegistrationYear", Util.GetString(RegistrationYear)));
            cmd.Parameters.Add(new MySqlParameter("@vProfesionalSummary", Util.GetString(ProfesionalSummary)));
            cmd.Parameters.Add(new MySqlParameter("@vDesignation", Util.GetString(Designation)));
            cmd.Parameters.Add(new MySqlParameter("@vPhone1", Util.GetString(Phone1)));
            cmd.Parameters.Add(new MySqlParameter("@vPhone2", Util.GetString(Phone2)));
            cmd.Parameters.Add(new MySqlParameter("@vPhone3", Util.GetString(Phone3)));
            cmd.Parameters.Add(new MySqlParameter("@vMobile", Util.GetString(Mobile)));
            cmd.Parameters.Add(new MySqlParameter("@vHouse_No", Util.GetString(House_No)));
            cmd.Parameters.Add(new MySqlParameter("@vStreet_Name", Util.GetString(Street_Name)));
            cmd.Parameters.Add(new MySqlParameter("@vLocality", Util.GetString(Locality)));
            cmd.Parameters.Add(new MySqlParameter("@vState", Util.GetString(State)));
            cmd.Parameters.Add(new MySqlParameter("@vCity", Util.GetString(City)));
            cmd.Parameters.Add(new MySqlParameter("@vStateRegion", Util.GetString(StateRegion)));
            cmd.Parameters.Add(new MySqlParameter("@vCountryRegion", Util.GetString(CountryRegion)));
            cmd.Parameters.Add(new MySqlParameter("@vPincode", Util.GetString(Pincode)));
            cmd.Parameters.Add(new MySqlParameter("@vGender", Util.GetString(Gender)));
            cmd.Parameters.Add(new MySqlParameter("@vEmail", Util.GetString(Email)));
            cmd.Parameters.Add(new MySqlParameter("@vPorfilePageID", Util.GetString(PorfilePageID)));
            cmd.Parameters.Add(new MySqlParameter("@vDegree", Util.GetString(Degree)));
            cmd.Parameters.Add(new MySqlParameter("@vSpecialization", Util.GetString(Specialization)));
            cmd.Parameters.Add(new MySqlParameter("@vUserName", Util.GetString(UserName)));
            cmd.Parameters.Add(new MySqlParameter("@vPassword", Util.GetString(Password)));
            cmd.Parameters.Add(new MySqlParameter("@vDocDateTime", Util.GetString(DocDateTime)));
            cmd.Parameters.Add(new MySqlParameter("@vIsVisible", Util.GetInt(IsVisible)));
            cmd.Parameters.Add(new MySqlParameter("@vIsActive", Util.GetInt(IsActive)));
            cmd.Parameters.Add(new MySqlParameter("@vDocType", Util.GetInt(DocType)));

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


    public string Delete()
    {
        string Output = "";
        try
        {
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("doctor_referal_delete");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vID", ID));

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