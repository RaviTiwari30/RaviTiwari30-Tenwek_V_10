using System;
using System.Data;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for Research_master
/// </summary>
public class DoctorResearch_master
{
    public DoctorResearch_master()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public string SaveDoctorResearchmaster(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Insert_DoctorResearch_master rm = new Insert_DoctorResearch_master();
            rm.PatientID = Util.GetString(PatientID);
            rm.TransactionID = Util.GetString(TransactionID);
            rm.DoctorID = Util.GetString(DoctorID);
            rm.TotalScore = Util.GetDecimal(TotalScore);
            rm.ResearchName = Util.GetString(ResearchName);
            rm.ResearchID = Util.GetInt(ResearchID);
            rm.CreatedBy = Util.GetString(CreatedBy);
            string ReferenceID= rm.Insert();

            // Insert patient_research_detail table
            Order = Order.TrimEnd('#');           
            int len = Util.GetInt(Order.Split('#').Length);
            string[] Data = new string[len];
            Data = Order.Split('#');
            for (int i = 0; i < len; i++)
            {
                Insert_DoctorResearch_Detail ird = new Insert_DoctorResearch_Detail();
                ird.ReferenceID = Util.GetInt(ReferenceID);
                ird.TransactionID = Util.GetString(TransactionID); 
                ird.Questions=Util.GetString(Data[i].Split('|')[0]);
                ird.Answer=Util.GetString(Data[i].Split('|')[1]);
                ird.Score = Util.GetDecimal(Data[i].Split('|')[2]);
                ird.CreatedBy = Util.GetString(CreatedBy);
                ird.Insert();

            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();          
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    public string SaveDoctorResearchmasterKNEE1(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Insert_DoctorResearch_master rm = new Insert_DoctorResearch_master();
            rm.PatientID = Util.GetString(PatientID);
            rm.TransactionID = Util.GetString(TransactionID);
            rm.DoctorID = Util.GetString(DoctorID);
            rm.TotalScore = Util.GetDecimal(TotalScore);
            rm.ResearchName = Util.GetString(ResearchName);
            rm.ResearchID = Util.GetInt(ResearchID);
            rm.CreatedBy = Util.GetString(CreatedBy);
            string ReferenceID = rm.Insert();

            // Insert patient_research_detail table
            Order = Order.TrimEnd('#');
            int len = Util.GetInt(Order.Split('#').Length);
            string[] Data = new string[len];
            Data = Order.Split('#');
            for (int i = 0; i < len; i++)
            {
                Insert_DoctorResearch_Detail ird = new Insert_DoctorResearch_Detail();
                ird.ReferenceID = Util.GetInt(ReferenceID);
                ird.TransactionID = Util.GetString(TransactionID);
                ird.Questions = Util.GetString(Data[i].Split('|')[0]);
                ird.Answer = HttpUtility.HtmlDecode(Util.GetString(Data[i].Split('|')[1]));
                ird.Score = Util.GetDecimal(Data[i].Split('|')[2]);
                ird.CreatedBy = Util.GetString(CreatedBy);
                ird.Insert();

            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    public string SaveDoctorResearchmasterKNEE2(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Insert_DoctorResearch_master rm = new Insert_DoctorResearch_master();
            rm.PatientID = Util.GetString(PatientID);
            rm.TransactionID = Util.GetString(TransactionID);
            rm.DoctorID = Util.GetString(DoctorID);
            rm.TotalScore = Util.GetDecimal(TotalScore);
            rm.ResearchName = Util.GetString(ResearchName);
            rm.ResearchID = Util.GetInt(ResearchID);
            rm.CreatedBy = Util.GetString(CreatedBy);
            string ReferenceID = rm.Insert();

            // Insert patient_research_detail table
            Order = Order.TrimEnd('#');
            int len = Util.GetInt(Order.Split('#').Length);
            string[] Data = new string[len];
            Data = Order.Split('#');
            for (int i = 0; i < len; i++)
            {
                Insert_DoctorResearch_Detail ird = new Insert_DoctorResearch_Detail();
                ird.ReferenceID = Util.GetInt(ReferenceID);
                ird.TransactionID = Util.GetString(TransactionID);
                ird.Questions = Util.GetString(Data[i].Split('|')[0]);
                ird.Answer = Util.GetString(Data[i].Split('|')[1]);
                ird.Score = Util.GetDecimal(Data[i].Split('|')[2]);
                ird.CreatedBy = Util.GetString(CreatedBy);
                ird.Insert();

            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog ClLog = new ClassLog();
            ClLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

}