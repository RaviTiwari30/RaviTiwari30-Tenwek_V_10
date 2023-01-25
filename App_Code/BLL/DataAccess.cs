using System.Data;

using MySql.Data.MySqlClient;

/// <summary>
/// Helper Class for Stock Related Data
/// </summary>
public class DataAccess
{

    public DataAccess()
	{
		//
		// TODO: Add constructor logic here
		//


        
	}
 

    #region GetDataTable
    public static DataTable GetDataTable(string strQuery)
    {
        
        MySqlConnection conn;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();
        DataTable dt = new DataTable();
        dt = MySqlHelper.ExecuteDataset(conn, CommandType.Text, strQuery).Tables[0];
        if (conn.State == ConnectionState.Open)
            conn.Close();
        if (conn != null)
        {
            conn.Dispose();
            conn = null;
        }
        return dt;
    }

    public static DataTable GetDataTableProc(string ProcedureName, MySqlParameter[] parm)
    {
        MySqlConnection conn = Util.GetMySqlCon();
        MySqlCommand cmd = new MySqlCommand(ProcedureName,conn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddRange(parm);
        MySqlDataAdapter da = new MySqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        try
        {
            da.Fill(dt);

        }
        finally
        {
            conn.Close();
            conn.Dispose();
            cmd.Parameters.Clear();
            cmd.Dispose();
            da.Dispose();
        }
        return dt;

    }


    #endregion

    #region ExecuteDML
    public static bool ExecuteDML(string strQuery)
    {
        MySqlConnection conn;
        
        MySqlTransaction tnx; 
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
        {
            conn.Open();
        }
        tnx = conn.BeginTransaction();

        int result = MySqlHelper.ExecuteNonQuery(tnx,CommandType.Text,strQuery);

        if (result > 0)
        {
            tnx.Commit();
            tnx.Dispose();

            if (conn.State == ConnectionState.Open)
            {   conn.Close();
                conn.Dispose();             
            }
            return true;
        }
        else
        {
            tnx.Rollback();
            tnx.Dispose();

            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }
            return false;
        }
    }

    public static bool ExecuteDMLProc(string ProcedureName, MySqlParameter[] parm)
    {
        MySqlConnection conn = Util.GetMySqlCon();
        MySqlCommand cmd = new MySqlCommand(ProcedureName, conn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddRange(parm);
        int Result = 0;
        try
        {
            conn.Open();
            Result = cmd.ExecuteNonQuery();

        }
        finally
        {
            conn.Close();
            conn.Dispose();
            cmd.Parameters.Clear();
            cmd.Dispose();

        }
        if (Result > 0)
        {
            return true;
        }
        else
        {
            return false;
        }


    }

    #endregion

    #region ExecuteScalar

    public static string ExecuteScalar(string strQuery)
    {
        MySqlConnection conn;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();

        string Result = Util.GetString(MySqlHelper.ExecuteScalar(conn, CommandType.Text, strQuery));
        if (conn.State == ConnectionState.Open)
            conn.Close();
        if (conn != null)
        {
            conn.Dispose();
            conn = null;
        }
        return Result;

    }

    public static string ExecuteScalarProc(string ProcedureName,MySqlParameter[] parm)
    {
        MySqlConnection conn=Util.GetMySqlCon();
        MySqlCommand cmd = new MySqlCommand(ProcedureName, conn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddRange(parm);
        string Result = string.Empty;
        try
        {
            conn.Open();
            Result = Util.GetString(cmd.ExecuteScalar());

        }
        finally
        {
            conn.Close();
            conn.Dispose();
            cmd.Parameters.Clear();
            cmd.Dispose();

        }
        return Result;
        

    }


    #endregion
}
