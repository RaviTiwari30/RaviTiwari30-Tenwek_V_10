using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;

public class ExcuteCMD
{

    public dynamic DML(MySqlTransaction tnx, MySqlConnection con, string sqlCmd, CommandType commandType, object inParameters = null, object outParameters = null)
    {
        try
        {
            MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(sqlCmd.ToString(), tnx.Connection, tnx);
            cmd.CommandType = commandType;
            createCmdParameters(cmd, inParameters, outParameters);

            dynamic response = null;
            if (outParameters != null)
                response = cmd.ExecuteScalar();
            else
                response = cmd.ExecuteNonQuery();

            return response;
        }
        catch (Exception ex)
        {
            string s = this.GetRowQuery(sqlCmd, inParameters);
            throw (ex);
        }

    }
    public dynamic DML(MySqlTransaction tnx, string sqlCmd, CommandType commandType, object inParameters = null, object outParameters = null)
    {
        try
        {
            MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(sqlCmd.ToString(), tnx.Connection, tnx);
            cmd.CommandType = commandType;
            createCmdParameters(cmd, inParameters, outParameters);
            dynamic response = null;
            if (outParameters != null)
                response = cmd.ExecuteScalar();
            else
                response = cmd.ExecuteNonQuery();

            return response;
        }
        catch (Exception ex)
        {
            string s = this.GetRowQuery(sqlCmd, inParameters);
            throw (ex);
        }

    }
    public dynamic DML(string sqlCmd, CommandType commandType, object inParameters = null, object outParameters = null)
    {
        MySqlConnection conn;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();

        try
        {
            MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(sqlCmd, conn);
            cmd.CommandType = CommandType.Text;
            createCmdParameters(cmd, inParameters, null);

            dynamic response = null;
            response = cmd.ExecuteNonQuery();
            
            return response;
        }
        catch (Exception ex)
        {
            string s = this.GetRowQuery(sqlCmd, inParameters);
            throw (ex);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
                conn.Close();
            if (conn != null)
            {
                conn.Dispose();
                conn = null;
            }
        }

    }

    public dynamic ExecuteScalar(string sqlCmd, object inParameters)
    {
        MySqlConnection conn;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();
			
		dynamic response = null;
        try
        {
            MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(sqlCmd, conn);
            cmd.CommandType = CommandType.Text;
            createCmdParameters(cmd, inParameters, null);


            response = cmd.ExecuteScalar();
            
        }
        catch { }
        finally {
            if (conn.State == ConnectionState.Open)
                conn.Close();
            if (conn != null)
            {
                conn.Dispose();
                conn = null;
            }
        }
		return response;
    }



    public dynamic ExecuteScalar(MySqlConnection con, string sqlCmd, object inParameters)
    {

        MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(sqlCmd, con);
        cmd.CommandType = CommandType.Text;
        createCmdParameters(cmd, inParameters, null);

        dynamic response = null;
        response = cmd.ExecuteScalar();
        return response;
    }

    public dynamic ExecuteScalar(MySqlTransaction tnx, string sqlCmd, CommandType commandType, object inParameters = null, object outParameters = null)
    {
        try
        {
            MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(sqlCmd.ToString(), tnx.Connection, tnx);
            cmd.CommandType = commandType;
            createCmdParameters(cmd, inParameters, outParameters);
            return cmd.ExecuteScalar();
        }
        catch (Exception ex)
        {
            string s = this.GetRowQuery(sqlCmd, inParameters);
            throw (ex);
        }

    }


    private void createCmdParameters(MySqlCommand cmd, object inParameters, object outParameters)
    {
        if (inParameters != null)
        {
            foreach (var prop in inParameters.GetType().GetProperties(System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public))
            {
                cmd.Parameters.Add(new MySqlParameter("@" + prop.Name, prop.GetValue(inParameters, null)));
            }
        }

        if (outParameters != null)
        {
            MySqlParameter outParameter = new MySqlParameter();
            outParameter.ParameterName = "@ID";
            outParameter.MySqlDbType = MySqlDbType.VarChar;
            outParameter.Size = 50;
            outParameter.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(outParameter);
        }


    }

    private void createCmdOutParameters(MySqlCommand cmd, object outParameters)
    {
        if (outParameters != null)
        {
            MySqlParameter outParameter = new MySqlParameter();
            outParameter.ParameterName = "@ID";
            outParameter.MySqlDbType = MySqlDbType.VarChar;
            outParameter.Size = 50;
            outParameter.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(outParameter);
        }

    }

    public DataTable GetDataTable(string sqlCmd, CommandType commandType, object inParameters = null)
    {
        MySqlConnection conn;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();
        try
        {
            MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(sqlCmd.ToString(), conn);
            cmd.CommandType = commandType;
            createCmdParameters(cmd, inParameters, null);
            MySqlDataAdapter da = new MySqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds.Tables[0];
        }
        catch (Exception ex)
        {
            string s = this.GetRowQuery(sqlCmd, inParameters);
            throw (ex);
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
                conn.Close();
            if (conn != null)
                conn.Dispose();
            conn = null;
        }
    }



    public DataTable GetDataTable(MySqlTransaction tnx, string sqlCmd, CommandType commandType, object inParameters = null)
    {
        MySqlConnection conn;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();
        try
        {
            MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(sqlCmd.ToString(), conn, tnx);
            cmd.CommandType = commandType;
            createCmdParameters(cmd, inParameters, null);
            MySqlDataAdapter da = new MySqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds.Tables[0];
        }
        catch (Exception ex)
        {
            string s = this.GetRowQuery(sqlCmd, inParameters);
            throw (ex);
        }
        finally {
            if (conn.State == ConnectionState.Open)
                conn.Close();
            if (conn != null)
                conn.Dispose();
            conn = null;
        }
    }




    public string GetRowQuery(string sqlCmd, object inParameters = null)
    {
        var _temp = sqlCmd;
        foreach (var prop in inParameters.GetType().GetProperties(System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public))
        {
            var v = prop.GetValue(inParameters, null);

            bool isInt = Microsoft.VisualBasic.Information.IsNumeric(v);
            string val = "'" + v + "'";

            _temp = _temp.Replace("@" + prop.Name, (isInt ? v.ToString() : val));
        }
        return _temp;
    }


}