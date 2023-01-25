using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Web.Script.Services;
/// <summary>
/// Summary description for pulldatafinance
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class pulldatafinance : System.Web.Services.WebService {
    string FianceDatabaseName = "finance";
    string GlobalUsername = "Test";
    string GlobalPassword = "123456";
    public pulldatafinance () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    //[WebMethod]
    //public string HelloWorld() {
    //    return "Hello World";
    //}
    [WebMethod, ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = false)]
    public string Currency_Conversion(string CURR_SPECIFIC, string CURR_BASE, decimal RATE, DateTime EFFECTIVE_DATE,string Username, string Password)
    {
        if (Username != GlobalUsername)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "Wrong Username" });
        }
        else if (Password != GlobalPassword)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "Wrong Password" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            string sqlCurrency_Conversion = "INSERT INTO " + FianceDatabaseName + ".curr$CONV$MASTER(CURR_SPECIFIC,CURR_BASE,RATE,EFFECTIVE_DATE) VALUES(@vCURR_SPECIFIC,@vCURR_BASE,@vRATE,@vEFFECTIVE_DATE)";
            excuteCMD.DML(tnx, sqlCurrency_Conversion, CommandType.Text, new
            {
                vCURR_SPECIFIC = CURR_SPECIFIC,
                vCURR_BASE = CURR_BASE,
                vRATE = Util.GetDecimal(RATE),
                vEFFECTIVE_DATE = Util.GetDateTime(EFFECTIVE_DATE).ToString("yyyy-MM-dd"),
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "", message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = ex.Message, message = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod, ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = false)]
    public string Coa_Master(string COA_ID, string COA_Name, string COA_Type,string Username, string Password)
    {
        if (Username != GlobalUsername)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "Wrong Username" });
        }
        else if (Password != GlobalPassword)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "Wrong Password" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD(); 
        try {
            string Coa_master = "INSERT INTO " + FianceDatabaseName + ".coa$MASTER (COA_ID,COA_Name,COA_Type) VALUES (@vCOA_ID,@vCOA_Name,@vCOA_Type)";
            excuteCMD.DML(tnx, Coa_master, CommandType.Text, new
            {
                vCOA_ID = COA_ID,
                vCOA_Name = COA_Name,
                vCOA_Type = COA_Type,
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "", message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = ex.Message, message = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod, ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = false)]
    public string Supplier_Master(string SUPPLIERNAME, string CONTACTPERSON, string EOPHONE, string ADDRESS,string DRUG_LIC_NO, string Pin_NO, string CATEGORY,
        string SUPPLIERCODE, string COUNTRY, int IS_ASSET, string COAID, string VATType, string CURRENCY, int IsNewVendor,string Username, string Password)
    {
        if (Username != GlobalUsername)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "Wrong Username" });
        }
        else if (Password != GlobalPassword)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "Wrong Password" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try {
            string Coa_master = "INSERT INTO " + FianceDatabaseName + ".supplier$MASTER (SUPPLIERNAME,CONTACTPERSON,EOPHONE,ADDRESS, " +
                                " DRUG_LIC_NO,Pin_NO,CATEGORY,SUPPLIERCODE,COUNTRY,IS_ASSET,COAID,VATType,CURRENCY,IsNewVendor) " +
                                " VALUES (@vSUPPLIERNAME,@vCONTACTPERSON,@vEOPHONE,@vADDRESS,@vDRUG_LIC_NO,@vPin_NO,@vCATEGORY, " +
                                " @vSUPPLIERCODE,@vCOUNTRY,@vIS_ASSET,@vCOAID,@vVATType, " +
                                " @vCURRENCY,@vIsNewVendor)";
            excuteCMD.DML(tnx, Coa_master, CommandType.Text, new
            {
                vSUPPLIERNAME = SUPPLIERNAME,
                vCONTACTPERSON = CONTACTPERSON,
                vEOPHONE = EOPHONE,
                vADDRESS = ADDRESS,
                vDRUG_LIC_NO = DRUG_LIC_NO,
                vPin_NO = Pin_NO,
                vCATEGORY = CATEGORY,
                vSUPPLIERCODE = SUPPLIERCODE,
                vCOUNTRY = COUNTRY,
                vIS_ASSET = IS_ASSET,
                vCOAID = COAID,
                vVATType = VATType,
                vCURRENCY = CURRENCY,
                vIsNewVendor = IsNewVendor
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "", message = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = ex.Message, message = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
