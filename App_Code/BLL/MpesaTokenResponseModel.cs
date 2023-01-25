using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web; 

public class MpesaTokenResponseModel
{
    [JsonProperty("access_token")]
    public string AccessToken { get; set; } 
  
    [JsonProperty("expires_in")]
    public int ExpiresIn { get; set; }
   
}