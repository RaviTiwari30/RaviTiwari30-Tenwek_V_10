using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for GetEncounterNo
/// </summary>
public class GetEncounterNo
{

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    public GetEncounterNo()
    {

        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;



    }


    public int FindCategoryId(string ItemId)
    {
        try
        {
            string EncounterNo = "";

            if (IsLocalConn)
            {
                this.objCon.Open();
                StringBuilder sql = new StringBuilder();
                sql.Append(" SELECT cm.CategoryID FROM f_itemmaster im ");
                sql.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubcategoryID ");
                sql.Append(" INNER JOIN  f_categorymaster cm ON cm.CategoryID=sm.CategoryID ");
                sql.Append(" INNER JOIN  f_categorymaster cm ON cm.CategoryID=sm.CategoryID ");
                sql.Append(" WHERE im.ItemID='" + ItemId + "' ");

                EncounterNo = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql.ToString()));
                this.objCon.Close();

                return Util.GetInt(EncounterNo);

            }
            return Util.GetInt(EncounterNo); ;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }

    }



    public int FindEncounterNo(string PatientId)
    {
        try
        {
            string EncounterNo = "";

            string sql = "call GetEncounterNo('" + PatientId + "')";
            if (IsLocalConn)
            {
                this.objCon.Open();
                EncounterNo = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, sql));
                this.objCon.Close();

                if (EncounterNo == "0" || string.IsNullOrEmpty(EncounterNo))
                {
                    string GenrateEncounter = "call GenerateEncounterNo('" + PatientId + "')";
                    this.objCon.Open();
                    EncounterNo = Util.GetString(MySqlHelper.ExecuteScalar(objCon, CommandType.Text, GenrateEncounter));
                    this.objCon.Close();

                }
                else
                {
                    return Util.GetInt(EncounterNo);
                }

            }
            return Util.GetInt(EncounterNo); ;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }



    public string FindEncounterNoInCaseOfConsultatioin(string PatientId, MySqlTransaction tranx, MySqlConnection con)
    {
        try
        {
            string EncounterNo = "";

            string sql = "call GetEncounterNo('" + PatientId + "')";

            EncounterNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sql));

            if (EncounterNo == "0" || string.IsNullOrEmpty(EncounterNo))
            {
                string objSQL = "GenerateEncounterNo";
                MySqlParameter paramTnxID = new MySqlParameter();
                MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), con, tranx);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new MySqlParameter("@UHID", Util.GetInt(PatientId)));
                cmd.Parameters.Add(paramTnxID);
                EncounterNo = cmd.ExecuteScalar().ToString();

                //string GenrateEncounter = "call GenerateEncounterNo('" + PatientId + "')";

                // Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, GenrateEncounter));


            }
            else
            {
                return Util.GetString("Close");
            }


            return Util.GetString(EncounterNo); ;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    public decimal getEncounterLimit(string PatientId, string PanelId, int Encounter, MySqlTransaction tranx, MySqlConnection con)
    {
        string Date = MySqlHelper.ExecuteScalar(tranx, CommandType.Text, "SELECT DATE(pe.DateTime)EncounterDate FROM patient_encounter pe WHERE pe.EncounterNo=" + Util.GetInt(Encounter) + "").ToString();
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT *  FROM patient_encounter pe ");
        sb.Append("  WHERE pe.PatientID='" + PatientId + "' AND date(pe.DateTime)='" + Util.GetDateTime(Date).ToString("yyyy-MM-dd") + "' ");
        DataTable dt = MySqlHelper.ExecuteDataset(tranx, CommandType.Text, sb.ToString()).Tables[0];
        int count = dt.Rows.Count;

        if (count == 1)
        {

            if (Util.GetInt(dt.Rows[0]["EncounterNo"].ToString()) == Util.GetInt(Encounter))
            {

                decimal PanelAmount = Util.GetDecimal(StockReports.ExecuteScalar("SELECT fpm.PanelAmountLimit FROM f_panel_master fpm WHERE fpm.PanelID='" + PanelId + "'"));

                if (PanelAmount >= Util.GetDecimal(dt.Rows[0]["EncounterAmount"].ToString()))
                {
                    return (PanelAmount - Util.GetDecimal(dt.Rows[0]["EncounterAmount"].ToString()));
                }
                else
                {
                    if ((PanelAmount - Util.GetDecimal(dt.Rows[0]["EncounterAmount"].ToString())) > 0)
                    {
                        return (PanelAmount - Util.GetDecimal(dt.Rows[0]["EncounterAmount"].ToString()));
                    }
                    else
                    {
                        return 0;
                    }

                }


            }
            else
            {
                return 0;
            }


        }
        else
        {
            return 0;
        }

    }

    public int UpdateEncounterLimit(string PatientId, int EncounterNo, decimal Amount, MySqlTransaction tranx, MySqlConnection con)
    {



        try
        {

            ExcuteCMD excuteCMD = new ExcuteCMD();

            StringBuilder sb = new StringBuilder();

            sb.Append("UPDATE patient_encounter ");
            sb.Append(" set EncounterAmount=EncounterAmount+@Amount,LastAmountEnterDate=Now()  ");
            sb.Append("  where EncounterNo=@EncounterNo and PatientID=@PatientID  ");


            int a = excuteCMD.DML(tranx, sb.ToString(), CommandType.Text, new
              {
                  Amount = Util.GetDecimal(Amount),
                  EncounterNo = Util.GetInt(EncounterNo),
                  PatientID = Util.GetString(PatientId)
              });


            return 1;
        }
        catch (Exception ex)
        {
            return 0;

        }


    }



    public bool IsLimitOnAmountInPanel(string PanelId)
    {
        decimal PanelAmount = Util.GetDecimal(StockReports.ExecuteScalar("SELECT fpm.PanelAmountLimit FROM f_panel_master fpm WHERE fpm.PanelID='" + PanelId + "'"));
        if (PanelAmount > 0)
        {
            return true;
        }
        else
        {
            return false;
        }

    }


    public bool IsApprovalAmountExit(string PanelId, string PatientId, DateTime dt)
    {
        int IsExit = Util.GetInt(StockReports.ExecuteScalar("SELECT IF(COUNT(pd.ID)=0,0,1)IsExit FROM paneldetails pd WHERE pd.IsActive=1 AND  pd.PanelID='" + PanelId + "' AND pd.PatientID='" + PatientId + "'  AND  ( '" + Util.GetDateTime(dt).ToString("yyyy-MM-dd HH:mm:ss") + "' BETWEEN pd.FromValid AND pd.ToValid)"));
        if (IsExit > 0)
        {
            return true;
        }
        else
        {
            return false;
        }

    }

    public int IsUsingSmartCard(string PatientID, string PanelId, int SessionId)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM  paneldetails pd  WHERE pd.PatientID='" + PatientID + "' AND pd.PanelID='" + PanelId + "' AND pd.SessionId=" + SessionId + " AND pd.IsActive=1");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            return 1;
        }
        else
        {
            return 0;
        }

    }

    public int IsPanelWithSmartCard(string PanelId)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM f_Panel_master pm WHERE pm.PanelID='" + PanelId + "' AND pm.IsSmartCard=1");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            return 1;
        }
        else
        {
            return 0;
        }

    }
    public int IsPanelWithIsManual(string PanelId)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM f_Panel_master pm WHERE pm.PanelID='" + PanelId + "' AND pm.IsManual=1");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            return 1;
        }
        else
        {
            return 0;
        }

    }
 

    public decimal getApprovalAmountLimit(string PatientId, string PanelId, int PoolNr, DateTime dt)
    {
        int IsSmartCard = 0;
        int SessionId = Util.GetInt(StockReports.ExecuteScalar(" SELECT pd.sessionId FROM paneldetails pd WHERE pd.PatientId='" + PatientId + "' AND Pd.PanelID='" + PanelId + "' ORDER BY id DESC LIMIT 1   "));
        int EncounterNo = Util.GetInt(StockReports.ExecuteScalar("  SELECT   pe.EncounterNo FROM patient_encounter pe  WHERE pe.SessionId='" + SessionId + "' order by pe.id Desc limit 1   "));

        if (SessionId != 0)
        {
            IsSmartCard = IsUsingSmartCard(PatientId, PanelId, SessionId);
        }



        StringBuilder sbpd = new StringBuilder();
        sbpd.Append(" SELECT * FROM paneldetails pd ");
        sbpd.Append(" WHERE pd.IsActive=1 AND  pd.PanelID='" + PanelId + "' AND pd.PatientID='" + PatientId + "' ");
        if (IsSmartCard != 0)
        {
            sbpd.Append(" and  pd.SessionId=" + SessionId + " ");
        }

        sbpd.Append("  AND  ( '" + Util.GetDateTime(dt).ToString("yyyy-MM-dd HH:mm:ss") + "' BETWEEN pd.FromValid AND pd.ToValid)  ");

        DataTable dtpd = StockReports.GetDataTable(sbpd.ToString());
        if (dtpd != null && dtpd.Rows.Count > 0)
        {


            StringBuilder sbpds = new StringBuilder();
            sbpds.Append(" SELECT * FROM paneldetails_description pd ");
            sbpds.Append(" WHERE pd.PanelDetailsId='" + dtpd.Rows[0]["ID"].ToString() + "' AND  pd.pool_nr='" + PoolNr + "' ");
            DataTable dtpds = StockReports.GetDataTable(sbpds.ToString());

            if (dtpds.Rows.Count > 0 && dtpds != null)
            {

                StringBuilder sbamt = new StringBuilder();
                sbamt.Append(" SELECT ROUND(SUM(ltd.Amount),2)Amt FROM  panel_amountallocation ltd ");
                sbamt.Append(" INNER JOIN f_ledgertransaction lt ON lt.TransactionID=ltd.TransactionID ");
                sbamt.Append(" WHERE  lt.PanelID='" + PanelId + "' and lt.PoolNr=" + PoolNr + " AND lt.PatientID='" + PatientId + "' ");
                if (IsSmartCard != 0)
                {
                    sbpd.Append(" and  lt.EncounterNo=" + EncounterNo + " ");
                }

                sbamt.Append(" AND date(ltd.EntryOn) BETWEEN '" + Util.GetDateTime(dtpd.Rows[0]["FromValid"].ToString()).ToString("yyyy-MM-dd") + "' AND '" + Util.GetDateTime(dtpd.Rows[0]["ToValid"].ToString()).ToString("yyyy-MM-dd") + "' ");

                decimal SpendAmount = Util.GetDecimal(StockReports.ExecuteScalar(sbamt.ToString()));

                if (Util.GetDecimal(dtpds.Rows[0]["amount"].ToString()) >= SpendAmount)
                {
                    return (Util.GetDecimal(dtpds.Rows[0]["amount"].ToString()) - SpendAmount);
                }
                else
                {
                    if ((Util.GetDecimal(dtpds.Rows[0]["amount"].ToString()) - SpendAmount) > 0)
                    {
                        return (Util.GetDecimal(dtpds.Rows[0]["amount"].ToString()) - SpendAmount);
                    }
                    else
                    {
                        return 0;
                    }

                }

            }
            else
            {
                return 0;
            }

        }
        else
        {
            return 0;
        }




    }



    public int UpdateApprovalAmt(string PanelId, string PatientId, decimal Amount, DateTime dt, MySqlTransaction tranx, MySqlConnection con)
    {



        try
        {

            ExcuteCMD excuteCMD = new ExcuteCMD();

            StringBuilder sb = new StringBuilder();

            sb.Append("UPDATE paneldetails ");
            sb.Append(" set TotalBillAmount=TotalBillAmount+@Amount ");
            sb.Append("  where PanelID=@PanelId and PatientID=@PatientID and IsActive=1 AND ( @Date BETWEEN  FromValid AND  ToValid)  ");

            int a = excuteCMD.DML(tranx, sb.ToString(), CommandType.Text, new
            {
                Amount = Util.GetDecimal(Amount),
                PanelId = Util.GetString(PanelId),
                PatientID = Util.GetString(PatientId),
                Date = Util.GetDateTime(dt).ToString("yyyy-MM-dd HH:mm:ss")
            });


            return 1;
        }
        catch (Exception ex)
        {
            return 0;

        }


    }




    public int GetSessionId(string PatientId)
    {

        try
        {
            string recivedata = "";
            CardTokenResponseModel tokenResponse = AuthenticationHelper.GetBearerToken();

            using (var client = CardClientHelper.GetClient(tokenResponse.AccessToken))
            {

                client.BaseAddress = new Uri(CardBasicData.BaseUrl);
                try
                {
                    string urldat = "api/member?patientNumber=" + PatientId + "";
                    HttpResponseMessage Res = client.GetAsync(urldat).GetAwaiter().GetResult();

                    string status_code = Res.StatusCode.ToString();
                    //Checking the response is successful or not which is sent using HttpClient  
                    if (Res.IsSuccessStatusCode)
                    {
                        recivedata = Res.Content.ReadAsStringAsync().Result;
                        var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        GetMenberDetails FetchDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(Seralizedata), typeof(GetMenberDetails));

                        return FetchDat.content[0].session_id;
                    }
                    else
                    {
                        return 0;
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return 0;
                }

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }


    }



    public int CheckDualityOfPanelRequest(string PanelID, string TransactionId)
    {
        int A = IsPanelWithSmartCard(PanelID);
        if (A == 1)
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT * FROM  panelapproval_emaildetails pe WHERE pe.PanelID='" + PanelID + "' AND pe.TransactionID='" + TransactionId + "'");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                return 1;
            }
            else
            {
                return 0;
            }


        }
        else
        {


            return 0;

        }

    }

    public int IsUsingSmartCardIpd(string PanelID, string TransactionId)
    {
        int A = IsPanelWithSmartCard(PanelID);
        if (A == 1)
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT * FROM  panelapproval_emaildetails pe WHERE pe.PanelID='" + PanelID + "' AND pe.TransactionID='" + TransactionId + "' and IsThroughsmartCard=1 ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                return 1;
            }
            else
            {
                return 0;
            }


        }
        else
        {


            return 0;

        }

    }


    public int IsMergerOrAllocated(string PanelID, string TransactionId)
    {
        int A = IsPanelWithSmartCard(PanelID);
        if (A == 1)
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT * FROM  panel_amountallocation pe WHERE pe.PanelID='" + PanelID + "' AND pe.TransactionID='" + TransactionId + "' and IsMerge=1 ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                return 1;
            }
            else
            {
                return 0;
            }


        }
        else
        {


            return 0;

        }

    }




    public int PanelAmountAllocationAndMergeSessionId(string PanelId, string TransactionId,string PatientId, double Amount, string EntryBy, string EntryType, MySqlTransaction tranx)
    {



        try
        {

            ExcuteCMD excuteCMD = new ExcuteCMD();
            CardTokenResponseModel tokenResponse = AuthenticationHelper.GetBearerToken();

            using (var client = CardClientHelper.GetClient(tokenResponse.AccessToken))
            {
                string recivedata = "";

                client.BaseAddress = new Uri(CardBasicData.BaseUrl);
                try
                {
                    string Status = "PENDING";
                    string urldata = "api/visit?patientNumber=" + PatientId + "&sessionStatus=" + Status + "";
                    HttpResponseMessage Ress = client.GetAsync(urldata).GetAwaiter().GetResult();

                    //Checking the response is successful or not which is sent using HttpClient  
                    if (Ress.IsSuccessStatusCode)
                    {
                        string recived = Ress.Content.ReadAsStringAsync().Result;
                        var Visitdata = Newtonsoft.Json.JsonConvert.DeserializeObject(recived);
                        object SeralizeVisitdata = Newtonsoft.Json.JsonConvert.DeserializeObject(recived);

                        GetMenberDetails FetchVisitDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(SeralizeVisitdata), typeof(GetMenberDetails));
                        if (FetchVisitDat != null && FetchVisitDat.content.Count > 0)
                        {


                            try
                            {

                                string urldat = "api/member?patientNumber=" + PatientId + "&sessionId=" + FetchVisitDat.content[0].session_id + "";

                                HttpResponseMessage Res = client.GetAsync(urldat).GetAwaiter().GetResult();

                    string status_code = Res.StatusCode.ToString();
                    //Checking the response is successful or not which is sent using HttpClient  
                    if (Res.IsSuccessStatusCode)
                    {
                        recivedata = Res.Content.ReadAsStringAsync().Result;
                        var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        GetMenberDetails FetchDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(Seralizedata), typeof(GetMenberDetails));


                        if (FetchDat.content.Count != 0)
                        {


                            using (var clientMSId = CardClientHelper.GetClient(tokenResponse.AccessToken))
                            {

                                clientMSId.BaseAddress = new Uri(CardBasicData.BaseUrl);
                                try
                                {
                                    System.Net.Http.HttpContent requestContent = new System.Net.Http.StringContent("", Encoding.UTF8, "application/x-www-form-urlencoded");
                                    string urldatMSID = "api/patient-number/" + PatientId + "/visit-number/" + GetIpdNoByTransactionId(TransactionId) + "";
                                    HttpResponseMessage ResMSID = client.PutAsync(urldatMSID, requestContent).GetAwaiter().GetResult();

                                    recivedata = ResMSID.Content.ReadAsStringAsync().Result;
                                    var dataMSID = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                                    //Checking the response is successful or not which is sent using HttpClient  
                                    if (ResMSID.IsSuccessStatusCode)
                                    {


                                        StringBuilder sb = new StringBuilder();
                                        sb.Append(" INSERT INTO panel_amountallocation (PanelID,TransactionID,Amount,EntryBy,EntryType, ");
                                        sb.Append(" SessionId,IsMerge, ");
                                        sb.Append(" medicalaid_code,medicalaid_name,policy_id, ");
                                        sb.Append(" medicalaid_scheme_code,medicalaid_scheme_name, ");

                                        sb.Append(" medicalaid_number,member_name,global_id,card_serial_number, ");
                                        sb.Append(" medicalaid_plan,medicalaid_regdate,medicalaid_expiry, ");
                                        sb.Append(" policy_country,policy_currency,Sp_id,IpdNo)  ");
                                        sb.Append("VALUES (" + Util.GetInt(PanelId) + ",'" +TransactionId + "'," +  Amount+ ",'" +EntryBy + "','"+EntryType+"', ");
                                        sb.Append("" + Util.GetInt( FetchDat.content[0].session_id) + ",1, ");
                                        sb.Append(" '" + FetchDat.content[0].medicalaid_code + "', '" + FetchDat.content[0].medicalaid_name + "','" + FetchDat.content[0].policy_id + "', ");
                                        sb.Append("'" + FetchDat.content[0].medicalaid_scheme_code + "','" + FetchDat.content[0].medicalaid_scheme_name + "', ");

                                        sb.Append(" '" + FetchDat.content[0].medicalaid_number + "', '" + FetchDat.content[0].member_name + "','" + FetchDat.content[0].global_id + "','" + FetchDat.content[0].card_serial_number + "', ");

                                        sb.Append(" '" + FetchDat.content[0].medicalaid_plan + "', '" + Util.GetDateTime(FetchDat.content[0].medicalaid_regdate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(FetchDat.content[0].medicalaid_expiry).ToString("yyyy-MM-dd") + "', ");

                                        sb.Append(" '" + FetchDat.content[0].policy_country + "', '" + FetchDat.content[0].policy_currency + "'," + Util.GetInt(FetchDat.content[0].benefits[0].exchange_location.sp_id) + " ");

                                        sb.Append(",'" + GetIpdNoByTransactionId(TransactionId) + "' )");

                                        MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());

                                        return 1;
                                    }
                                    else
                                    {

                                        return 0;
                                    }
                                }
                                catch (Exception ex)
                                {
                                    ClassLog cl = new ClassLog();
                                    cl.errLog(ex);
                                    return 0;

                                }

                            }

                        }


                    }


                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return 0;

                            }
                        }
                        else
                        {

                            return 0;
                        }
                    }
                    else
                    {

                        return 0;
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return 0;

                }








            }

            return 0;
        }
        catch (Exception ex)
        {
            return 0;

        }


    }

    public string GetPatientIdByIpdNo(int IpdNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM patient_medical_history pmh WHERE pmh.TransNo='" + IpdNo + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return dt.Rows[0]["PatientID"].ToString();
        }
        else
        {
            return "0";
        }

    }
    public string GetPatientIdByTransactionId(string TransactionId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM patient_medical_history pmh WHERE pmh.TransactionID='" + TransactionId + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return dt.Rows[0]["PatientID"].ToString();
        }
        else
        {
            return "0";
        }

    }

    public string GetIpdNoByTransactionId(string TransactionId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM patient_medical_history pmh WHERE pmh.TransactionID='" + TransactionId + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return dt.Rows[0]["TransNo"].ToString();
        }
        else
        {
            return "0";
        }

    }

    public string GetIpdTransactionId(int IpdNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  * FROM patient_medical_history pmh ");
        sb.Append(" WHERE pmh.TransNo=" + IpdNo + " ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return dt.Rows[0]["TransactionID"].ToString();
        }
        else
        {
            return "0";
        }

    }
    public int GetPanelDetailsIdUsingSmartCard(string PatientID, string PanelId, int SessionId)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM  paneldetails pd  WHERE pd.PatientID='" + PatientID + "' AND pd.PanelID='" + PanelId + "' AND pd.SessionId=" + SessionId + " AND pd.IsActive=1");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            return Util.GetInt(dt.Rows[0]["ID"].ToString());
        }
        else
        {
            return 0;
        }

    }
    public int GetPoolNrByEncounterNo(int EncounterNo)
    {
        try
        {
            string PoolNr = Util.GetString(StockReports.ExecuteScalar("SELECT pe.ForPoolNr FROM patient_encounter pe WHERE pe.EncounterNo='" + EncounterNo + "'"));

            return Util.GetInt(PoolNr);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }

    public string GetPoolDescByEncounterNo(int EncounterNo, int PoolNr)
    {
        try
        {
            string PoolDesc = Util.GetString(StockReports.ExecuteScalar("SELECT lt.PoolDesc FROM f_ledgertransaction lt WHERE lt.EncounterNo='" + EncounterNo + "' AND lt.PoolNr='" + PoolNr + "' LIMIT 1"));

            return Util.GetString(PoolDesc);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }


    public DataTable GetPatientCardDetails(string PatientId,string TransactionId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pmh.`PolicyNo`,pmh.`RelationWith_holder`,pmh.`TransactionID` FROM patient_medical_history pmh WHERE pmh.`PatientID`='" + PatientId + "' AND pmh.`TransactionID`='" + TransactionId + "' ORDER BY pmh.`TransactionID` DESC LIMIT 1");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt; 
    }
}