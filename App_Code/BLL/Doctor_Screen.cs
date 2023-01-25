using System;
using System.Media;
using System.Collections;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Text;

/// <summary>
/// Summary description for Doctor_Screen
/// </summary>
public class Doctor_Screen
{
    public Doctor_Screen()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public string UpdateCall(string App_ID, string DoctorID)
    {
        string Query = "";
        int a = 0;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {            
            int NoOfCall = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(P_Out)NoOfCall FROM appointment WHERE DATE=CURRENT_DATE() AND IsCall=1 AND P_Out=0 and DoctorID='" + DoctorID + "'"));
            if (NoOfCall >= 2)
            {
                Tnx.Commit();
                con.Close();
                con.Dispose();
                return "0";
            }
            else
            {
                int callNo = 1 + Util.GetInt(StockReports.ExecuteScalar("SELECT MAX(IFNULL(CallNo,0))CallNo FROM Appointment WHERE DATE=CURRENT_DATE() and DoctorID='" + DoctorID + "'"));
                Query = "Update Appointment set CallNo=" + callNo + ", IsCall=1, CallTime=NOW(),Hold=0,Onbell=1 where App_ID='" + App_ID + "'";
                a = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Query);
                Tnx.Commit();
                con.Close();
                con.Dispose();
                return "1";
            }
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }
    }

    public string UpdateUncall(string App_ID)
    {
        string Query = "";
        int a = 0;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Query = "Update Appointment set CallNo=0,P_In=0, IsCall=0, CallTime=NOW() where App_ID='" + App_ID + "'";
            a = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Query);
            Tnx.Commit();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }
    }

    public string Hold(string App_ID)
    {
        string Query = "";
        int a = 0;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            Query = "Update Appointment set Hold=1  where App_ID='" + App_ID + "'";
            a = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Query);
            Tnx.Commit();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }
    }

    public string UpdateIn(string App_ID, string DoctorID)
    {
        string Query = "";
        int a = 0;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int chk_In = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from appointment where Date=CURRENT_DATE() and P_IN=1 and P_Out=0 and DoctorID='" + DoctorID + "'"));
            if (chk_In > 0)
            {
                Tnx.Commit();
                con.Close();
                con.Dispose();
                return "0";
            }
            else
            {
                int callChk = Util.GetInt(StockReports.ExecuteScalar("Select IsCall from appointment where App_ID='" + App_ID + "'"));
                if (callChk == 1)
                {
                    Query = "Update Appointment set P_In=1,InTime=NOW() where App_ID='" + App_ID + "'";
                    a = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Query);
                    Tnx.Commit();
                    con.Close();
                    con.Dispose();                   
                    return "1";
                }
                else
                {
                    Tnx.Commit();
                    con.Close();
                    con.Dispose();
                    return "0";
                }
            }
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }
    }

    public string UpdateOut(string App_ID, string DoctorID)
    {
        string Query = "";
        int a = 0;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int In_Chk = Util.GetInt(StockReports.ExecuteScalar("Select P_IN from appointment where App_ID='" + App_ID + "'"));
            if (In_Chk == 1)
            {
                Query = "Update Appointment set P_Out=1, OutTime=NOW() where App_ID='" + App_ID + "'";
                a = MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, Query);

                Tnx.Commit();
                con.Close();
                con.Dispose();
                return "1";
            }
            else
            {
                Tnx.Commit();
                con.Close();
                con.Dispose();
                return "0";
            }
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }
    }
    public DataTable LoadDoctor(string date)
    {
        string Query = "";
        Query = "SELECT dm.Name DocName,dm.DoctorID DocID FROM doctor_master dm INNER JOIN appointment app ON app.DoctorID=dm.DoctorID WHERE app.Date='" + date + "'";
        DataTable dtDocList = StockReports.GetDataTable(Query);
        return dtDocList;
    }
    public DataTable LoadPatient(string Date, string DocID)
    {
        string Query = "";
        Query = " SELECT pm.PatientID MRNO,app.AppNo AppNo FROM patient_master pm INNER JOIN appointment app ON app.PatientID=pm.PatientID WHERE app.date='" + Date + "' and app.DoctorID='" + DocID + "'";
        DataTable dtDocList = StockReports.GetDataTable(Query);
        return dtDocList;
    }
}
