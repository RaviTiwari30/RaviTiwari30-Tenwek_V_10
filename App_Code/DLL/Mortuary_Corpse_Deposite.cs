using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Text;
using System.Data;

/// <summary>
/// Summary description for Mortuary_Corpse_Deposite
/// </summary>
public class Mortuary_Corpse_Deposite
{
    #region All Memory Variables

    private int _ID;
    private string _Location;
    private string _HospCode;
    private string _Transaction_ID;
    private string _CorpseID;    
    private string _DoctorID;    
    private string _Remarks;    
    private string _AuthDoctor;
    private string _FreezerID;
    private string _CreatedBy;
    private int _Panel_ID;
    private string _BroughtBy;
    private string _BroughtFrom;
    private int _CentreID;    
    private int _HospCentreID;
    
    #endregion

    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public Mortuary_Corpse_Deposite()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public Mortuary_Corpse_Deposite(MySqlTransaction objTrans)
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

    public string Transaction_ID
    {
        get { return _Transaction_ID; }
        set { _Transaction_ID = value; }
    }

    public string CorpseID
    {
        get { return _CorpseID; }
        set { _CorpseID = value; }
    }
    public string DoctorID
    {
        get { return _DoctorID; }
        set { _DoctorID = value; }
    }
    public string Remarks
    {
        get { return _Remarks; }
        set { _Remarks = value; }
    }
    public string AuthDoctor
    {
        get { return _AuthDoctor; }
        set { _AuthDoctor = value; }
    }
    public string FreezerID
    {
        get { return _FreezerID; }
        set { _FreezerID = value; }
    }
    public string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
    }


    public int Panel_ID
    {
        get { return _Panel_ID; }
        set { _Panel_ID = value; }
    }

    public string BroughtBy
    {
        get { return _BroughtBy; }
        set { _BroughtBy = value; }
    }
    public string BroughtFrom
    {
        get { return _BroughtFrom; }
        set { _BroughtFrom = value; }
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
            objSQL.Append("Insert_Corpse_Deposite");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@vTransaction_ID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;

            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.Location = AllGlobalFunction.LocationCorpse;
            this.HospCode = AllGlobalFunction.HospCode;

            this.Location = Util.GetString(Location);
            this.HospCode = Util.GetString(HospCode);
            this.CorpseID = Util.GetString(CorpseID);
            this.DoctorID = Util.GetString(DoctorID);
            this.Remarks = Util.GetString(Remarks);
            this.AuthDoctor = Util.GetString(AuthDoctor);
            this.FreezerID = Util.GetString(FreezerID);
            this.Panel_ID = Util.GetInt(Panel_ID);
            this.BroughtBy = Util.GetString(BroughtBy);
            this.BroughtFrom = Util.GetString(BroughtFrom);
            this.CreatedBy = Util.GetString(CreatedBy);
            this.CentreID = Util.GetInt(CentreID);
            this.HospCentreID = Util.GetInt(HospCentreID);

            cmd.Parameters.Add(new MySqlParameter("@vLocation", Location));
            cmd.Parameters.Add(new MySqlParameter("@vHospCode", HospCode));
            cmd.Parameters.Add(new MySqlParameter("@vCorpseID", CorpseID));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@vAuthDoctor", AuthDoctor));
            cmd.Parameters.Add(new MySqlParameter("@vBroughtBy", BroughtBy));
            cmd.Parameters.Add(new MySqlParameter("@vBroughtFrom", BroughtFrom));
            cmd.Parameters.Add(new MySqlParameter("@vFreezerID", FreezerID));
            cmd.Parameters.Add(new MySqlParameter("@vPanel_ID", Panel_ID));
            cmd.Parameters.Add(new MySqlParameter("@vCreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vHospCentreID", HospCentreID));
            cmd.Parameters.Add(paramTnxID);

            Transaction_ID = Util.GetString(cmd.ExecuteScalar().ToString());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Transaction_ID;
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