#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces

/// <summary>
/// Summary description for patient_profile_doctor
/// </summary>
public class patient_profile_doctor
{
    #region All Memory Variables

    private string _DoctorID;
    private string _PatientID;
    private string _Comunitty;


    #endregion

    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public patient_profile_doctor()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        //this.Location=AllGlobalFunction.Location;
        //this.HospCode = AllGlobalFunction.HospCode;
    }
    public patient_profile_doctor(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
    #region Set All Property
    public virtual string DoctorID
    {

        get
        {
            return _DoctorID;
        }
        set
        {
            _DoctorID = value;
        }
    }

    public virtual string PatientID
    {
        get
        {
            return _PatientID;
        }
        set
        {
            _PatientID = value;
        }
    }
    public virtual string Comunitty
    {
        get
        {
            return _Comunitty;
        }
        set
        {
            _Comunitty = value;
        }
    }

  #endregion


    #region All Public Member Function
    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("INSERT INTO patient_profile_doctor(DoctorID,PatientID,Comunitty)");
            objSQL.Append("VALUES (@DoctorID,@PatientID,@Comunitty)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.DoctorID = Util.GetString(DoctorID);
            this.PatientID = Util.GetString(PatientID);
            this.Comunitty = Util.GetString(Comunitty);




            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

               new MySqlParameter("@DoctorID", DoctorID),
               new MySqlParameter("@PatientID", PatientID),
               new MySqlParameter("@Comunitty", Comunitty));




            iPkValue = Util.GetInt(MySqlHelper.ExecuteScalar(objTrans, CommandType.Text, "select @@identity as AutoKey"));

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;
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

    //created update/delete/load function  by sonika  dt 3 oct 2007
    public int Update()
    {
        try
        {
            this.DoctorID = Util.GetString(DoctorID);
            this.PatientID = Util.GetString(PatientID);
            this.Comunitty = Util.GetString(Comunitty);

            int RowAffected;
            StringBuilder objSQL = new StringBuilder();



            objSQL.Append("UPDATE patient_profile_doctore SET DoctorID=?, ");
            objSQL.Append("Comunitty = ? WHERE PatientID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
           

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),


              
                  new MySqlParameter("@DoctorID", DoctorID),
                  new MySqlParameter("@PatientID",PatientID),
                  new MySqlParameter("@Comunitty", Comunitty));


            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return RowAffected;

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            //Util.WriteLog(ex);
            throw (ex);
        }

    }

    public int Update(string PatientID)
    {
        this.DoctorID = Util.GetString(PatientID);
        return this.Update();
    }

    public int Delete(string PatientID)
    {
        this.DoctorID = Util.GetString(PatientID);
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM patient_profile_doctor WHERE PatientID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("PatientID", PatientID));
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return iRetValue;
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

    public bool Load()
    {
        DataTable dtTemp;

        try
        {

            string sSQL = "SELECT * FROM patient_profile_doctor WHERE PatientID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@PatientID", PatientID)).Tables[0];

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            if (dtTemp.Rows.Count > 0)
            {
                this.SetProperties(dtTemp);
                return true;
            }
            else
                return false;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

            // Util.WriteLog(ex);
            string sParams = "PatientID=" + this.PatientID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }

    }

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
    public bool Load(string PatientID)
    {
        this.PatientID = Util.GetString(PatientID);
        return this.Load();
    }

    #endregion All Public Member Function
  



    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        //DoctorID,PatientID,Comunitty

        this.DoctorID = Util.GetString(dtTemp.Rows[0][AllTables.patient_profile_doctor.DoctorID]);
        this.PatientID = Util.GetString(dtTemp.Rows[0][AllTables.patient_profile_doctor.PatientID]);
        this.Comunitty = Util.GetString(dtTemp.Rows[0][AllTables.patient_profile_doctor.Comunitty]);

    }
    #endregion
}



	

