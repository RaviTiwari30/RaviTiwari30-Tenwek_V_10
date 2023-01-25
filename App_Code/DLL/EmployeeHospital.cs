#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces


public class EmployeeHospital
{
	
    #region All Memory Variables

    private int     _EmployeeHospital_ID;
    private string  _EmployeeID;
    private string  _Hospital_ID;
    private string _Designation;
    private int _CentreID;
    
    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public EmployeeHospital()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public EmployeeHospital(MySqlTransaction objTrans)
    {

        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property
    public virtual int EmployeeHospital_ID
    {
        get
        {
            return _EmployeeHospital_ID;
        }
        set
        {
            _EmployeeHospital_ID = value;
        }
    }
    public virtual string EmployeeID
    {
        get
        {
            return _EmployeeID;
        }
        set
        {
            _EmployeeID = value;
        }
    }
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

    public virtual string Designation
    {
        get
        {
            return _Designation;
        }
        set
        {
            _Designation = value;
        }
    }
    public virtual int CentreID
    {
        get
        {
            return _CentreID;
        }
        set
        {
            _CentreID = value;
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
            objSQL.Append("INSERT INTO employee_hospital (EmployeeHospital_ID,EmployeeID,Hospital_ID,Designation,CentreID)");
            objSQL.Append("VALUES (@EmployeeHospital_ID,@EmployeeID,@Hospital_ID,@Designation,@CentreID)");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.EmployeeHospital_ID    = Util.GetInt(EmployeeHospital_ID);
            this.EmployeeID            = Util.GetString(EmployeeID);
            this.Hospital_ID            = Util.GetString(Hospital_ID);
            this.Designation            = Util.GetString(Designation);
            this.CentreID = Util.GetInt(CentreID);
            

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@EmployeeHospital_ID", EmployeeHospital_ID),
                new MySqlParameter("@EmployeeID", EmployeeID),
                new MySqlParameter("@Hospital_ID", Hospital_ID),
                new MySqlParameter("@Designation", Designation),
                 new MySqlParameter("@CentreID", CentreID));
                

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
            throw (ex);
        }

    }

    public bool Load()
    {
        DataTable dtTemp;

        try
        {

            string sSQL = "SELECT * FROM employee_hospital WHERE EmployeeHospital_ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@EmployeeHospital_ID", EmployeeHospital_ID)).Tables[0];

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
            string sParams = "EmployeeHospital_ID=" + this.EmployeeHospital_ID.ToString();
            // Util.WriteLog(sParams);
            throw (ex);
        }

    }

    /// <summary>
    /// Loads the specified i pk value.
    /// </summary>
    /// <param name="iPkValue">The i pk value.</param>
    /// <returns></returns>
    public bool Load(int iPkValue)
    {
        this.EmployeeHospital_ID = iPkValue;
        return this.Load();
    }

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE employee_hospital SET EmployeeID = ?, Hospital_ID = ?,");
            objSQL.Append("Designation = ? WHERE EmployeeHospital_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            
            this.EmployeeID = Util.GetString(EmployeeID);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.Designation = Util.GetString(Designation);
            this.EmployeeHospital_ID = Util.GetInt(EmployeeHospital_ID);

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("EmployeeID", EmployeeID),
                new MySqlParameter("Hospital_ID",        Hospital_ID),
                new MySqlParameter("Designation", Designation),
                new MySqlParameter("EmployeeHospital_ID",  EmployeeHospital_ID));
                
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

    public int Delete(int iPkValue)
    {
        this.EmployeeHospital_ID = iPkValue;
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM employee_hospital WHERE EmployeeHospital_ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("EmployeeHospital_ID", EmployeeHospital_ID));
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

    #endregion All Public Member Function

    #region Helper Private Function
    private void SetProperties(DataTable dtTemp)
    {
        this.EmployeeHospital_ID    = Util.GetInt(dtTemp.Rows[0][AllTables.Employee_Hospital.EmployeeHospital_ID]);
        this.EmployeeID            = Util.GetString(dtTemp.Rows[0][AllTables.Employee_Hospital.EmployeeID]);
        this.Hospital_ID            = Util.GetString(dtTemp.Rows[0][AllTables.Employee_Hospital.Hospital_ID]);
        this.Designation            = Util.GetString(dtTemp.Rows[0][AllTables.Employee_Hospital.Designation]);
        
    }
    #endregion
}
