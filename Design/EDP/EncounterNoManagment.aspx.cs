using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_EncounterNoManagment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    [WebMethod(EnableSession = true)]
    public static string GetDataToFill(string PatientId, string FromDate, string ToDate, string EncounterNo)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();

            sbnew.Append(" SELECT CONCAT(pm.Title,' ',pm.PName)NAME,pm.Age,pm.Gender Sex,pe.EncounterNo EncunterNo, ");
            sbnew.Append(" pe.ID EncounterId,pe.PatientID PatientId,DATE_FORMAT( pe.DateTime ,'%d-%b-%Y' )EntryDate, ");
            sbnew.Append(" IF(pe.Active=1,'Open','Closed')STATUS,IF( pe.Active=1,1,0)IsActive, if( IFNULL(pe.SessionID,0)<>0,'Yes','No')IsSmartCard  ");
            sbnew.Append(" FROM patient_encounter pe ");
            sbnew.Append(" INNER JOIN patient_master pm ON pm.PatientID=pe.PatientID ");
            if (PatientId != "")
            {
                sbnew.Append(" WHERE pe.PatientID='" + PatientId + "' ");
            }
            else if (EncounterNo != "")
            {
                sbnew.Append(" WHERE pe.EncounterNo='" + EncounterNo + "' ");
            }
            else
            {
                if (FromDate != "" && ToDate == "")
                {
                    sbnew.Append(" WHERE  DATE(pe.DateTime) >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' ");                    
                }
                else if (FromDate == "" && ToDate != "")
                {
                    sbnew.Append(" WHERE  DATE(pe.DateTime) <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");                   
                }
                else 
                {
                    sbnew.Append(" WHERE  DATE(pe.DateTime) between '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' ");
                    sbnew.Append("     and '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
                }
            }
            sbnew.Append(" ORDER BY pe.ID DESC ");
                        
            DataTable dt = StockReports.GetDataTable(sbnew.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

        }
    }



    [WebMethod(EnableSession = true, Description = "Open Encounter No")]
    public static string Open(int Id)
    {


        int SessionID = Util.GetInt(StockReports.ExecuteScalar("SELECT IFNULL(pe.SessionID,0) FROM patient_encounter pe WHERE pe.id='" + Id + "'"));

        if (SessionID!=0)
        {
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "This Encounter Belong to Smart Card ,You can't Re-Opne it " });

        }





        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            StringBuilder sb = new StringBuilder();

            sb.Append(" update patient_encounter set Active=1,UpdateBy=@EntryBy, ");
            sb.Append(" UpdateDate=now() where Id=@Id ");
            CountSave = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {

                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                Id = Id
            });



            if (CountSave > 0)
            {
                tnx.Commit();

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Open  Successfully" });

            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true, Description = "Close Encounter no")]
    public static string Close(int Id)
    {
        int CountSave = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {


            StringBuilder sb = new StringBuilder();

            sb.Append(" update patient_encounter set Active=0,UpdateBy=@EntryBy, ");
            sb.Append(" UpdateDate=now() where Id=@Id ");
            CountSave = excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
            {

                EntryBy = HttpContext.Current.Session["ID"].ToString(),
                Id = Id
            });



            if (CountSave > 0)
            {

                int SessionID = Util.GetInt(StockReports.ExecuteScalar("SELECT IFNULL(pe.SessionID,0) FROM patient_encounter pe WHERE pe.id='"+Id+"'"));

                if (SessionID!=0)
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
                                string urldat = "api/visit/"+SessionID+"/close-session ";
                                HttpResponseMessage Res = client.PutAsync(urldat, requestContent).GetAwaiter().GetResult();

                                string status_code = Res.StatusCode.ToString();
                                recivedata = Res.Content.ReadAsStringAsync().Result;
                                var data = Newtonsoft.Json.JsonConvert.DeserializeObject(recivedata);
                                //Checking the response is successful or not which is sent using HttpClient  
                                if (Res.IsSuccessStatusCode)
                                {
                                   
                                    tnx.Commit();

                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Closed  Successfully" });
                                }
                                else
                                {
                                    tnx.Rollback();
                                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Error occured ! during Closing Session Of Smart Card" });
                                }
                            }
                            catch (Exception ex)
                            {
                                ClassLog cl = new ClassLog();
                                cl.errLog(ex);
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Error occured ! during Closing Session Of Smart Card" });
                            }

                            
                        }

                    }
                    catch (Exception ex)
                    {

                        ClassLog cl = new ClassLog();
                        cl.errLog(ex); 
                        return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Error occured ! during Closing Session Of Smart Card" });
                    }

                     
                }
                else
                {
                    tnx.Commit();

                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Closed  Successfully" });
                }
                 
              

            }
            else
            {
                tnx.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



}