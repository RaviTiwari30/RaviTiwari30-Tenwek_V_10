using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ValidationSoapHeader
/// </summary>
public class ValidationSoapHeader
{
    private string _Token;
    public ValidationSoapHeader()
        {
        }
    public ValidationSoapHeader(string Token)
        {
        this.Token = Token;
        }
    public string Token
        {
        get { return this.Token; }
        set { this.Token = value; }
        }
}