using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for MpesaRequstModel
/// </summary>
public class MpesaRequstModelSuccess
{
    public string MerchantRequestID { get; set; }
    public string CheckoutRequestID { get; set; }
    public string ResponseCode { get; set; }
    public string ResponseDescription { get; set; }
    public string CustomerMessage { get; set; }
     
}
public class MpesaRequstModelError
{
    public string requestId { get; set; }
    public string errorCode { get; set; }
    public string errorMessage { get; set; }
    
}
 