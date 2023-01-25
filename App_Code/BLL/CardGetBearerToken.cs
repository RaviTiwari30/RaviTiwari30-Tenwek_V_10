
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
public class AuthenticationHelper
{
    public static CardTokenResponseModel GetBearerToken()
    {
        CardTokenResponseModel tokenResponse = new CardTokenResponseModel();

        try
        {


             
            using (var client = CardClientHelper.GetClient(CardBasicData.UserName2, CardBasicData.Password2))
            {

                client.BaseAddress = new Uri(CardBasicData.TokenUrl);
                try
                {

                    string urldat = "oauth/token";

                    //string payload = System.IO.File.ReadAllText(pp);
                    System.Net.Http.HttpContent requestContent = new System.Net.Http.StringContent("grant_type=" + CardBasicData.grant_type + "&username=" + CardBasicData.UserName1 + "&password=" +
       CardBasicData.Password1, Encoding.UTF8, "application/x-www-form-urlencoded");
                    // var data = JsonConvert.DeserializeObject<JObject>(pp);
                    System.Net.Http.HttpResponseMessage responseMessage = client.PostAsync(urldat, requestContent).GetAwaiter().GetResult();
                    string status_code = responseMessage.StatusCode.ToString();
                    //Checking the response is successful or not which is sent using HttpClient  
                    if (responseMessage.IsSuccessStatusCode)
                    {
                        string jsonMessage;
                        using (Stream responseStream = responseMessage.Content.ReadAsStreamAsync().GetAwaiter().GetResult())
                        {
                            jsonMessage = new StreamReader(responseStream).ReadToEnd();
                        }
                        tokenResponse = (CardTokenResponseModel)JsonConvert.DeserializeObject(jsonMessage,
                        typeof(CardTokenResponseModel));
                        return tokenResponse;
                    }
                    else
                    {
                        return null;
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return null;
                }

                return null;

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