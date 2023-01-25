#region All Namespaces

using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

#endregion All Namespaces

public class Patient_Lab_Radiology_IPD
{
    #region All Memory Variables

    private int _ID;
    private string _Investigation_ID;
    private string _Test_ID;
    private DateTime _Result_Date;
    private DateTime _Result_Time;
    private string _Template_Desc;
    private int _Round_No;

    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Patient_Lab_Radiology_IPD()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Patient_Lab_Radiology_IPD(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual int ID
    {
        get
        {
            return _ID;
        }
        set
        {
            _ID = value;
        }
    }

    public virtual string Investigation_ID
    {
        get
        {
            return _Investigation_ID;
        }
        set
        {
            _Investigation_ID = value;
        }
    }

    public virtual string Test_ID
    {
        get
        {
            return _Test_ID;
        }
        set
        {
            _Test_ID = value;
        }
    }

    public virtual DateTime Result_Date
    {
        get
        {
            return _Result_Date;
        }
        set
        {
            _Result_Date = value;
        }
    }

    public virtual DateTime Result_Time
    {
        get
        {
            return _Result_Time;
        }
        set
        {
            _Result_Time = value;
        }
    }

    public virtual string Template_Desc
    {
        get
        {
            return _Template_Desc;
        }
        set
        {
            _Template_Desc = value;
        }
    }

    public virtual int Round_No
    {
        get
        {
            return _Round_No;
        }
        set
        {
            _Round_No = value;
        }
    }

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO patient_labRadiology_ipd(Investigation_ID,Test_ID, Result_Date, Result_Time, Template_Desc,Round_No )");
            objSQL.Append("VALUES (@Investigation_ID, @Test_ID, @Result_Date, @Result_Time, @Template_Desc,@Round_No)");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            this.Investigation_ID = Util.GetString(Investigation_ID);
            this.Test_ID = Util.GetString(Test_ID);
            this.Result_Date = Util.GetDateTime(Result_Date);
            this.Result_Time = Util.GetDateTime(Result_Time);
            this.Template_Desc = Util.GetString(Template_Desc);
            this.Round_No = Util.GetInt(Round_No);

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Investigation_ID", Investigation_ID),
                new MySqlParameter("@Test_ID", Test_ID),
                new MySqlParameter("@Result_Date", Result_Date),
                new MySqlParameter("@Result_Time", Result_Time),
                new MySqlParameter("@Template_Desc", Template_Desc),
                new MySqlParameter("@Round_No", Round_No));

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

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE patient_labRadiology_ipd SET  Investigation_ID= ?, Result_Date=?, Result_Time=?, Template_Desc = ?,Test_ID=?, Round_No=? WHERE ID = ? ");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("@Investigation_ID", Investigation_ID),
                new MySqlParameter("@Result_Date", Result_Date),
                new MySqlParameter("@Result_Time", Result_Time),
                new MySqlParameter("@Template_Desc", Template_Desc),
                new MySqlParameter("@Test_ID", Test_ID),
                new MySqlParameter("@Round_No", Round_No));

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
        this.ID = iPkValue;
        return this.Delete();
    }

    public int Delete()
    {
        try
        {
            int iRetValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("DELETE FROM patient_labRadiology_ipd WHERE ID = ?");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            iRetValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),

                new MySqlParameter("ID", ID));
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
            string sSQL = "SELECT * FROM patient_labRadiology_ipd WHERE ID = ?";

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            dtTemp = MySqlHelper.ExecuteDataset(objTrans, CommandType.Text, sSQL, new MySqlParameter("@ID", ID)).Tables[0];

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
            string sParams = "ID=" + this.ID.ToString();
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
        this.ID = iPkValue;
        return this.Load();
    }

    #endregion All Public Member Function

    #region Helper Private Function

    private void SetProperties(DataTable dtTemp)
    {
        this.Investigation_ID = Util.GetString(dtTemp.Rows[0][AllTables.patient_labRadiology_ipd.Investigation_ID]);
        this.Result_Date = Util.GetDateTime(dtTemp.Rows[0][AllTables.patient_labRadiology_ipd.Result_Date]);
        this.Result_Time = Util.GetDateTime(dtTemp.Rows[0][AllTables.patient_labRadiology_ipd.Result_Time]);
        this.Template_Desc = Util.GetString(dtTemp.Rows[0][AllTables.patient_labRadiology_ipd.Template_Desc]);
        this.Test_ID = Util.GetString(dtTemp.Rows[0][AllTables.patient_labRadiology_ipd.Test_ID]);
        this.Round_No = Util.GetInt(dtTemp.Rows[0][AllTables.patient_labRadiology_ipd.Round_No]);
    }

    #endregion Helper Private Function
}