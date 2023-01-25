using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Package_DoctorVistiDetail
/// </summary>
public class Package_DoctorVistiDetail
{
    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Package_DoctorVistiDetail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Package_DoctorVistiDetail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public string PackageID { get; set; }
    public string SubCategoryID { get; set; }
    public string DocDepartmentID { get; set; }
    public string DoctorID { get; set; }

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO Package_DoctorVistiDetail(PackageID,SubCategoryID,DocDepartmentID,DoctorID) Values (@PackageID,@SubCategoryID,@DocDepartmentID,@DoctorID)");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
            new MySqlParameter("@PackageID", PackageID),
            new MySqlParameter("@SubCategoryID", SubCategoryID),
            new MySqlParameter("@DocDepartmentID", DocDepartmentID),
            new MySqlParameter("@DoctorID", DoctorID));

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

    #endregion All Public Member Function
}