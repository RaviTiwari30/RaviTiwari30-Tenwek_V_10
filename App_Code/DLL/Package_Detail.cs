using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;

public class Package_Detail
{
    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public Package_Detail()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public Package_Detail(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public string PackageID { get; set; }
    public string InvestigationID { get; set; }
    public string ItemID { get; set; }
    public int Quantity { get; set; }

    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("INSERT INTO package_detail(PackageID,InvestigationID,ItemID,Quantity,UserID,DateModified,IpAddress) Values (@PackageID,@InvestigationID,@ItemID,@Quantity,@UserID,@DateModified,@IpAddress)");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
            new MySqlParameter("@PackageID", PackageID),
            new MySqlParameter("@InvestigationID", Util.GetInt(InvestigationID)),
            new MySqlParameter("@ItemID", ItemID),
            new MySqlParameter("@Quantity", Quantity),
            new MySqlParameter("@UserID", HttpContext.Current.Session["ID"].ToString()),
            new MySqlParameter("@DateModified", DateTime.Now),
            new MySqlParameter("@IpAddress", HttpContext.Current.Request.UserHostAddress));

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
