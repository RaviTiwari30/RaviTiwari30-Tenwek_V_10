using System;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for SalesEntry
/// </summary>
public class SalesEntry
{
    public SalesEntry()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static string genBillNo(MySqlTransaction tranx, int CentreID, MySqlConnection con)
    {
        string BillNo = "";
        try
        {
            string objSQL = "f_Generate_Bill_No";
            
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@_Bill_No";
            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con, tranx);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
            cmd.Parameters.Add(paramTnxID);
            BillNo = cmd.ExecuteScalar().ToString();

            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "INSERT INTO f_Billgenerated(BillNo)VALUES('" + BillNo + "')");
            
        }
        catch (Exception ex)
        { BillNo = "";
            
        }
        return BillNo;
    }
    public static string getPanelInvoiceNo(MySqlTransaction tranx, int CentreID, MySqlConnection con)
    {
        string BillNo="";
        try
        {
            MySqlParameter LedTxnID = new MySqlParameter();
            LedTxnID.ParameterName = "@_Bill_No";
            LedTxnID.MySqlDbType = MySqlDbType.VarChar;
            LedTxnID.Size = 50;
            LedTxnID.Direction = ParameterDirection.Output;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("f_Generate_Bill_No_PanelInvoice");
            MySqlCommand cmd;
            cmd = new MySqlCommand(objSQL.ToString(), con, tranx);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
            cmd.Parameters.Add(LedTxnID);
            BillNo= cmd.ExecuteScalar().ToString();

          
        }
        catch (Exception ex)
        { BillNo = ""; }

        return BillNo;

    }


    public static string getBillNoIPD(int CentreID, MySqlTransaction tranx, MySqlConnection con)
    {
        try
        {
            MySqlParameter LedTxnID = new MySqlParameter();
            LedTxnID.ParameterName = "@Bill_No";
            LedTxnID.MySqlDbType = MySqlDbType.VarChar;
            LedTxnID.Size = 50;
            LedTxnID.Direction = ParameterDirection.Output;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("f_Generate_Bill_No_IPD");
            MySqlCommand cmd;
            cmd = new MySqlCommand(objSQL.ToString(), con, tranx);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
            cmd.Parameters.Add(LedTxnID);
            return cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static string genBillNoBloodBank(MySqlTransaction tranx, int CentreID, MySqlConnection con)
    {
        string objSQL = "f_Generate_Bill_No_BloodBank";
        MySqlParameter paramTnxID = new MySqlParameter();
        paramTnxID.ParameterName = "@Bill_No";
        paramTnxID.MySqlDbType = MySqlDbType.VarChar;
        paramTnxID.Size = 50;
        paramTnxID.Direction = ParameterDirection.Output;
        MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con, tranx);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
        cmd.Parameters.Add(paramTnxID);
        return cmd.ExecuteScalar().ToString();
    }
    public static string genBillNo_opd(MySqlTransaction tranx, int CentreID, MySqlConnection con)
    {
        string BillNo = "";
      
            string objSQL = "f_Generate_Bill_No_OPD";

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@_Bill_No";
            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 50;
            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con, tranx);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", Util.GetInt(CentreID)));
            cmd.Parameters.Add(paramTnxID);
            BillNo = cmd.ExecuteScalar().ToString();
            // MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "INSERT INTO f_Billgenerated(BillNo)VALUES('" + BillNo + "')");



      
        return BillNo;
    }

}
