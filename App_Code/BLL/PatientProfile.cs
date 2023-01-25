using System;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for PatientProfile
/// </summary>
public class PatientProfile
{
	public PatientProfile()
	{
		
	}

    /// <summary>
    /// Save Doctors in patient profile list
    /// </summary>

    public double getBalanceAmount(string PatientID)
    {

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {
            MySqlCommand cmd = new MySqlCommand();
            cmd.CommandText = "";
            cmd.Connection = conn;
            double Amount = Util.GetDouble(cmd.ExecuteScalar());
            cmd.Dispose();
            conn.Close();
            conn.Dispose();
            return Amount;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            conn.Close();
            conn.Dispose();
            return 0;

        }
    }

    public double getBalanceAmount(string PatientID, DateTime ReceiptDateTime)
    {

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {
            MySqlCommand cmd = new MySqlCommand();
            cmd.CommandText = "";
            cmd.Connection = conn;
            double Amount = Util.GetDouble(cmd.ExecuteScalar());
            cmd.Dispose();
            conn.Close();
            conn.Dispose();
            return Amount;
        }
        catch (Exception ex)
        {
            conn.Close();
            conn.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;

        }
    }

    public double getBalanceAmount(string PatientID, string LedgerTransactionNO)
    {

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {

            MySqlCommand cmd2 = new MySqlCommand();
            string sql = "";
            MySqlCommand cmd = new MySqlCommand();
            cmd.CommandText = sql;
            cmd.Connection = conn;
            double Amount = Util.GetDouble(cmd.ExecuteScalar());
            cmd.Dispose();
            conn.Close();
            conn.Dispose();
            return Amount;
        }
        catch (Exception ex)
        {
            conn.Close();
            conn.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;

        }
    }
    public string showBalanceAmount(string PatientID)
    {

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {
            string msg = "";
            MySqlCommand cmd = new MySqlCommand();
            cmd.CommandText = ""; 
            cmd.Connection = conn;
            double Amount = Util.GetDouble(cmd.ExecuteScalar());
            cmd.Dispose();
            conn.Close();
            conn.Dispose();
            if (Amount > 0)
            {
                msg = "Advance Amount " + Amount + " As on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mmtt");
            }
            else if (Amount < 0)
            {
                msg = "Pending Amount " + Amount + " As on " + DateTime.Now.ToString("dd-MMM-yyyy HH:mmtt");
            }
            else if (Amount == 0)
            {
                msg = "";
            }
            return msg;
        }
        catch (Exception ex)
        {
            conn.Close();
            conn.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;

        }
    }
   
}
