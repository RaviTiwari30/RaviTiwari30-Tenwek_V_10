#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces



public class patient_profile_hospital
{
    #region All Memory Variables

    private string _Hospital_ID;
    private string _PatientID;
    


    #endregion

    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public patient_profile_hospital()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
        //this.Location=AllGlobalFunction.Location;
        //this.HospCode = AllGlobalFunction.HospCode;
    }
    public patient_profile_hospital(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion
    #region Set All Property
    public virtual string Hospital_ID
    {

        get
        {
            return _Hospital_ID;
        }
        set
        {
            _Hospital_ID = value;
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
   

    #endregion
    #region All Public Member Function
    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();

            objSQL.Append("INSERT INTO patient_profile_hospital(Hospital_ID,PatientID)");
            objSQL.Append("VALUES (@Hospital_ID,@PatientID)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.PatientID = Util.GetString(PatientID);

            




            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Hospital_ID",Hospital_ID),
                new MySqlParameter("@PatientID",PatientID));
               




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

    //created update/delete/load function by Sonika dt 3 oct 2007

    public int Update()
    {
        try
        {
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.PatientID = Util.GetString(PatientID);
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();



            objSQL.Append("UPDATE patient_profile_hospital SET Hospital_ID = ?WHERE PatientID = ? ");
            
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),


               
                  new MySqlParameter("@Hospital_ID", Hospital_ID),
                  new MySqlParameter("@PatientID", PatientID));
               


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
        this.PatientID = Util.GetString(PatientID);
        return this.Update();
    }

    public int Delete(string PatientID)
    {
        this.PatientID = Util.GetString(PatientID);
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM patient_profile_hospital WHERE PatientID = ?");

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

            string sSQL = "SELECT * FROM patient_profile_hospital WHERE PatientID = ?";

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
        //Hospital_ID,PatientID

        this.Hospital_ID = Util.GetString(dtTemp.Rows[0][AllTables.patient_profile_hospital.Hospital_ID]);
        this.PatientID = Util.GetString(dtTemp.Rows[0][AllTables.patient_profile_hospital.PatientID]);

        

    }
    #endregion

  



}
