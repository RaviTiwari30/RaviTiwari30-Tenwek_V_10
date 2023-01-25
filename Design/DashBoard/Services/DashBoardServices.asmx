<%@ WebService Language="C#" Class="DashBoardServices" %>

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
using System.IO;
using Core;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[ScriptService]
public class DashBoardServices : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public string bindIPDBillingInfo(string IPDNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cfm.Name,(ltd.Rate*ltd.Quantity)Gross,");
        sb.Append(" ((ltd.Rate*ltd.Quantity)-ltd.Amount)Disc,(ltd.amount)Amt ");
        sb.Append(" FROM f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sm ON sm.subcategoryID = ltd.subcategoryID");
        sb.Append(" INNER JOIN f_configrelation cf ON cf.CategoryID = sm.CategoryID");
        sb.Append(" INNER JOIN f_configrelation_master cfm ON cfm.ID = cf.ConfigID");
        sb.Append(" WHERE ltd.IsVerified=1 AND ltd.IsPackage=0 AND ltd.TransactionID='ISHHI" + IPDNo + "' ");
        sb.Append(" GROUP BY cf.ConfigID");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
        
    }
    [WebMethod]
    public string bindAppDetail(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindAppDetail(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindIPDBillingDetail(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDBillingDetail(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindAppDetailPopUp(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindAppDetailPopUp(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindDocWiseAppDetailPopUp(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindDocWiseAppDetailPopUp(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["Doctor Name"] = "";
            row["Department"] = "Total";
            row["Total"] = dt.Compute("sum(Total)", "").ToString();
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindPatientcensusReport(string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT lt.Date,sm.Name,COUNT(*) CPatient FROM temp_for_date td LEFT OUTER JOIN f_ledgertransaction lt ON td.dt=lt.Date INNER JOIN appointment ap ON lt.LedgerTransactionNo=ap.LedgerTnxNo");
        sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubCategoryID");
        sb.Append(" WHERE lt.TypeOfTnx='OPD-APPOINTMENT' AND lt.IsCancel=0");
        sb.Append(" AND DATE(lt.Date)>='" + Convert.ToDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Convert.ToDateTime(ToDate).ToString("yyyy-MM-dd") + "'");
        sb.Append(" GROUP BY lt.Date,ltd.SubCategoryID");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataTable dt2 = new DataTable();
        if (dt != null && dt.Rows.Count > 0)
        {

        }
        StringBuilder sb1 = new StringBuilder();

        sb1.Append("SELECT sm.Name FROM f_subcategorymaster sm  INNER JOIN f_configrelation cf ON sm.CategoryID=cf.CategoryID AND ConfigID=5");
        DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {

            dt2.Columns.Add("Date");
            for (int i = 0; i < dt1.Rows.Count; i++)
            {
                dt2.Columns.Add(new DataColumn(dt1.Rows[i]["name"].ToString(), typeof(int)));

            }
            dt2.Columns.Add(("Total"), typeof(int));
            DateTime FDate = Util.GetDateTime(FromDate);
            DateTime TDate = Util.GetDateTime(ToDate);
            DataRow row = dt2.NewRow();

            while (FDate <= TDate)
            {

                dt2.Rows.Add(FDate.ToString("dd-MMM-yyyy"));

                FDate = FDate.AddDays(1);
                row["Date"] = FDate.ToString("dd-MMM-yyyy");
                //dt2.Rows.Add(row);
            }
            //set default value 0

            for (int i = 0; i < dt2.Rows.Count; i++)
            {
                for (int j = 1; j < dt2.Columns.Count; j++)
                {
                    dt2.Rows[i][j] = "0";
                }
            }

            for (int i = 0; i < dt2.Rows.Count; i++)
            {
                int total = 0;
                DataRow[] Drow = dt.Select("Date='" + Util.GetDateTime(dt2.Rows[i]["Date"]).ToString("yyyy-MM-dd") + "'");
                for (int j = 0; j < Drow.Length; j++)
                {
                    dt2.Rows[i][Drow[j]["Name"].ToString()] = Drow[j]["CPatient"].ToString();
                    total = total + Util.GetInt(Drow[j]["CPatient"].ToString());
                }
                dt2.Rows[i]["Total"] = total;
            }

            //sum
            DataRow SumRow = dt2.NewRow();
            SumRow[0] = "Total";
            for (int s = 1; s < dt2.Columns.Count; s++)
            {
                SumRow[s] = dt2.Compute("sum([" + dt2.Columns[s].ColumnName + "])", "").ToString();
            }
            dt2.Rows.Add(SumRow);


            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindBedDetailPopUp(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindBedDetailPopUp(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["RoomType"] = "Total";
            row["TotalBed"] = dt.Compute("sum(TotalBed)", "").ToString();
            row["AvailableBed"] = dt.Compute("sum(AvailableBed)", "").ToString();
            row["OccupiedBed"] = dt.Compute("sum(OccupiedBed)", "").ToString();
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindAddDetailPopUp(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindAddDetailPopUp(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["RoomType"] = "Total";
            row["Admission"] = dt.Compute("sum(Admission)", "").ToString();

            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindDateWiseAppPopUp(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindDateWiseAppPopUp(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["Date"] = "Total";
            row["Appointment"] = dt.Compute("sum(Appointment)", "").ToString();
            row["ConfirmAppointment"] = dt.Compute("sum(ConfirmAppointment)", "").ToString();
            row["CancelAppointment"] = dt.Compute("sum(CancelAppointment)", "").ToString();
            row["RescheduleAppointment"] = dt.Compute("sum(RescheduleAppointment)", "").ToString();
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindDateWiseIPDAdvSet(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindDateWiseIPDAdvSet(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["Date"] = "Total";
            row["Advance"] = dt.Compute("sum(Advance)", "").ToString();
            row["Settlement"] = dt.Compute("sum(Settlement)", "").ToString();
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";

    }
    [WebMethod]
    public string bindIPDPanelWise(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDPanelWise(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["Panel Name"] = "Total";
            row["TotalPatient"] = dt.Compute("sum(TotalPatient)", "").ToString();
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindIPDDepartmentWise(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDDepartmentWise(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["Name"] = "Total";
            row["TotalPatient"] = dt.Compute("sum(TotalPatient)", "").ToString();
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindIPDDetail(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDDetail(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindIPDBedOccupancy(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDBedOccupancy(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindOPDDiscount(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindOPDDiscount(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["BillDate"] = "";
            row["UHID"] = "Total";
            row["PName"] = "";
            row["Bill No."] = "";
            row["Panel"] = "";
            row["TypeOfTnx"] = "";
            row["DiscountAmt"] = dt.Compute("sum(DiscountAmt)", "").ToString();
            row["Discount Reason"] = "";
            row["Dis. Approved By"] = "";
            row["User"] = "";
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";

    }
    [WebMethod]
    public string bindLabTestWise(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindLabTestWise(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindMoneyCollection(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindMoneyCollection(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindTypeOfTnxWise(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindTypeOfTnxWise(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["Type of Transactions"] = "Total";
            row["Qty"] = dt.Compute("sum(Qty)", "").ToString();
            row["Gross"] = dt.Compute("sum(Gross)", "").ToString();
            row["Disc"] = dt.Compute("sum(Disc)", "").ToString();
            row["Net"] = dt.Compute("sum(Net)", "").ToString();
            row["Collected"] = dt.Compute("sum(Collected)", "").ToString();
            row["Outstanding"] = dt.Compute("sum(Outstanding)", "").ToString();
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
            
    }
    [WebMethod]
    public string bindProcedureDiff(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindProcedureDiff(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindProcedure(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindProcedure(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindOPDRegistration(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindOPDRegistration(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["Date"] = "";
            row["UHID"] = "";
            row["BillNo"] = "";
            row["PatientName"] = "";
            row["Sex"] = "";
            row["Consultant"] = "Total";
            row["RegFee"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("RegFee"));
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
        
    }
    [WebMethod]
    public string bindOPDCancel(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindOPDCancel(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindIPDCancel(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDCancel(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindIPDDiscount(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDDiscount(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindIPDItemCancel(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDItemCancel(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindIPDAdvanceSettlement(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDAdvanceSettlement(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindIPDRegister(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDRegister(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindTotalRevenue(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindTotalRevenue(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["Type"] = "Total";
            row["Gross"] = dt.Compute("sum(Gross)", "").ToString();
            row["Disc"] = dt.Compute("sum(Disc)", "").ToString();
            row["Net"] = dt.Compute("sum(Net)", "").ToString();
            row["Collection"] = dt.Compute("sum(Collection)", "").ToString();
            row["OutStanding"] = dt.Compute("sum(OutStanding)", "").ToString();
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindIPDCollection(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDCollection(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["IPDNo"] = "";
            row["TypeOfTnx"] = "Total";
            row["Cash"] = Math.Round(Util.GetDecimal(dt.Compute("sum(Cash)", "").ToString()));
            row["Cheque"] = Math.Round(Util.GetDecimal(dt.Compute("sum(Cheque)", "").ToString()));
            row["CreditCard"] = Math.Round(Util.GetDecimal(dt.Compute("sum(CreditCard)", "").ToString()));
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindIPDPanelWiseCollection(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDPanelWiseCollection(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["Name"] = "Total";
            row["Gross"] = dt.Compute("sum(Gross)", "").ToString();
            row["Disc"] = dt.Compute("sum(Disc)", "").ToString();
            row["Net"] = dt.Compute("sum(Net)", "").ToString();
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindOPDCollection(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindOPDCollection(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["UserName"] = "Total";
            row["Cash"] = dt.Compute("sum(Cash)", "").ToString();
            row["Cheque"] = dt.Compute("sum(Cheque)", "").ToString();
            row["CreditCard"] = dt.Compute("sum(CreditCard)", "").ToString();
            row["Credit"] = dt.Compute("sum(Credit)", "").ToString();
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
       
    }
    [WebMethod]
    public string bindOPDRefunds(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindOPDRefunds(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public string bindIPDServices(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDServices(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["TypeOfTnx"] = "Total";
            row["Gross"] = dt.Compute("sum(Gross)", "").ToString();
            row["Disc"] = dt.Compute("sum(Disc)", "").ToString();
            row["Net"] = dt.Compute("sum(Net)", "").ToString();
           
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

        }
        else
            return "";
    }
 [WebMethod]
    public string bindLabItemAnalysis(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindLabItemAnalysis(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["ItemName"] = "Total";
            row["GrossAmount"] = dt.Compute("sum(GrossAmount)", "").ToString();
            row["Discount"] = dt.Compute("sum(Discount)", "").ToString();
            row["NetAmount"] = dt.Compute("sum(NetAmount)", "").ToString();        
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }  
     [WebMethod]
 public string bindIPDPharmacy(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDPharmacy(FromDate, ToDate);
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
     [WebMethod]
     public string bindOPDCollectionDateWise(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindOPDCollectionDateWise(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["Date"] = "Total";
            row["Cash"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Cash"));
            row["Cheque"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Cheque")); 
            row["CreditCard"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("CreditCard")); 
            row["Credit"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Credit")); 
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
     public string bindOPDPanelCredit(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindOPDPanelCredit(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["UHID"] = "";
            row["PatientName"] = "";
            row["Panel"] = "";
            row["BillNo"] = "";
            row["BillDate"] = "Total";
            row["Gross"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Gross"));
            row["Disc"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Disc"));
            row["Net"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Net"));
            row["Credit"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Credit")); 
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindOPDCashOutstanding(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindOPDCashOutstanding(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();
            row["UHID"] = "";
            row["PatientName"] = "";
            row["Panel"] = "";
            row["FieldBoy"] = "";
            row["BillNo"] = "";
            row["TypeOfTnx"] = "";
            row["BillDate"] = "Total";
            row["Gross"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Gross"));
            row["Disc"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Disc"));
            row["Net"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Net"));            
            row["Due"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Due"));
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod]
    public string bindOPDPanelGroupOutstanding(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindOPDPanelGroupOutstanding(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();

            row["PanelGroup"] = "Total";
            row["Amt"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Amt"));
           
            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";

    }
    [WebMethod]
    public string bindOPDPanelOutstanding(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindOPDPanelOutstanding(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();

            row["Panel"] = "Total";
            row["Amt"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Amt"));

            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";

    }
    [WebMethod]
    public string bindIPDPackageDeptWise(string FromDate, string ToDate)
    {
        DataTable dt = DashBoard.bindIPDPackageDeptWise(FromDate, ToDate);
        if (dt.Rows.Count > 0)
        {
            DataRow row = dt.NewRow();

            row["Dept.Name"] = "Total";
            row["Gross"] = dt.AsEnumerable().Sum(dr => dr.Field<decimal>("Gross"));

            dt.Rows.Add(row);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";

    }
    
}