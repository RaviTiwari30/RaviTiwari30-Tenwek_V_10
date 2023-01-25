using System;
using System.Data;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for Research_master
/// </summary>
public class Research_master
{
    public Research_master()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public string SaveResearchmaster(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID,string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Insert_Research_master rm = new Insert_Research_master();
            rm.PatientID = Util.GetString(PatientID);
            rm.TransactionID = Util.GetString(TransactionID);
            rm.DoctorID = Util.GetString(DoctorID);
            rm.TotalScore = Util.GetString(TotalScore);
            rm.ResearchName = Util.GetString(ResearchName);
            rm.ResearchID = Util.GetInt(ResearchID);
            rm.CreatedBy = Util.GetString(CreatedBy);
            rm.Remarks = Util.GetString(Remarks);
            string ReferenceID = rm.Insert();

            // Insert patient_research_detail table
            Order = Order.TrimEnd('#');
            int len = Util.GetInt(Order.Split('#').Length);
            string[] Data = new string[len];
            Data = Order.Split('#');
            for (int i = 0; i < len; i++)
            {
                Insert_Research_Detail ird = new Insert_Research_Detail();
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
    public string SaveResearchmasterHOOS(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID, string Remarks)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Insert_Research_master rm = new Insert_Research_master();
            rm.PatientID = Util.GetString(PatientID);
            rm.TransactionID = Util.GetString(TransactionID);
            rm.DoctorID = Util.GetString(DoctorID);
            rm.TotalScore = Util.GetString(TotalScore);
            rm.ResearchName = Util.GetString(ResearchName);
            rm.ResearchID = Util.GetInt(ResearchID);
            rm.CreatedBy = Util.GetString(CreatedBy);
            rm.Remarks = Util.GetString(Remarks);
            string ReferenceID = rm.Insert();

            // Insert patient_research_detail table
            Order = Order.TrimEnd('#');
            int len = Util.GetInt(Order.Split('#').Length);
            string[] Data = new string[len];
            Data = Order.Split('#');
            for (int i = 0; i < len; i++)
            {
                Insert_Research_Detail ird = new Insert_Research_Detail();
                ird.ReferenceID = Util.GetInt(ReferenceID);
                ird.TransactionID = Util.GetString(TransactionID);
                ird.Questions = Util.GetString(Data[i].Split('|')[0]);
                ird.Answer = Util.GetString(Data[i].Split('|')[1]);
                ird.Score = Util.GetDecimal(Data[i].Split('|')[2]);
                ird.SubTotal = Util.GetString(Data[i].Split('|')[3]);
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
    public string SaveResearchmasterFoot(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Insert_Research_master rm = new Insert_Research_master();
            rm.PatientID = Util.GetString(PatientID);
            rm.TransactionID = Util.GetString(TransactionID);
            rm.DoctorID = Util.GetString(DoctorID);
            rm.TotalScore = Util.GetString(TotalScore);
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
                Insert_Research_Detail ird = new Insert_Research_Detail();
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

    public string SaveResearchmasterCervicalSpine(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Insert_Research_master rm = new Insert_Research_master();
            rm.PatientID = Util.GetString(PatientID);
            rm.TransactionID = Util.GetString(TransactionID);
            rm.DoctorID = Util.GetString(DoctorID);
            rm.TotalScore = Util.GetString(TotalScore) + "%";
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
                Insert_Research_Detail ird = new Insert_Research_Detail();
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

    public string ResearchMasterLumbar(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Insert_Research_master rm = new Insert_Research_master();
            rm.PatientID = Util.GetString(PatientID);
            rm.TransactionID = Util.GetString(TransactionID);
            rm.DoctorID = Util.GetString(DoctorID);
            rm.TotalScore = Util.GetString(TotalScore) + "%";
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
                Insert_Research_Detail ird = new Insert_Research_Detail();
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
    public string ResearchHandMichigan(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID, string TextScore)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Insert_Research_master rm = new Insert_Research_master();
            rm.PatientID = Util.GetString(PatientID);
            rm.TransactionID = Util.GetString(TransactionID);
            rm.DoctorID = Util.GetString(DoctorID);
            rm.TotalScore = Util.GetString(TotalScore) + "%";
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
                Insert_Research_Detail ird = new Insert_Research_Detail();
                ird.ReferenceID = Util.GetInt(ReferenceID);
                ird.TransactionID = Util.GetString(TransactionID);
                ird.Questions = Util.GetString(Data[i].Split('|')[0]);
                ird.Answer = Util.GetString(Data[i].Split('|')[1]);
                ird.Score = Util.GetDecimal(Data[i].Split('|')[2]);
                ird.CreatedBy = Util.GetString(CreatedBy);
                ird.Insert();

            }
            //Insert patient_research_detail_text table
            TextScore = TextScore.TrimEnd('#');
            int lenScore = Util.GetInt(TextScore.Split('#').Length);
            string[] DataScore = new string[lenScore];
            DataScore = TextScore.Split('#');
            for (int i = 0; i < lenScore; i++)
            {
                Insert_ResearchText_Detail irtd = new Insert_ResearchText_Detail();
                irtd.ReferenceID = Util.GetInt(ReferenceID);
                irtd.TransactionID = Util.GetString(TransactionID);
                irtd.ResearchID = Util.GetInt(ResearchID);
                irtd.TextName = Util.GetString(DataScore[i].Split('|')[0]);
                irtd.TextValue = Util.GetString(DataScore[i].Split('|')[1]) + "%";
                irtd.CreatedBy = Util.GetString(CreatedBy);
                irtd.Insert();
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
    public string SaveResearchVAS(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            Insert_Research_master rm = new Insert_Research_master();
            rm.PatientID = Util.GetString(PatientID);
            rm.TransactionID = Util.GetString(TransactionID);
            rm.DoctorID = Util.GetString(DoctorID);
            rm.TotalScore = Util.GetString(TotalScore);
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
                Insert_Research_Detail ird = new Insert_Research_Detail();
                ird.ReferenceID = Util.GetInt(ReferenceID);
                ird.TransactionID = Util.GetString(TransactionID);
                ird.Questions = Util.GetString(Data[i].Split('|')[0]);
                ird.Answer = Util.GetString(Data[i].Split('|')[1]);
                // ird.Score = Util.GetDecimal(Data[i].Split('|')[2]);
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
    public string SaveBergBalanceScale(string PatientID, string TransactionID, string DoctorID, string TotalScore, string ResearchName, string Order, string CreatedBy, string ResearchID)
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