<%@ WebService Language="C#" Class="ReceiptEdit" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.Collections.Generic;



[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ReceiptEdit : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }




    [WebMethod(EnableSession=true)]
    public string SearchReceipts(string fromDate, string toDate, string receiptNo)
    {

        StringBuilder sqlCMD = new StringBuilder();
        sqlCMD.Append(" select r.ReceiptNo,r.AmountPaid,concat(em.Title,' ',em.Name)EmployeeName,lt.BillNo,group_concat(rd.PaymentMode)PaymentModes from f_reciept r  ");
        sqlCMD.Append(" inner join employee_master em on em.EmployeeID=r.Reciever ");
        sqlCMD.Append(" inner join f_receipt_paymentdetail rd on rd.ReceiptNo=r.ReceiptNo ");
        sqlCMD.Append(" left join f_ledgertransaction lt on lt.LedgertransactionNo=r.AsainstLedgerTnxNo ");
        sqlCMD.Append(" where r.IsCancel=0  and r.CentreID=@centreID and r.AmountPaid>0 ");

        if (string.IsNullOrEmpty(receiptNo))
            sqlCMD.Append(" and r.Date>=@fromDate and r.Date<=@toDate   ");
        else
            sqlCMD.Append(" and r.ReceiptNo=@receiptNo  ");

        sqlCMD.Append(" group by r.ReceiptNo ");

        ExcuteCMD excuteCMD = new ExcuteCMD();
        DataTable dt = excuteCMD.GetDataTable(sqlCMD.ToString(), CommandType.Text, new
        {
            fromDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
            toDate = Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"),
            receiptNo = receiptNo,
            centreID=HttpContext.Current.Session["CentreID"].ToString()
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    [WebMethod]
    public string GetPaymentDetails(string receipt)
    {
        if (Resources.Resource.AllowFiananceIntegration == "2")//
        {
            if (AllLoadData_IPD.CheckCollectionPostToFinance(receipt) > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = "Patient Final Bill Already Posted To Finance..." });
            }
        }
        ExcuteCMD excuteCMD = new ExcuteCMD();

        var dt = excuteCMD.GetDataTable("select * from f_receipt_paymentdetail r where r.ReceiptNo=@receipt", CommandType.Text, new
        {
            receipt = receipt
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }





    [WebMethod(EnableSession=true)]
    public string UpdateReceiptDetails(object paymentDetail, string receiptNo)
    {
        if (Resources.Resource.AllowFiananceIntegration == "1")//
        {
            if (AllLoadData_IPD.CheckCollectionPostToFinance(receiptNo) > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Patient Final Bill Already Posted To Finance..." });
            }
        }
        List<Receipt_PaymentDetail> dataPaymentDetail = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<Receipt_PaymentDetail>>(paymentDetail);
        MySqlConnection con = Util.GetMySqlCon();
        ExcuteCMD excuteCMD= new ExcuteCMD();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            excuteCMD.DML(tnx,"DELETE FROM  f_receipt_paymentdetail  WHERE ReceiptNo=@receiptNO", CommandType.Text, new {

                receiptNO = receiptNo
            });
                

            
            Receipt_PaymentDetail ObjReceiptPayment = new Receipt_PaymentDetail(tnx);
            for (int i = 0; i < dataPaymentDetail.Count; i++)
            {
                ObjReceiptPayment.PaymentModeID = Util.GetInt(dataPaymentDetail[i].PaymentModeID);
                ObjReceiptPayment.PaymentMode = Util.GetString(dataPaymentDetail[i].PaymentMode);
                ObjReceiptPayment.Amount = Util.GetDecimal(dataPaymentDetail[i].Amount);
                ObjReceiptPayment.ReceiptNo = receiptNo;
                ObjReceiptPayment.PaymentRemarks = Util.GetString(dataPaymentDetail[i].PaymentRemarks);
                ObjReceiptPayment.RefDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
                ObjReceiptPayment.RefNo = Util.GetString(dataPaymentDetail[i].RefNo);
                ObjReceiptPayment.BankName = Util.GetString(dataPaymentDetail[i].BankName);
                ObjReceiptPayment.C_Factor = Util.GetDecimal(dataPaymentDetail[i].C_Factor);
                ObjReceiptPayment.S_Amount = Util.GetDecimal(dataPaymentDetail[i].S_Amount);
                ObjReceiptPayment.S_CountryID = Util.GetInt(dataPaymentDetail[i].S_CountryID);
                ObjReceiptPayment.S_Currency = Util.GetString(dataPaymentDetail[i].S_Currency);
                ObjReceiptPayment.S_Notation = Util.GetString(dataPaymentDetail[i].S_Notation);
                ObjReceiptPayment.currencyRoundOff = Util.GetDecimal(dataPaymentDetail[i].currencyRoundOff);
                ObjReceiptPayment.swipeMachine = Util.GetString(dataPaymentDetail[i].swipeMachine);
                ObjReceiptPayment.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                ObjReceiptPayment.Hospital_ID = Util.GetString(HttpContext.Current.Session["HOSPID"].ToString());
                string PaymentID = ObjReceiptPayment.Insert().ToString();
                if (PaymentID == string.Empty)
                {
                    tnx.Rollback();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = "Error In Receipt Payment Details" });

                }

            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage   });
            

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage, message = ex.Message });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
       
    }
    


}