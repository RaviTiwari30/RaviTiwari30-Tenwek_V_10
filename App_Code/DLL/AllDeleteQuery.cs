using System.Data;
using MySql.Data.MySqlClient;

public class AllDeleteQuery
{

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Overloaded Constructor
    public AllDeleteQuery()
    {

        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;

    }
    public AllDeleteQuery(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion
   
    /// <returns></returns>
    public int Deleteopd(int OPD_ID)
    {
            string sql = "DELETE FROM doctor_hospital WHERE OPD_ID = " + OPD_ID + "";

            if (IsLocalConn)
            {
                this.objCon.Open();               
                Util.GetInt(MySqlHelper.ExecuteNonQuery(objCon, CommandType.Text, sql));

                this.objCon.Close();

                return 1;

            }
            else
            {
                Util.GetInt(MySqlHelper.ExecuteNonQuery(this.objTrans, CommandType.Text, sql));
                return 1;
            }

        }
    
   
}
