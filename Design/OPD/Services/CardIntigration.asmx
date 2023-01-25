<%@ WebService Language="C#" Class="CardIntigration" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Net.Http;
using Newtonsoft.Json.Linq;



[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CardIntigration : System.Web.Services.WebService
{
    GetEncounterNo Encounter = new GetEncounterNo();

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetToken()
    {
        // string recivedata = "";
        CardTokenResponseModel tokenResponse = AuthenticationHelper.GetBearerToken();


        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = tokenResponse.AccessToken });

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string FetchVist(string PatientID, string Status)
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
                    string urldat = "api/visit?patientNumber='" + PatientID + "'&sessionStatus='" + Status + "'";
                    HttpResponseMessage Res = client.GetAsync(urldat).GetAwaiter().GetResult();

                    string status_code = Res.StatusCode.ToString();
                    //Checking the response is successful or not which is sent using HttpClient  
                    if (Res.IsSuccessStatusCode)
                    {
                        recivedata = Res.Content.ReadAsStringAsync().Result;
                        var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = data });
                    }
                    else
                    {
                        recivedata = Res.ReasonPhrase;
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    recivedata = "Error occured ! Contact to Administrator";
                }

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = recivedata });

            }

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = "Some Error Occured" });

        }

    }




    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string MergeSessionAndVisitId()
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
                    System.Net.Http.HttpContent requestContent = new System.Net.Http.StringContent("", Encoding.UTF8, "application/x-www-form-urlencoded");
                    string urldat = "api/patient-number/2109/visit-number/1";
                    HttpResponseMessage Res = client.PutAsync(urldat, requestContent).GetAwaiter().GetResult();

                    string status_code = Res.StatusCode.ToString();
                    recivedata = Res.Content.ReadAsStringAsync().Result;
                    var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                    //Checking the response is successful or not which is sent using HttpClient  
                    if (Res.IsSuccessStatusCode)
                    {
                        recivedata = Res.Content.ReadAsStringAsync().Result;
                        var data1 = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = data1 });
                    }
                    else
                    {
                        recivedata = Res.Content.ReadAsStringAsync().Result;
                        var data1 = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = data });
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    recivedata = "Error occured ! Contact to Administrator";
                }

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = recivedata });

            }

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = "Some Error Occured" });

        }

    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetMemberDetails(string PatientID, string PanelId)
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
                    string Status = "PENDING";
                    string urldata = "api/visit?patientNumber=" + PatientID + "&sessionStatus=" + Status + "";
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
                                string urldat = "api/member?patientNumber=" + PatientID + "&sessionId=" + FetchVisitDat.content[0].session_id + "";
                                HttpResponseMessage Res = client.GetAsync(urldat).GetAwaiter().GetResult();

                                string status_code = Res.StatusCode.ToString();
                                //Checking the response is successful or not which is sent using HttpClient  
                                if (Res.IsSuccessStatusCode)
                                {
                                    recivedata = Res.Content.ReadAsStringAsync().Result;
                                    var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                                    object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);

                                    GetMenberDetails FetchDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(Seralizedata), typeof(GetMenberDetails));


                                    if (FetchDat.content.Count > 0)
                                    {
                                        GetEncounterNo Encounter = new GetEncounterNo();
                                        int IsSamrtCardFetchPrevious = Encounter.IsUsingSmartCard(PatientID, PanelId, FetchDat.content[0].session_id);
                                        int SaveVal = 2;
                                        if (IsSamrtCardFetchPrevious == 0)
                                        {
                                            SaveVal = InsertPanelAmount(PatientID, PanelId, FetchDat.content[0].benefits[0].amount, FetchDat.content[0].card_serial_number, FetchDat.content[0].session_id, FetchDat);
                                        }

                                        if (SaveVal == 0)
                                        {
                                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Error occured ! Contact to Administrator" });

                                        }
                                        else
                                        {
                                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = true, response = data });
                                        }
                                    }
                                    else
                                    {
                                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Please Process through Smart card." });
                                    }


                                }
                                else
                                {
                                    recivedata = Res.Content.ReadAsStringAsync().Result;
                                    var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, SaveStatus = false, response = data });
                                }
                            }
                            catch (Exception ex)
                            {
                                ClassLog cl = new ClassLog();
                                cl.errLog(ex);

                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Error in Fetching Patinet Data From Smart Card." });

                            }


                        }
                        else
                        {
                            try
                            {
                                int LastSessionID = Util.GetInt(StockReports.ExecuteScalar(" SELECT pd.sessionId FROM paneldetails pd WHERE pd.PatientId='" + PatientID + "' AND Pd.PanelID='" + PanelId + "' ORDER BY id DESC LIMIT 1   "));

                                int LastPdID = Util.GetInt(StockReports.ExecuteScalar(" SELECT pd.Id FROM paneldetails pd WHERE pd.PatientId='" + PatientID + "' AND Pd.PanelID='" + PanelId + "' ORDER BY id DESC LIMIT 1   "));

                                int PoolNr = Util.GetInt(StockReports.ExecuteScalar("   SELECT pe.ForPoolNr FROM patient_encounter pe  WHERE pe.SessionId='" + LastSessionID + "'  "));


                                int IsClaimPosted = Util.GetInt(StockReports.ExecuteScalar("   SELECT IFNULL(pd.IsClaimPosted,0) FROM paneldetails_description pd where pd.PanelDetailsId='" + LastPdID + "' And pd.pool_nr='" + PoolNr + "'  "));

                                if (IsClaimPosted == 1)
                                {
                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Please Genrate New Session Claim Is Already Posted." });
                                }


                                int IsSessionClose = Util.GetInt(StockReports.ExecuteScalar("   SELECT  IF(pe.Active=0,0,1) FROM patient_encounter pe  WHERE pe.SessionId='" + LastSessionID + "'  "));

                                if (IsSessionClose == 0)
                                {
                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Please Process through Smart card." });
                                }

                                string urldat = "api/member?patientNumber=" + PatientID + "&sessionId=" + LastSessionID + "";
                                HttpResponseMessage Res = client.GetAsync(urldat).GetAwaiter().GetResult();

                                string status_code = Res.StatusCode.ToString();
                                //Checking the response is successful or not which is sent using HttpClient  
                                if (Res.IsSuccessStatusCode)
                                {
                                    recivedata = Res.Content.ReadAsStringAsync().Result;
                                    var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                                    object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);

                                    GetMenberDetails FetchDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(Seralizedata), typeof(GetMenberDetails));


                                    if (FetchDat.content.Count > 0)
                                    {
                                        GetEncounterNo Encounter = new GetEncounterNo();
                                        int IsSamrtCardFetchPrevious = Encounter.IsUsingSmartCard(PatientID, PanelId, FetchDat.content[0].session_id);
                                        int SaveVal = 2;
                                        if (IsSamrtCardFetchPrevious == 0)
                                        {
                                            SaveVal = InsertPanelAmount(PatientID, PanelId, FetchDat.content[0].benefits[0].amount, FetchDat.content[0].card_serial_number, FetchDat.content[0].session_id, FetchDat);
                                        }

                                        if (SaveVal == 0)
                                        {
                                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Error occured ! Contact to Administrator" });

                                        }
                                        else
                                        {
                                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = true, response = data });
                                        }
                                    }
                                    else
                                    {
                                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Please Process through Smart card." });
                                    }


                                }
                                else
                                {
                                    recivedata = Res.Content.ReadAsStringAsync().Result;
                                    var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, SaveStatus = false, response = data });
                                }




                            }
                            catch (Exception ex)
                            {
                                ClassLog cl = new ClassLog();
                                cl.errLog(ex);
                                //  recivedata = "Error occured ! Contact to Administrator";

                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Error in Fetching Patinet Data From Smart Card." });

                            }


                        }


                    }
                    else
                    {
                        recivedata = Ress.ReasonPhrase;

                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Error in Fetching Patinet Data From Smart Card." });


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Error occured ! Contact to Administrator" });


                }


            }

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Error occured ! Contact to Administrator" });


        }

    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SubmitClaim(string PanelId, string InvoiceNo, int EncounterNo)
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

                    // card Diagnosis
                    CardPatientDetails CardPatientDetails = GetCardPatientDetails(EncounterNo, PanelId, InvoiceNo, GetPatientId(EncounterNo));


                    string urldata = "api/member?patientNumber=" + CardPatientDetails.patient_number + "&sessionId=" + CardPatientDetails.session_id + "";

                    HttpResponseMessage Ress = client.GetAsync(urldata).GetAwaiter().GetResult();
                    string recived = Ress.Content.ReadAsStringAsync().Result;
                    var Visitdata = Newtonsoft.Json.JsonConvert.DeserializeObject(recived);
                    object SeralizeVisitdata = Newtonsoft.Json.JsonConvert.DeserializeObject(recived);

                    //Checking the response is successful or not which is sent using HttpClient  
                    if (Ress.IsSuccessStatusCode)
                    {
                        //string recived = Ress.Content.ReadAsStringAsync().Result;
                        //var Visitdata = Newtonsoft.Json.JsonConvert.DeserializeObject(recived);
                        //object SeralizeVisitdata = Newtonsoft.Json.JsonConvert.DeserializeObject(recived);

                        GetMenberDetails FetchVisitDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(SeralizeVisitdata), typeof(GetMenberDetails));
                        if (FetchVisitDat != null && FetchVisitDat.content.Count > 0)
                        {

                            try
                            {
                                CardPatientDetails.sp_id = Util.GetInt(FetchVisitDat.content[0].benefits[0].exchange_location.sp_id);

                                string TransactionId = GettransactionId(EncounterNo);


                                // card Diagnosis
                                List<CardDiagnosis> CardDiagnosis = GetCardDiagnosi(TransactionId);

                                //Card Authorization
                                List<CardPreAuthorization> CardPreAuthorization = GetCardPreAuthorization(TransactionId);

                                //Admission 
                                CardAdmissionDetails Admission = GetCardAdmissionDetails(EncounterNo);

                                // Invoice
                                List<CardInvoiceDetails> CardInvoice = GetCardInvoiceDetails(InvoiceNo, GetPatientId(EncounterNo), PanelId, TransactionId);



                                string urldat = "api/claims?patientNumber=" + CardPatientDetails.patient_number + "&sessionId=" + CardPatientDetails.session_id + "";


                                string pp = GetString(CardPatientDetails, CardDiagnosis, CardPreAuthorization,
                                    Admission, CardInvoice);
                                //string payload = System.IO.File.ReadAllText(pp);
                                JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                                var data = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                                HttpResponseMessage Res = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                                string status_code = Res.StatusCode.ToString();
                                recivedata = Res.Content.ReadAsStringAsync().Result;
                                var data1 = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                                //Checking the response is successful or not which is sent using HttpClient  
                                if (Res.IsSuccessStatusCode)
                                {

                                    CardSubmitDetails FetchDat = (CardSubmitDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(data1), typeof(CardSubmitDetails));

                                    int PanelDetailsId = Encounter.GetPanelDetailsIdUsingSmartCard(GetPatientId(EncounterNo), PanelId, CardPatientDetails.session_id);
                                    int a = UpdateIfClaimSubmitted(PanelDetailsId, FetchDat.content.id, EncounterNo, InvoiceNo, CardInvoice[0].pool_number);
                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Msg = data1 });

                                }
                                else
                                {
                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = data1 });
                                }
                            }
                            catch (Exception ex)
                            {
                                ClassLog cl = new ClassLog();
                                cl.errLog(ex);
                                recivedata = "Error occured ! Contact to Administrator";
                            }

                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = recivedata });
                        }
                        else
                        {
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = new { message = "Member Details Not Found." } });
                        }
                    }
                    else
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = Visitdata });

                    }

                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    recivedata = "Error occured ! Contact to Administrator";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = new { message = "Error occured ! Contact to Administrator" } });
                }


            }

        }
        catch (Exception ex)
        {
            //  Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = "Some Error Occured" });

        }
        finally
        {
            //Tranx.Dispose();
            //con.Close();
            //con.Dispose();
        }






    }




    public List<CardDiagnosis> GetCardDiagnosi(string TransactionId)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" select cm.ICD_Code,icd.WHO_Full_Desc Name,'icd 10' CoadingSatnderd,true is_added_with_claim,true is_primary from cpoe_10cm_patient cm  ");
        sb.Append(" inner join icd_10_new icd on icd.ICD10_Code=cm.ICD_Code WHERE cm.TransactionID IN (" + TransactionId + ") AND cm.IsActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        List<CardDiagnosis> CardDiagList = new List<CardDiagnosis>();
        if (dt.Rows.Count > 0 && dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CardDiagnosis Cd = new CardDiagnosis();
                Cd.code = dt.Rows[i]["ICD_Code"].ToString();
                Cd.coding_standard = dt.Rows[i]["CoadingSatnderd"].ToString();
                Cd.is_added_with_claim = true;
                Cd.name = dt.Rows[i]["Name"].ToString();
                Cd.primary = true;
                CardDiagList.Add(Cd);
            }

        }
        return CardDiagList;
    }


    public string GettransactionId(int EncounterNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT GROUP_CONCAT(lt.TransactionID)TransactionID FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sb.Append(" WHERE lt.EncounterNo=" + EncounterNo + " AND pmh.TYPE='OPD'");
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
    public string GetPatientId(int EncounterNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM patient_encounter pe WHERE pe.EncounterNo=" + EncounterNo + " ");
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
    public CardAdmissionDetails GetCardAdmissionDetails(int EncounterNo)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT * FROM patient_encounter pe WHERE pe.EncounterNo=" + EncounterNo + " ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        CardAdmissionDetails ID = new CardAdmissionDetails();
        ID.additional_info = "";
        ID.admission_date = Util.GetDateTime(dt.Rows[0]["DateTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
        ID.admission_number = dt.Rows[0]["EncounterNo"].ToString();
        ID.discharge_date = Util.GetDateTime(dt.Rows[0]["DateTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
        ID.discharge_summary = "";

        return ID;
    }




    public List<CardInvoiceDetails> GetCardInvoiceDetails(string InvoiceNo, string PatientId, string PanelId, string TransactionId)
    {


        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT SUM(fd.`PanelAmount`)BillAmount,SUM(fd.`GrossAmount`-fd.`DiscAmt`)GrossAmount ,fd.DispatchDate,GROUP_CONCAT(fd.TransactionID)TransactionID,fd.panelInvoiceNo,fd.BillDate FROM f_dispatch fd  WHERE fd.isCancel=0 and fd.panelInvoiceNo='" + InvoiceNo + "' AND fd.PatientID='" + PatientId + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        List<CardInvoiceDetails> InvoiceList = new List<CardInvoiceDetails>();
        if (dt.Rows.Count > 0 && dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CardInvoiceDetails ID = new CardInvoiceDetails();
                StringBuilder sbPoolNr = new StringBuilder();
                sbPoolNr.Append("SELECT lt.`PoolNr`,lt.`PoolDesc` FROM f_ledgertransaction lt WHERE lt.`TransactionID` IN (" + dt.Rows[i]["TransactionID"].ToString() + ")");
                DataTable dtPoolNr = StockReports.GetDataTable(sbPoolNr.ToString());
                int PoolNr = 0;
                string PoolDesc = "";
                decimal SpendAbleAmount = 0;
                if (dtPoolNr != null || dtPoolNr.Rows.Count > 0)
                {
                    PoolNr = Util.GetInt(dtPoolNr.Rows[0]["PoolNr"].ToString());
                    PoolDesc = Util.GetString(dtPoolNr.Rows[0]["PoolDesc"].ToString());
                    int Ids = Util.GetInt(StockReports.ExecuteScalar(" SELECT pd.Id FROM paneldetails pd WHERE pd.PatientId='" + PatientId + "' AND Pd.PanelID='" + PanelId + "' ORDER BY id DESC LIMIT 1   "));
                    StringBuilder sbpds = new StringBuilder();
                    sbpds.Append(" SELECT * FROM paneldetails_description pd ");
                    sbpds.Append(" WHERE pd.PanelDetailsId='" + Ids + "' AND  pd.pool_nr='" + PoolNr + "' ");
                    DataTable dtpds = StockReports.GetDataTable(sbpds.ToString());
                    SpendAbleAmount = Util.GetDecimal(dtpds.Rows[0]["amount"].ToString());


                }

                decimal NhifPayable = Util.GetInt(StockReports.ExecuteScalar(" SELECT IFNULL( SUM( pa.`Amount`),0 )FROM  panel_amountallocation  pa WHERE pa.`PanelID` IN(728,701,504,429) AND pa.`TransactionID`  IN (" + dt.Rows[i]["TransactionID"].ToString() + ") "));


                ID.amount = Util.GetDouble(dt.Rows[i]["BillAmount"].ToString());
                ID.gross_amount = Util.GetDouble(dt.Rows[i]["GrossAmount"].ToString());
                ID.invoice_date = Util.GetDateTime(dt.Rows[i]["BillDate"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                ID.invoice_number = Util.GetString(dt.Rows[i]["panelInvoiceNo"].ToString());
                ID.invoice_ref_number = "";
                ID.pool_number = Util.GetString(PoolNr);
                ID.service_type = PoolDesc;
                ID.lines = GetCardInvoiceLinesDetails(dt.Rows[i]["TransactionID"].ToString());
                ID.payment_modifiers = GetCardInvoicePaymentModifiersDetails(InvoiceNo, PatientId, SpendAbleAmount, Util.GetDecimal(ID.gross_amount), NhifPayable, TransactionId);
                InvoiceList.Add(ID);
            }

        }



        return InvoiceList;
    }

    public List<CardInvoiceLinesDetails> GetCardInvoiceLinesDetails(string TransactionId)
    {


        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT *,(  SELECT cm.NAME FROM f_categorymaster cm INNER JOIN f_subcategorymaster sm ON sm.CategoryID=cm.CategoryID WHERE sm.SubcategoryID= ltd.SubcategoryID )ServiceType FROM f_ledgertnxdetail ltd WHERE ltd.TransactionID in (" + TransactionId + ") AND ltd.IsVerified<>2");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        List<CardInvoiceLinesDetails> InvoiceLineList = new List<CardInvoiceLinesDetails>();
        if (dt.Rows.Count > 0 && dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CardInvoiceLinesDetails ID = new CardInvoiceLinesDetails();

                ID.amount = Util.GetDouble(dt.Rows[i]["GrossAmount"].ToString());
                ID.unit_price = Util.GetDouble(dt.Rows[i]["Rate"].ToString());
                ID.quantity = Util.GetDouble(dt.Rows[i]["Quantity"].ToString());

                ID.charge_date = Util.GetDateTime(dt.Rows[i]["EntryDate"].ToString()).ToString("yyyy-MM-dd");
                ID.charge_time = Util.GetDateTime(dt.Rows[i]["EntryDate"].ToString()).ToString("HH:mm:ss");
                ID.additional_info = "";
                ID.item_code = Util.GetString(dt.Rows[i]["ItemID"].ToString());
                ID.item_name = Util.GetString(dt.Rows[i]["ItemName"].ToString());

                ID.pre_authorization_code = "";
                ID.service_group = Util.GetString(dt.Rows[i]["ServiceType"].ToString());

                InvoiceLineList.Add(ID);
            }

        }



        return InvoiceLineList;
    }

    public List<CardInvoicePaymentModifiersDetails> GetCardInvoicePaymentModifiersDetails(string InvoiceNo, string PatientId, decimal SpendableAmount, decimal BillAmount, decimal NhifPayable, string TransactionId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT SUM(fd.`GrossAmount`-fd.`DiscAmt`-fd.`PanelAmount`)PatientPaybleAmt FROM f_dispatch fd  WHERE fd.isCancel=0 and fd.panelInvoiceNo='" + InvoiceNo + "' AND fd.PatientID='" + PatientId + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        List<CardInvoicePaymentModifiersDetails> InvoiceLineList = new List<CardInvoicePaymentModifiersDetails>();

        if (NhifPayable <= 0)
        {

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CardInvoicePaymentModifiersDetails ID = new CardInvoicePaymentModifiersDetails();
                if (BillAmount > SpendableAmount)
                {
                    ID.type = "0";
                }
                else
                {
                    ID.type = "1";

                }

                ID.amount = Util.GetDouble(dt.Rows[i]["PatientPaybleAmt"].ToString());
                ID.reference_number = "";

                InvoiceLineList.Add(ID);

            }
        }
        else
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CardInvoicePaymentModifiersDetails ID = new CardInvoicePaymentModifiersDetails();
                if (BillAmount > SpendableAmount)
                {
                    ID.type = "0";
                }
                else
                {
                    ID.type = "1";

                }

                ID.amount = Util.GetDouble(dt.Rows[i]["PatientPaybleAmt"].ToString());
                ID.reference_number = "";

                InvoiceLineList.Add(ID);

            }

            CardInvoicePaymentModifiersDetails Nhif = new CardInvoicePaymentModifiersDetails();
            DataTable Pdt = Encounter.GetPatientCardDetails(PatientId, TransactionId);
            string nhif_member_nr = "";
            string nhif_patient_relation = "";
            if (Pdt != null && Pdt.Rows.Count > 0)
            {
                nhif_member_nr = Pdt.Rows[0]["PolicyNo"].ToString();
                nhif_patient_relation = Pdt.Rows[0]["RelationWith_holder"].ToString();
            }


            Nhif.type = "5";
            Nhif.amount = Util.GetDouble(NhifPayable);
            Nhif.reference_number = "";
            Nhif.nhif_contributor_nr = "";
            Nhif.nhif_employer_code = "";
            Nhif.nhif_member_nr = nhif_member_nr;
            Nhif.nhif_patient_relation = nhif_patient_relation;
            Nhif.nhif_site_nr = "";

            InvoiceLineList.Add(Nhif);


        }

        return InvoiceLineList;
    }



    public List<CardPreAuthorization> GetCardPreAuthorization(string TransactionId)
    {


        StringBuilder sb = new StringBuilder();

        List<CardPreAuthorization> InvoiceLineList = new List<CardPreAuthorization>();

        for (int i = 1; i < 1; i++)
        {
            CardPreAuthorization ID = new CardPreAuthorization();
            ID.code = "P150";
            ID.amount = 5000;
            ID.authorized_by = "Esther";
            ID.message = "Authorized up to 5000 by Esther";
            InvoiceLineList.Add(ID);

        }

        return InvoiceLineList;
    }


    public CardPatientDetails GetCardPatientDetails(int EncounterNo, string PanelId, string InvoiceNo, string PatientId)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT pd.*,pe.EncounterNo,CONCAT(pm.Title,'', pm.PName)pName  FROM paneldetails pd ");
        sb.Append(" INNER JOIN patient_encounter pe ON pe.SessionId=pd.SessionId ");
        sb.Append(" INNER JOIN patient_master pm  ON pm.PatientID=pe.PatientID ");
        sb.Append(" WHERE pd.IsActive=1 AND pe.EncounterNo=" + EncounterNo + " AND pd.PanelID='" + PanelId + "'");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        CardPatientDetails ID = new CardPatientDetails();
        if (dt.Rows.Count > 0 && dt != null)
        {




            StringBuilder sbAd = new StringBuilder();

            sbAd.Append("SELECT SUM(fd.PanelAmount)NetAmt,SUM(fd.GrossAmount)GrossAmt,fd.DocketNo,fd.DispatchDate FROM f_dispatch fd WHERE fd.panelInvoiceNo='" + InvoiceNo + "' AND fd.PatientID='" + PatientId + "' AND fd.isCancel=0 ");

            DataTable dtAd = StockReports.GetDataTable(sbAd.ToString());

            StringBuilder sbPd = new StringBuilder();

            sbPd.Append(" SELECT pm.PanelGroupID,pm.PanelGroup FROM f_panel_master pm WHERE pm.PanelID='" + PanelId + "' ");

            DataTable dtPd = StockReports.GetDataTable(sbPd.ToString());



            ID.claim_code = InvoiceNo;
            ID.payer_code = dtPd.Rows[0]["PanelGroupID"].ToString();
            ID.payer_name = dtPd.Rows[0]["PanelGroup"].ToString();
            ID.medicalaid_code = dt.Rows[0]["medicalaid_code"].ToString();

            ID.amount = Util.GetDouble(dtAd.Rows[0]["NetAmt"].ToString());
            ID.gross_amount = Util.GetDouble(dtAd.Rows[0]["GrossAmt"].ToString());
            ID.batch_number = Util.GetString(dtAd.Rows[0]["DocketNo"].ToString());
            ID.dispatch_date = Util.GetDateTime(dtAd.Rows[0]["DispatchDate"]).ToString("yyyy-MM-dd HH:mm:ss");

            ID.patient_number = dt.Rows[0]["PatientID"].ToString();
            ID.patient_name = dt.Rows[0]["pName"].ToString();
            ID.location_code = HttpContext.Current.Session["CentreName"].ToString();
            ID.location_name = HttpContext.Current.Session["CentreName"].ToString();
            ID.scheme_code = dt.Rows[0]["medicalaid_scheme_code"].ToString();
            ID.scheme_name = dt.Rows[0]["medicalaid_scheme_name"].ToString();
            ID.member_number = dt.Rows[0]["medicalaid_number"].ToString();
            ID.visit_number = dt.Rows[0]["EncounterNo"].ToString();

            ID.session_id = Util.GetInt(dt.Rows[0]["SessionId"].ToString());
            ID.visit_start = Util.GetDateTime(dt.Rows[0]["FromValid"]).ToString("yyyy-MM-dd HH:mm:ss");
            ID.visit_end = Util.GetDateTime(dt.Rows[0]["ToValid"]).ToString("yyyy-MM-dd HH:mm:ss");
            ID.currency = dt.Rows[0]["policy_currency"].ToString();
            ID.doctor_name = GetDoctorName(EncounterNo);

            ID.sp_id = Util.GetInt(dt.Rows[0]["sp_id"].ToString()); ;


        }
        else
        {


            ID.claim_code = "MMCC00030";
            ID.payer_code = "SAMPLEX2";
            ID.payer_name = "SAMPLE PAYER NAME";
            ID.medicalaid_code = "string";
            ID.amount = 2630;
            ID.gross_amount = 2630;
            ID.batch_number = "batch4";
            ID.dispatch_date = "2018-01-05 00:00:00";
            ID.patient_number = "PROV_API";
            ID.patient_name = "SAMPLE NAME";
            ID.location_code = HttpContext.Current.Session["CentreName"].ToString();
            ID.location_name = HttpContext.Current.Session["CentreName"].ToString();
            ID.scheme_code = "SAMPLEX2";
            ID.scheme_name = "SAMPLE SCHEME";
            ID.member_number = "PAM124-00";
            ID.visit_number = "Test2";
            ID.session_id = 428;
            ID.visit_start = "2018-01-03 00:00:00";
            ID.visit_end = "2018-01-03 00:00:00";
            ID.currency = "KES";
            ID.doctor_name = "DR. Omondi";
            ID.sp_id = 568;

        }

        return ID;
    }

    public string GetDoctorName(int EncounterNo)
    {

        StringBuilder sbDD = new StringBuilder();

        sbDD.Append(" SELECT  pmh.DoctorID, CONCAT(dm.Title,dm.NAME)DrName FROM f_ledgertransaction lt ");
        sbDD.Append(" INNER JOIN  patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
        sbDD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sbDD.Append(" WHERE lt.EncounterNo=" + EncounterNo + " LIMIT 1 ");
        DataTable dtDD = StockReports.GetDataTable(sbDD.ToString());
        return dtDD.Rows[0]["DrName"].ToString();
    }



    public int InsertPanelAmount(string PatientID, string PanelId, double Amount, string cardNumber, int SessionId, GetMenberDetails GetMD)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            int result1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update paneldetails set IsActive='0' where PatientID='" + PatientID + "' and PanelID='" + PanelId + "' ");

            string fromdate = Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss");
            string todate = Util.GetDateTime(DateTime.Now).AddDays(1).ToString("yyyy-MM-dd HH:mm:ss");
            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO `paneldetails` (   `PatientID`,  `PanelID`,  `CardNumber`,  `FromValid`,  `ToValid`, ");
            sb.Append(" `ApproveAmount`,  `EntryBy`,  `EntryDate`,  `IsActive`,SessionId, ");
            sb.Append(" `medicalaid_code`,`medicalaid_name`,`policy_id`,`medicalaid_scheme_code`,`medicalaid_scheme_name`, ");
            sb.Append("  `medicalaid_number`,`member_name`,`global_id`,`card_serial_number`,`medicalaid_plan`, ");
            sb.Append(" `medicalaid_regdate`,`medicalaid_expiry`,`policy_country`,`policy_currency`,`Sp_id` ");
            sb.Append(" )");
            sb.Append(" VALUES  ( '" + PatientID + "','" + PanelId + "','" + cardNumber + "',  '" + fromdate + "',  '" + todate + "', ");
            sb.Append("  '" + Amount + "',    '" + Session["ID"].ToString() + "',now(),'1'," + Util.GetInt(SessionId) + ", ");
            sb.Append("  '" + GetMD.content[0].medicalaid_code + "', '" + GetMD.content[0].medicalaid_name + "', '" + GetMD.content[0].policy_id + "', '" + GetMD.content[0].medicalaid_scheme_code + "', ");
            sb.Append("  '" + GetMD.content[0].medicalaid_scheme_name + "', '" + GetMD.content[0].medicalaid_number + "', '" + GetMD.content[0].member_name + "', '" + GetMD.content[0].global_id + "', ");
            sb.Append("  '" + GetMD.content[0].card_serial_number + "', '" + GetMD.content[0].medicalaid_plan + "', '" + Util.GetDateTime(GetMD.content[0].medicalaid_regdate).ToString("yyyy-MM-dd") + "', ");
            sb.Append("  '" + Util.GetDateTime(GetMD.content[0].medicalaid_expiry).ToString("yyyy-MM-dd") + "', '" + GetMD.content[0].policy_country + "', '" + GetMD.content[0].policy_currency + "' ");

            sb.Append(" , '" + GetMD.content[0].benefits[0].exchange_location.sp_id + "'    );");
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());



            int PanelDetailsID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(id)FROM PANELDETAILS"));


            foreach (var item in GetMD.content[0].benefits)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO `paneldetails_description` (PanelDetailsId,pool_nr,pool_desc,");
                sb.Append("  amount,claimable,location_id , sp_id,location_name , BenefitID,SessionID )");

                sb.Append(" VALUES  ( ");
                sb.Append(" " + PanelDetailsID + ",'" + item.pool_nr.Replace("\'", " ") + "' ,'" + item.pool_desc.Replace("\'", " ") + "',");
                sb.Append(" " + Util.GetDecimal(item.amount) + "," + Util.GetBoolean(item.claimable) + " ," + Util.GetInt(item.location_id) + ",");
                sb.Append(" '" + item.sp_id + "','" + item.location_name + "'," + Util.GetInt(item.id) + " ," + Util.GetInt(SessionId) + " ");

                sb.Append(" )");

                int DesRes = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            }



            tnx.Commit();

            return 1;

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    public string GetString(CardPatientDetails CardPatientDetails, List<CardDiagnosis> CardDiagnosis, List<CardPreAuthorization> CardPreAuthorization, CardAdmissionDetails Admission, List<CardInvoiceDetails> CardInvoice)
    {

        StringBuilder sb = new StringBuilder();



        sb.Append("{");

        sb.Append("\"claim_code\":\"" + CardPatientDetails.claim_code + "\",");
        sb.Append("\"payer_code\":\"" + CardPatientDetails.payer_code + "\",");
        sb.Append("\"payer_name\":\"" + CardPatientDetails.payer_name + "\",");
        sb.Append("\"medicalaid_code\":\"" + CardPatientDetails.medicalaid_code + "\",");
        sb.Append("\"amount\":" + CardPatientDetails.amount + ",");

        sb.Append("\"gross_amount\":" + CardPatientDetails.gross_amount + ",");
        sb.Append("\"batch_number\":\"" + CardPatientDetails.batch_number + "\",");
        sb.Append("\"dispatch_date\":\"" + CardPatientDetails.dispatch_date + "\",");
        sb.Append("\"patient_number\":\"" + CardPatientDetails.patient_number + "\",");
        sb.Append("\"patient_name\":\"" + CardPatientDetails.patient_name + "\",");

        sb.Append("\"location_code\":\"" + CardPatientDetails.location_code + "\",");
        sb.Append("\"location_name\":\"" + CardPatientDetails.location_name + "\",");
        sb.Append("\"scheme_code\":\"" + CardPatientDetails.scheme_code + "\",");
        sb.Append("\"scheme_name\":\"" + CardPatientDetails.scheme_name + "\",");
        sb.Append("\"member_number\":\"" + CardPatientDetails.member_number + "\",");

        sb.Append("\"visit_number\":\"" + CardPatientDetails.visit_number + "\",");
        sb.Append("\"session_id\": " + CardPatientDetails.session_id + " ,");
        sb.Append("\"visit_start\":\"" + CardPatientDetails.visit_start + "\",");
        sb.Append("\"visit_end\":\"" + CardPatientDetails.visit_end + "\",");
        sb.Append("\"currency\":\"" + CardPatientDetails.currency + "\",");

        sb.Append("\"doctor_name\":\"" + CardPatientDetails.doctor_name + "\",");
        sb.Append("\"sp_id\": " + CardPatientDetails.sp_id + " ,");

        sb.Append("\"diagnosis\":[");
        foreach (var Diagitem in CardDiagnosis)
        {
            sb.Append("{");
            sb.Append("\"code\":\"" + Diagitem.code + "\",");
            sb.Append("\"coding_standard\":\"" + Diagitem.coding_standard + "\",");
            sb.Append("\"is_added_with_claim\":\"" + Diagitem.is_added_with_claim + "\",");
            sb.Append("\"name\":\"" + Diagitem.name + "\",");
            sb.Append("\"is_primary\":\"" + Diagitem.primary + "\" ");
            sb.Append("},");
        }

        sb.Append("],");

        sb.Append("\"pre_authorization\":[");
        foreach (var PA in CardPreAuthorization)
        {
            sb.Append("{");
            sb.Append("\"code\":\"" + PA.code + "\",");
            sb.Append("\"amount\": " + PA.amount + " ,");
            sb.Append("\"authorized_by\":\"" + PA.authorized_by + "\",");
            sb.Append("\"message\":\"" + PA.message + "\"");
            sb.Append("},");

        }

        sb.Append("],");


        sb.Append("\"admission\":{");

        sb.Append("\"additional_info\":\"" + Admission.additional_info + "\",");
        sb.Append("\"admission_date\":\"" + Admission.admission_date + "\",");
        sb.Append("\"admission_number\":\"" + Admission.admission_number + "\",");
        sb.Append("\"discharge_date\":\"" + Admission.discharge_date + "\",");
        sb.Append("\"discharge_summary\":\"" + Admission.discharge_summary + "\"");

        sb.Append("},");


        sb.Append("\"invoices\":[");

        foreach (var CD in CardInvoice)
        {

            sb.Append("{");


            sb.Append("\"amount\": " + CD.amount + ",");
            sb.Append("\"gross_amount\":" + CD.gross_amount + ",");
            sb.Append("\"invoice_date\":\"" + CD.invoice_date + "\",");
            sb.Append("\"invoice_number\":\"" + CD.invoice_number + "\",");
            sb.Append("\"invoice_ref_number\":\"" + CD.invoice_ref_number + "\",");

            sb.Append("\"lines\":[");
            foreach (var LD in CD.lines)
            {
                sb.Append("{");
                sb.Append("\"additional_info\":\"" + LD.additional_info + "\",");
                sb.Append("\"amount\": " + LD.amount + ",");
                sb.Append("\"charge_date\":\"" + LD.charge_date + "\",");
                sb.Append("\"charge_time\":\"" + LD.charge_time + "\",");
                sb.Append("\"item_code\":\"" + LD.item_code + "\",");
                sb.Append("\"item_name\":\"" + LD.item_name + "\",");
                sb.Append("\"pre_authorization_code\":\"" + LD.pre_authorization_code + "\",");
                sb.Append("\"quantity\": " + LD.quantity + ",");
                sb.Append("\"service_group\":\"" + LD.service_group + "\",");

                sb.Append("\"unit_price\": " + LD.unit_price + "");


                sb.Append("},");

            }

            sb.Append("],");

            sb.Append("\"payment_modifiers\":[");
            foreach (var PM in CD.payment_modifiers)
            {
                if (PM.type == "5")
                {
                    sb.Append("{");
                    sb.Append("\"type\":\"" + PM.type + "\",");
                    sb.Append("\"amount\": " + PM.amount + ",");
                    sb.Append("\"reference_number\":\"" + PM.reference_number + "\",");
                    sb.Append("\"nhif_contributor_nr\":\"" + PM.nhif_contributor_nr + "\",");
                    sb.Append("\"nhif_employer_code\":\"" + PM.nhif_employer_code + "\",");
                    sb.Append("\"nhif_member_nr\":\"" + PM.nhif_member_nr + "\",");
                    sb.Append("\"nhif_patient_relation\":\"" + PM.nhif_patient_relation + "\",");
                    sb.Append("\"nhif_site_nr\":\"" + PM.nhif_site_nr + "\",");

                    sb.Append("},");
                }
                else
                {
                    sb.Append("{");
                    sb.Append("\"type\":\"" + PM.type + "\",");
                    sb.Append("\"amount\": " + PM.amount + ",");
                    sb.Append("\"reference_number\":\"" + PM.reference_number + "\",");

                    sb.Append("},");
                }


            }

            sb.Append("],");
            sb.Append("\"pool_number\":\"" + CD.pool_number + "\",");
            sb.Append("\"service_type\":\"" + CD.service_type + "\"");

            sb.Append("},");

        }
        sb.Append("],");

        sb.Append("}");


        return sb.ToString();

    }



    public int UpdateIfClaimSubmitted(int PanelDetailsID, int ClaimId, int EncounterNo, string InvoiceNo, string PoolNr)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            int result1 = excuteCMD.DML(tnx, "UPDATE patient_encounter s SET s.IsClaimPosted=1,s.ClaimPostId=@ClaimId,ClaimPostedDate=Now(),ClaimPostedBy=@ClaimPostedBy WHERE s.EncounterNo=@EncounterNo", CommandType.Text, new
            {
                EncounterNo = EncounterNo,
                ClaimId = ClaimId,
                ClaimPostedBy = HttpContext.Current.Session["ID"].ToString()
            });

            int result2 = excuteCMD.DML(tnx, "UPDATE paneldetails_description s SET s.IsClaimPosted=1,s.ClaimPostId=@ClaimId,ClaimPostedDate=Now(),ClaimPostedBy=@ClaimPostedBy,InvoiceNo=@InvoiceNo WHERE s.PanelDetailsId=@PanelDetailsId And pool_nr=@PoolNr", CommandType.Text, new
            {
                PanelDetailsId = PanelDetailsID,
                ClaimId = ClaimId,
                InvoiceNo = InvoiceNo,
                PoolNr = PoolNr,
                ClaimPostedBy = HttpContext.Current.Session["ID"].ToString()
            });

            tnx.Commit();
            return 1;

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    //////////////////////////////////////////
    // Card Intergation work for IPD
    //////////////////////////////////////////

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetMemberDetailsIpd(string PatientID, string PanelId)
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
                    string Status = "PENDING";
                    string urldata = "api/visit?patientNumber=" + PatientID + "&sessionStatus=" + Status + "";
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
                                string urldat = "api/member?patientNumber=" + PatientID + "&sessionId=" + FetchVisitDat.content[0].session_id + "";

                                HttpResponseMessage Res = client.GetAsync(urldat).GetAwaiter().GetResult();

                    string status_code = Res.StatusCode.ToString();
                    //Checking the response is successful or not which is sent using HttpClient  
                    if (Res.IsSuccessStatusCode)
                    {
                        recivedata = Res.Content.ReadAsStringAsync().Result;
                        var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        object Seralizedata = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);

                        GetMenberDetails FetchDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(Seralizedata), typeof(GetMenberDetails));

                        if (FetchDat.content.Count > 0)
                        {
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = true, response = data });
                        }
                        else
                        {

                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, SaveStatus = false, response = "Patient Details Not found for UHID = " + PatientID + " ,Please Verify With Smart Card." });

                        }


                    }
                    else
                    {
                        recivedata = Res.Content.ReadAsStringAsync().Result;
                        var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = data });
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    recivedata = "Error occured ! Contact to Administrator";
                }

                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, SaveStatus = false, response = recivedata });
                        }
                        else
                        {
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, SaveStatus = false, response = "Patient Details Not found for UHID = " + PatientID + " ,Please Verify With Smart Card." });

                        }
                    }
                    else
                    {

                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, SaveStatus = false, response = "Patient Details Not found for UHID = " + PatientID + " ,Please Verify With Smart Card." });

                    }




                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, SaveStatus = false, response = "Error occured ! Contact to Administrator" });


                }

            }

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Mresponsesg = "Some Error Occured" });

        }

    }






    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SubmitClaimIpd(string PanelId, string InvoiceNo, int IpdNo)
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
                    // card Diagnosis
                    CardPatientDetails CardPatientDetails = GetCardPatientDetailsIpd(IpdNo, PanelId, InvoiceNo, Encounter.GetPatientIdByIpdNo(IpdNo));

                    string urldata = "api/member?patientNumber=" + CardPatientDetails.patient_number + "&sessionId=" + CardPatientDetails.session_id + "";

                    HttpResponseMessage Ress = client.GetAsync(urldata).GetAwaiter().GetResult();
                    string recived = Ress.Content.ReadAsStringAsync().Result;
                    var Visitdata = Newtonsoft.Json.JsonConvert.DeserializeObject(recived);
                    object SeralizeVisitdata = Newtonsoft.Json.JsonConvert.DeserializeObject(recived);
                    //Checking the response is successful or not which is sent using HttpClient  
                    if (Ress.IsSuccessStatusCode)
                    {

                        GetMenberDetails FetchVisitDat = (GetMenberDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(SeralizeVisitdata), typeof(GetMenberDetails));
                        if (FetchVisitDat != null && FetchVisitDat.content.Count > 0)
                        {
                            try
                            {
                                CardPatientDetails.sp_id = Util.GetInt(FetchVisitDat.content[0].benefits[0].exchange_location.sp_id);

                                string TransactionId = Encounter.GetIpdTransactionId(IpdNo);

                    // card Diagnosis
                    List<CardDiagnosis> CardDiagnosis = GetCardDiagnosisIpd(TransactionId);

                    //Card Authorization
                    List<CardPreAuthorization> CardPreAuthorization = GetCardPreAuthorizationIpd(TransactionId);

                    //Admission 
                    CardAdmissionDetails Admission = GetCardAdmissionDetailsIpd(Util.GetString(IpdNo));

                    // Invoice
                    List<CardInvoiceDetails> CardInvoice = GetCardInvoiceDetailsIpd(InvoiceNo, Encounter.GetPatientIdByIpdNo(IpdNo), TransactionId, PanelId);



                    string urldat = "api/claims?patientNumber=" + CardPatientDetails.patient_number + "&sessionId=" + CardPatientDetails.session_id + "";


                    string pp = GetString(CardPatientDetails, CardDiagnosis, CardPreAuthorization,
                        Admission, CardInvoice);
                    //string payload = System.IO.File.ReadAllText(pp);
                    JObject reqObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                    var data = Newtonsoft.Json.JsonConvert.DeserializeObject<JObject>(pp);
                    HttpResponseMessage Res = client.PostAsJsonAsync(urldat, reqObj).GetAwaiter().GetResult();
                    string status_code = Res.StatusCode.ToString();
                    recivedata = Res.Content.ReadAsStringAsync().Result;
                    var data1 = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                    //Checking the response is successful or not which is sent using HttpClient  
                    if (Res.IsSuccessStatusCode)
                    {

                        CardSubmitDetails FetchDat = (CardSubmitDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(Newtonsoft.Json.JsonConvert.SerializeObject(data1), typeof(CardSubmitDetails));

                        int a = UpdateIfClaimSubmittedIpd(TransactionId, FetchDat.content.id,PanelId);
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Msg = data1 });

                    }
                    else
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = data1 });
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    recivedata = "Error occured ! Contact to Administrator";
                }

                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = recivedata });
                        }
                        else
                        {
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = new { message = "Member Details Not Found." } });
                        }
                    }
                    else
                    {
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = Visitdata });

                    }


                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    recivedata = "Error occured ! Contact to Administrator";
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = new { message = "Error occured ! Contact to Administrator" } });
                }
            }

        }
        catch (Exception ex)
        {
            //  Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = "Some Error Occured" });

        }
        finally
        {
            //Tranx.Dispose();
            //con.Close();
            //con.Dispose();
        }



    }


    public CardPatientDetails GetCardPatientDetailsIpd(int IpdNo, string PanelId, string InvoiceNo, string PatientId)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT pa.*,pmh.TransNo,CONCAT(pm.Title,'', pm.PName)pName  FROM panel_amountallocation pa ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=pa.TransactionID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
        sb.Append(" WHERE pa.IsMerge=1 AND pa.TransactionID='" + Encounter.GetIpdTransactionId(IpdNo) + "' AND pa.PanelID='" + PanelId + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        CardPatientDetails ID = new CardPatientDetails();
        if (dt.Rows.Count > 0 && dt != null)
        { 

            StringBuilder sbAd = new StringBuilder();

            sbAd.Append("SELECT SUM(fd.PanelAmount)NetAmt,SUM(fd.GrossAmount)GrossAmt,fd.DocketNo,fd.DispatchDate FROM f_dispatch fd WHERE fd.panelInvoiceNo='" + InvoiceNo + "' AND fd.PatientID='" + PatientId + "' AND fd.isCancel=0 ");

            DataTable dtAd = StockReports.GetDataTable(sbAd.ToString());

            StringBuilder sbPd = new StringBuilder();

            sbPd.Append(" SELECT pm.PanelGroupID,pm.PanelGroup FROM f_panel_master pm WHERE pm.PanelID='" + PanelId + "' ");

            DataTable dtPd = StockReports.GetDataTable(sbPd.ToString());



            ID.claim_code = InvoiceNo;
            ID.payer_code = dtPd.Rows[0]["PanelGroupID"].ToString();
            ID.payer_name = dtPd.Rows[0]["PanelGroup"].ToString();
            ID.medicalaid_code = dt.Rows[0]["medicalaid_code"].ToString();

            ID.amount = Util.GetDouble(dtAd.Rows[0]["NetAmt"].ToString());
            ID.gross_amount = Util.GetDouble(dtAd.Rows[0]["GrossAmt"].ToString());
            ID.batch_number = Util.GetString(dtAd.Rows[0]["DocketNo"].ToString());
            ID.dispatch_date = Util.GetDateTime(dtAd.Rows[0]["DispatchDate"]).ToString("yyyy-MM-dd HH:mm:ss");

            ID.patient_number = PatientId;
            ID.patient_name = dt.Rows[0]["pName"].ToString();
            ID.location_code = HttpContext.Current.Session["CentreName"].ToString();
            ID.location_name = HttpContext.Current.Session["CentreName"].ToString();
            ID.scheme_code = dt.Rows[0]["medicalaid_scheme_code"].ToString();
            ID.scheme_name = dt.Rows[0]["medicalaid_scheme_name"].ToString();
            ID.member_number = dt.Rows[0]["medicalaid_number"].ToString();
            ID.visit_number = dt.Rows[0]["TransNo"].ToString();

            ID.session_id = Util.GetInt(dt.Rows[0]["SessionId"].ToString());
            CardAdmissionDetails Cad= GetCardAdmissionDetailsIpd(Util.GetString( IpdNo));
            
            ID.visit_start = Util.GetDateTime(Cad.admission_date).ToString("yyyy-MM-dd HH:mm:ss");
            ID.visit_end = Util.GetDateTime(Cad.discharge_date).ToString("yyyy-MM-dd HH:mm:ss");
            ID.currency = dt.Rows[0]["policy_currency"].ToString();
            ID.doctor_name = GetDoctorNameIpd(IpdNo);

            ID.sp_id = Util.GetInt(dt.Rows[0]["sp_id"].ToString()); ;


        }
        else
        {


            ID.claim_code = "MMCC00030";
            ID.payer_code = "SAMPLEX2";
            ID.payer_name = "SAMPLE PAYER NAME";
            ID.medicalaid_code = "string";
            ID.amount = 2630;
            ID.gross_amount = 2630;
            ID.batch_number = "batch4";
            ID.dispatch_date = "2018-01-05 00:00:00";
            ID.patient_number = "PROV_API";
            ID.patient_name = "SAMPLE NAME";
            ID.location_code = HttpContext.Current.Session["CentreName"].ToString();
            ID.location_name = HttpContext.Current.Session["CentreName"].ToString();
            ID.scheme_code = "SAMPLEX2";
            ID.scheme_name = "SAMPLE SCHEME";
            ID.member_number = "PAM124-00";
            ID.visit_number = "Test2";
            ID.session_id = 428;
            ID.visit_start = "2018-01-03 00:00:00";
            ID.visit_end = "2018-01-03 00:00:00";
            ID.currency = "KES";
            ID.doctor_name = "DR. Omondi";
            ID.sp_id = 568;

        }

        return ID;
    }
    public string GetDoctorNameIpd(int IpdNo)
    {

        StringBuilder sbDD = new StringBuilder();

        sbDD.Append(" SELECT  pmh.DoctorID, CONCAT(dm.Title,dm.NAME)DrName FROM patient_medical_history pmh ");
        sbDD.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sbDD.Append("  WHERE pmh.TransNo='" + IpdNo + "' LIMIT 1 ");
        DataTable dtDD = StockReports.GetDataTable(sbDD.ToString());
        return dtDD.Rows[0]["DrName"].ToString();
    }



    public CardAdmissionDetails GetCardAdmissionDetailsIpd(string IpdNo)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT  CONCAT(pmh.DateOfAdmit,' ',pmh.TimeOfAdmit)AdmissionDateTime,CONCAT(pmh.DateOfDischarge,' ',pmh.TimeOfDischarge)DischargeDateTime,pmh.*  FROM patient_medical_history pmh WHERE pmh.TransNo='" + IpdNo + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        CardAdmissionDetails ID = new CardAdmissionDetails();
        ID.additional_info = "";
        ID.admission_date = Util.GetDateTime(dt.Rows[0]["AdmissionDateTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
        ID.admission_number = dt.Rows[0]["TransNo"].ToString();
        ID.discharge_date = Util.GetDateTime(dt.Rows[0]["DischargeDateTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
        ID.discharge_summary = "";

        return ID;
    }

    public List<CardInvoiceDetails> GetCardInvoiceDetailsIpd(string InvoiceNo, string PatientId, string TransactionId, string PanelId)
    {


        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT SUM(fd.`PanelAmount`)BillAmount,SUM(fd.`GrossAmount`-fd.`DiscAmt`)GrossAmount ,fd.DispatchDate,GROUP_CONCAT(fd.TransactionID)TransactionID,fd.panelInvoiceNo,fd.BillDate FROM f_dispatch fd  WHERE fd.isCancel=0 and fd.panelInvoiceNo='" + InvoiceNo + "' AND fd.PatientID='" + PatientId + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        List<CardInvoiceDetails> InvoiceList = new List<CardInvoiceDetails>();
        if (dt.Rows.Count > 0 && dt != null)
        {
            string PoolNr = "0";
            string PoolDesc = "";
            decimal SpendableAmount = 0;
            StringBuilder sbp = new StringBuilder();
            sbp.Append(" SELECT pae.PoolNr,pae.PoolDesc,pae.ApprovalAmount FROM panelapproval_emaildetails pae WHERE pae.IsThroughsmartCard=1 AND pae.TransactionID='" + TransactionId + "' AND pae.PanelID='" + PanelId + "' ORDER BY id DESC ");
            DataTable dtPool = StockReports.GetDataTable(sbp.ToString());

            if (dtPool.Rows.Count > 0 && dtPool != null)
            {
                PoolNr = Util.GetString(dtPool.Rows[0]["PoolNr"].ToString());
                PoolDesc = Util.GetString(dtPool.Rows[0]["PoolDesc"].ToString());
                SpendableAmount = Util.GetDecimal(dtPool.Rows[0]["ApprovalAmount"].ToString());
            }

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                decimal NhifPayable = Util.GetInt(StockReports.ExecuteScalar(" SELECT IFNULL( SUM( pa.`Amount`),0 )FROM  panel_amountallocation  pa WHERE pa.`PanelID` IN (728,701,504,429,683) AND pa.`TransactionID`  IN (" + dt.Rows[i]["TransactionID"].ToString() + ") "));

                CardInvoiceDetails ID = new CardInvoiceDetails();

                ID.amount = Util.GetDouble(dt.Rows[i]["BillAmount"].ToString());
                ID.gross_amount = Util.GetDouble(dt.Rows[i]["GrossAmount"].ToString());
                ID.invoice_date = Util.GetDateTime(dt.Rows[i]["BillDate"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                ID.invoice_number = Util.GetString(dt.Rows[i]["panelInvoiceNo"].ToString());
                ID.invoice_ref_number = "";
                ID.pool_number = PoolNr;
                ID.service_type = PoolDesc;
                ID.lines = GetCardInvoiceLinesDetailsIpd(dt.Rows[i]["TransactionID"].ToString());
                ID.payment_modifiers = GetCardInvoicePaymentModifiersDetailsIpd(InvoiceNo, PatientId, SpendableAmount, Util.GetDecimal(ID.gross_amount), NhifPayable, TransactionId);
                InvoiceList.Add(ID);
            }

        }



        return InvoiceList;
    }

    public List<CardInvoiceLinesDetails> GetCardInvoiceLinesDetailsIpd(string TransactionId)
    {



        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ltd.GrossAmount,ltd.Rate,ltd.Quantity,ltd.EntryDate,ltd.ItemID,ltd.ItemName,(  SELECT cm.NAME FROM f_categorymaster cm INNER JOIN f_subcategorymaster sm ON sm.CategoryID=cm.CategoryID WHERE sm.SubcategoryID= ltd.SubcategoryID )ServiceType FROM f_ledgertnxdetail ltd WHERE ltd.TransactionID in (" + TransactionId + ") AND ltd.IsVerified<>2");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        List<CardInvoiceLinesDetails> InvoiceLineList = new List<CardInvoiceLinesDetails>();
        if (dt.Rows.Count > 0 && dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CardInvoiceLinesDetails ID = new CardInvoiceLinesDetails();

                ID.amount = Util.GetDouble(dt.Rows[i]["GrossAmount"].ToString());
                ID.unit_price = Util.GetDouble(dt.Rows[i]["Rate"].ToString());
                ID.quantity = Util.GetDouble(dt.Rows[i]["Quantity"].ToString());

                ID.charge_date = Util.GetDateTime(dt.Rows[i]["EntryDate"].ToString()).ToString("yyyy-MM-dd");
                ID.charge_time = Util.GetDateTime(dt.Rows[i]["EntryDate"].ToString()).ToString("HH:mm:ss");
                ID.additional_info = "";
                ID.item_code = Util.GetString(dt.Rows[i]["ItemID"].ToString());
                ID.item_name = Util.GetString(dt.Rows[i]["ItemName"].ToString());

                ID.pre_authorization_code = "";
                ID.service_group = Util.GetString(dt.Rows[i]["ServiceType"].ToString());

                InvoiceLineList.Add(ID);
            }

        }


        return InvoiceLineList;
    }

    public List<CardInvoicePaymentModifiersDetails> GetCardInvoicePaymentModifiersDetailsIpd(string InvoiceNo, string PatientId, decimal SpendableAmount, decimal BillAmount, decimal NhifAmount, string TransactionId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT SUM(fd.`GrossAmount`-fd.`DiscAmt`-fd.`PanelAmount`)PatientPaybleAmt FROM f_dispatch fd  WHERE fd.isCancel=0 and fd.panelInvoiceNo='" + InvoiceNo + "' AND fd.PatientID='" + PatientId + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        List<CardInvoicePaymentModifiersDetails> InvoiceLineList = new List<CardInvoicePaymentModifiersDetails>();

        if (NhifAmount <= 0)
        {

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CardInvoicePaymentModifiersDetails ID = new CardInvoicePaymentModifiersDetails();
                if (BillAmount > SpendableAmount)
                {
                    ID.type = "0";
                }
                else
                {
                    ID.type = "1";

                }

                ID.amount = Util.GetDouble(dt.Rows[i]["PatientPaybleAmt"].ToString());
                ID.reference_number = "";

                InvoiceLineList.Add(ID);

            }
        }
        else
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CardInvoicePaymentModifiersDetails ID = new CardInvoicePaymentModifiersDetails();
                if (BillAmount > SpendableAmount)
                {
                    ID.type = "0";
                }
                else
                {
                    ID.type = "1";

                }

                ID.amount = Util.GetDouble(dt.Rows[i]["PatientPaybleAmt"].ToString()) - Util.GetDouble(NhifAmount);
                ID.reference_number = "";

                InvoiceLineList.Add(ID);

            }

            CardInvoicePaymentModifiersDetails Nhif = new CardInvoicePaymentModifiersDetails();

            DataTable Pdt = Encounter.GetPatientCardDetails(PatientId, TransactionId);
            string nhif_member_nr = "";
            string nhif_patient_relation = "";
            if (Pdt != null && Pdt.Rows.Count > 0)
            {
                nhif_member_nr = Pdt.Rows[0]["PolicyNo"].ToString();
                nhif_patient_relation = Pdt.Rows[0]["RelationWith_holder"].ToString();
            }

            Nhif.type = "5";
            Nhif.amount = Util.GetDouble(NhifAmount);
            Nhif.reference_number = "";

            Nhif.nhif_contributor_nr = "";
            Nhif.nhif_employer_code = "";
            Nhif.nhif_member_nr = "";
            Nhif.nhif_patient_relation = "";
            Nhif.nhif_site_nr = "";

            InvoiceLineList.Add(Nhif);


        }

        return InvoiceLineList;
    }



    public List<CardDiagnosis> GetCardDiagnosisIpd(string TransactionId)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" select cm.ICD_Code,icd.WHO_Full_Desc Name,'icd 10' CoadingSatnderd,true is_added_with_claim,true is_primary from cpoe_10cm_patient cm  ");
        sb.Append(" inner join icd_10_new icd on icd.ICD10_Code=cm.ICD_Code WHERE cm.TransactionID IN (" + TransactionId + ") AND cm.IsActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        List<CardDiagnosis> CardDiagList = new List<CardDiagnosis>();
        if (dt.Rows.Count > 0 && dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                CardDiagnosis Cd = new CardDiagnosis();
                Cd.code = dt.Rows[i]["ICD_Code"].ToString();
                Cd.coding_standard = dt.Rows[i]["CoadingSatnderd"].ToString();
                Cd.is_added_with_claim = true;
                Cd.name = dt.Rows[i]["Name"].ToString();
                Cd.primary = true;
                CardDiagList.Add(Cd);
            }

        }
        return CardDiagList;
    }



    public List<CardPreAuthorization> GetCardPreAuthorizationIpd(string TransactionId)
    {


        StringBuilder sb = new StringBuilder();

        List<CardPreAuthorization> InvoiceLineList = new List<CardPreAuthorization>();

        for (int i = 1; i < 1; i++)
        {
            CardPreAuthorization ID = new CardPreAuthorization();
            ID.code = "P150";
            ID.amount = 5000;
            ID.authorized_by = "Esther";
            ID.message = "Authorized up to 5000 by Esther";
            InvoiceLineList.Add(ID);

        }

        return InvoiceLineList;
    }




    public int UpdateIfClaimSubmittedIpd(string TransactionId, int ClaimId,string PanelID)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            int result1 = excuteCMD.DML(tnx, "UPDATE panel_amountallocation s SET s.IsClaimPosted=1,s.ClaimPostId=@ClaimId,ClaimPostedDate=Now(),ClaimPostedBy=@ClaimPostedBy WHERE s.TransactionId=@TransactionId  AND s.PanelID=@PanelID and  s.IsMerge=1 ", CommandType.Text, new
            {
                PanelID=PanelID,
                TransactionId = TransactionId,
                ClaimId = ClaimId,
                ClaimPostedBy = HttpContext.Current.Session["ID"].ToString()
            });

            tnx.Commit();
            return 1;

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }




}