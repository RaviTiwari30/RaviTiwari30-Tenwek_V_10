using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.IO;
using System.Net;
 
public class MpesaGetAccessToken
{
    public static MpesaTokenResponseModel GetMpesaAccessToken()
    {
        MpesaTokenResponseModel tokenResponse = new MpesaTokenResponseModel();

        try
        { 

            using (var client = MPesaClientHelper.GetClient(MPesaBasicData.ConsumerKey, MPesaBasicData.SecrateKey))
            {

                //specify to use TLS 1.2 as default connection
                System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls; 
                client.BaseAddress = new Uri(MPesaBasicData.BaseUrl);                 
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                try
                {
                    string urldat = "oauth/v1/generate?grant_type=client_credentials";

                    HttpResponseMessage Res = client.GetAsync(urldat).GetAwaiter().GetResult();
                    string status_code = Res.StatusCode.ToString();

                    if (Res.IsSuccessStatusCode)
                    {
                        string jsonMessage;
                        using (Stream responseStream = Res.Content.ReadAsStreamAsync().GetAwaiter().GetResult())
                        {
                            jsonMessage = new StreamReader(responseStream).ReadToEnd();
                        }
                        tokenResponse = (MpesaTokenResponseModel)JsonConvert.DeserializeObject(jsonMessage,
                        typeof(MpesaTokenResponseModel));
                        return tokenResponse;
                    }
                    else
                    {
                        return null;
                    }
                }
                catch (Exception ex)
                {
                    return null;
                }

            }

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;

        }


    }
}